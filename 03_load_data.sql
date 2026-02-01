USE bike_store;


-- Replace this with your folder path on Windows:
-- YOUR_OWN_PATH/stores.csv, etc.


LOAD DATA LOCAL INFILE "YOUR_OWN_PATH/stores.csv"
INTO TABLE stores
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(store_id, store_name, phone, email, street, city, state, zip_code);

LOAD DATA LOCAL INFILE "YOUR_OWN_PATH/customers.csv"
INTO TABLE customers
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(customer_id, first_name, last_name, phone, email, street, city, state, zip_code);

LOAD DATA LOCAL INFILE "YOUR_OWN_PATH/brands.csv"
INTO TABLE brands
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(brand_id, brand_name);

LOAD DATA LOCAL INFILE "YOUR_OWN_PATH/products.csv"
INTO TABLE products
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(product_id, product_name, brand_id, category_id, model_year, list_price);

LOAD DATA LOCAL INFILE "YOUR_OWN_PATH/staffs.csv"
INTO TABLE staffs
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(staff_id, first_name, last_name, email, phone, active, store_id, manager_id);

LOAD DATA LOCAL INFILE "{{YOUR_OWN_PATH}}/orders.csv"
INTO TABLE orders
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(order_id, customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id);

LOAD DATA LOCAL INFILE "YOUR_OWN_PATH/order_items.csv"
INTO TABLE order_items
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(order_id, item_id, product_id, quantity, list_price, discount);

LOAD DATA LOCAL INFILE "YOUR_OWN_PATH/stocks.csv"
INTO TABLE stocks
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(store_id, product_id, quantity);
