INSERT INTO dim_geography (city, state, country)
SELECT DISTINCT store_city, store_state, store_country
FROM mock_data
WHERE store_city IS NOT NULL;

INSERT INTO dim_pet (type, breed, pet_category)
SELECT DISTINCT customer_pet_type, customer_pet_breed, pet_category
FROM mock_data
WHERE customer_pet_type IS NOT NULL
  AND customer_pet_breed IS NOT NULL
  AND pet_category IS NOT NULL;

INSERT INTO dim_customer (first_name, last_name, age, email, country, postal_code, pet_id)
SELECT DISTINCT ON (m.customer_email)
    m.customer_first_name,
    m.customer_last_name,
    m.customer_age,
    m.customer_email,
    m.customer_country,
    m.customer_postal_code,
    p.pet_id
FROM mock_data m
LEFT JOIN dim_pet p
    ON p.type         = m.customer_pet_type
    AND p.breed       = m.customer_pet_breed
    AND p.pet_category = m.pet_category
ORDER BY m.customer_email;

INSERT INTO dim_seller (first_name, last_name, email, country, postal_code)
SELECT DISTINCT ON (seller_email)
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
FROM mock_data
WHERE seller_email IS NOT NULL
ORDER BY seller_email;

INSERT INTO dim_supplier (name, contact, email, phone, address, city, country)
SELECT DISTINCT ON (supplier_name)
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
FROM mock_data
WHERE supplier_name IS NOT NULL
ORDER BY supplier_name;

INSERT INTO dim_category (name)
SELECT DISTINCT product_category FROM mock_data WHERE product_category IS NOT NULL;

INSERT INTO dim_brand (name)
SELECT DISTINCT product_brand FROM mock_data WHERE product_brand IS NOT NULL;

INSERT INTO dim_product (
    name, category_id, brand_id, supplier_id,
    price, weight, color, size, material,
    description, rating, reviews, release_date, expiry_date
)
SELECT DISTINCT ON (m.product_name, m.product_brand)
    m.product_name,
    c.category_id,
    b.brand_id,
    s.supplier_id,
    m.product_price,
    m.product_weight,
    m.product_color,
    m.product_size,
    m.product_material,
    m.product_description,
    m.product_rating,
    m.product_reviews,
    m.product_release_date,
    m.product_expiry_date
FROM mock_data m
JOIN dim_category c ON c.name = m.product_category
JOIN dim_brand    b ON b.name = m.product_brand
JOIN dim_supplier s ON s.name = m.supplier_name
ORDER BY m.product_name, m.product_brand;

INSERT INTO dim_store (store_name, store_phone, store_email, geo_id)
SELECT DISTINCT ON (m.store_name)
    m.store_name,
    m.store_phone,
    m.store_email,
    g.geo_id
FROM mock_data m
JOIN dim_geography g
    ON g.city    = m.store_city
    AND g.country = m.store_country
ORDER BY m.store_name;

INSERT INTO fact_sales (sale_date, customer_id, seller_id, product_id, store_id, quantity, total_price)
SELECT
    m.sale_date,
    c.customer_id,
    se.seller_id,
    p.product_id,
    st.store_id,
    m.sale_quantity,
    m.sale_total_price
FROM mock_data m
JOIN dim_customer c  ON c.email      = m.customer_email
JOIN dim_seller   se ON se.email     = m.seller_email
JOIN dim_product  p  ON p.name       = m.product_name
                    AND p.brand_id   = (SELECT brand_id FROM dim_brand WHERE name = m.product_brand)
JOIN dim_store    st ON st.store_name = m.store_name;