-- ETAP 1: PRZYGOTOWANIE WIDOKU "ZAUFANYCH ZAMÓWIEŃ" 
-- Cel: Połączenie jednorazowych identyfikatorów z unikalnym ID klienta
-- oraz wyznaczenie chronologii zakupów dla każdej osoby (numeracja zamówień).

CREATE OR REPLACE VIEW customers_orders AS
SELECT 
    d.order_id, 
    d.order_purchase_timestamp, 
    c.customer_unique_id,
    
    -- Nadaję kolejny numer każdemu zamówieniu danego klienta, 
    -- sortując od najstarszego do najnowszego zakupu
    ROW_NUMBER() OVER (
        PARTITION BY c.customer_unique_id 
        ORDER BY d.order_purchase_timestamp
    ) AS order_num

FROM olist_orders_dataset d
JOIN olist_customers_dataset c 
    ON d.customer_id = c.customer_id;

-- ETAP 2: WYSZUKIWANIE NAJWIERNIEJSZYCH KLIENTÓW I ANALIZA WYDATKÓW 
-- Cel: Obliczenie całkowitej wartości koszyka dla każdego klienta 
-- i przypisanie mu rangi (percentyla) na tle całej bazy kupujących.

-- Obliczenie całkowitych wydatków dla każdego unikalnego klienta
CREATE OR REPLACE VIEW total_spent_per_customer AS
SELECT 
    c.customer_unique_id, 
    SUM(p.payment_value) AS total_spent
FROM customers_orders c 
JOIN olist_order_payments_dataset p 
    ON c.order_id = p.order_id 
GROUP BY c.customer_unique_id;

-- Segmentacja klientów za pomocą Window Function
-- Używam PERCENT_RANK(), aby określić, jaki odsetek bazy wydaje mniej niż dany klient.
-- Sortowanie rosnące (ASC) gwarantuje, że klienci, którzy najwięcej wydali, dostaną wynik bliski 1.0.
CREATE OR REPLACE VIEW customers_percent_rank AS
SELECT 
    customer_unique_id, 
    total_spent,
    PERCENT_RANK() OVER (ORDER BY total_spent ASC) AS pct_rank
FROM total_spent_per_customer;

-- ETAP 3: ANALIZA RETENCJI I CZASU MIĘDZY ZAKUPAMI 
-- Cel: Zmierzenie, ile dni mija średnio, zanim klient wróci po kolejne zamówienie.
-- Używam podzapytania i funkcji LEAD do "spojrzenia w przyszłość" na kolejny zakup.
CREATE OR REPLACE VIEW next_order AS
SELECT 
    customer_unique_id, 
    order_num,
    current_order_date,
    next_order_date,
    
    -- Odejmuję daty od siebie i wyciągamy z wyniku same dni
    EXTRACT(DAY FROM (next_order_date - current_order_date)) AS days_between_orders
FROM (
    
    -- Podzapytanie: Wyciągam datę obecnego zakupu i podglądam datę następnego
    SELECT 
        customer_unique_id, 
        order_num,
        order_purchase_timestamp::TIMESTAMP AS current_order_date, 
        
        LEAD(order_purchase_timestamp::TIMESTAMP) OVER (
            PARTITION BY customer_unique_id 
            ORDER BY order_num
        ) AS next_order_date
        
    FROM customers_orders

) order_leads;
