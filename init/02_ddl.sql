CREATE TABLE dim_geography (
    geo_id  SERIAL PRIMARY KEY,
    city    TEXT,
    state   TEXT,
    country TEXT
);

CREATE TABLE dim_pet (
    pet_id       SERIAL PRIMARY KEY,
    type         TEXT,
    breed        TEXT,
    pet_category TEXT
);

CREATE TABLE dim_customer (
    customer_id  SERIAL PRIMARY KEY,
    first_name   TEXT,
    last_name    TEXT,
    age          INT,
    email        TEXT UNIQUE,
    country      TEXT,
    postal_code  TEXT,
    pet_id       INT REFERENCES dim_pet(pet_id)
);

CREATE TABLE dim_seller (
    seller_id   SERIAL PRIMARY KEY,
    first_name  TEXT,
    last_name   TEXT,
    email       TEXT UNIQUE,
    country     TEXT,
    postal_code TEXT
);

CREATE TABLE dim_supplier (
    supplier_id  SERIAL PRIMARY KEY,
    name         TEXT,
    contact      TEXT,
    email        TEXT,
    phone        TEXT,
    address      TEXT,
    city         TEXT,
    country      TEXT
);

CREATE TABLE dim_category (
    category_id SERIAL PRIMARY KEY,
    name        TEXT
);

CREATE TABLE dim_brand (
    brand_id SERIAL PRIMARY KEY,
    name     TEXT
);

CREATE TABLE dim_product (
    product_id   SERIAL PRIMARY KEY,
    name         TEXT,
    category_id  INT REFERENCES dim_category(category_id),
    brand_id     INT REFERENCES dim_brand(brand_id),
    supplier_id  INT REFERENCES dim_supplier(supplier_id),
    price        NUMERIC,
    weight       NUMERIC,
    color        TEXT,
    size         TEXT,
    material     TEXT,
    description  TEXT,
    rating       NUMERIC,
    reviews      INT,
    release_date DATE,
    expiry_date  DATE
);

CREATE TABLE dim_store (
    store_id    SERIAL PRIMARY KEY,
    store_name  TEXT,
    store_phone TEXT,
    store_email TEXT,
    geo_id      INT REFERENCES dim_geography(geo_id)
);

CREATE TABLE fact_sales (
    sale_id     SERIAL PRIMARY KEY,
    sale_date   DATE,
    customer_id INT REFERENCES dim_customer(customer_id),
    seller_id   INT REFERENCES dim_seller(seller_id),
    product_id  INT REFERENCES dim_product(product_id),
    store_id    INT REFERENCES dim_store(store_id),
    quantity    INT,
    total_price NUMERIC
);