USE bike_store;

CREATE TABLE customers (
    customer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(30),
    last_name  VARCHAR(30),
    phone      VARCHAR(20) NOT NULL,
    email      VARCHAR(50) NOT NULL UNIQUE,
    street     VARCHAR(100) NOT NULL,
    city       VARCHAR(30) NOT NULL,
    state      CHAR(2) NOT NULL,
    zip_code   CHAR(5) NOT NULL,
    PRIMARY KEY (customer_id)
) ENGINE=InnoDB;

CREATE TABLE stores (
    store_id INT UNSIGNED NOT NULL,
    store_name VARCHAR(80),
    phone      VARCHAR(20) NOT NULL,
    email      VARCHAR(50) NOT NULL UNIQUE,
    street     VARCHAR(100) NOT NULL,
    city       VARCHAR(30) NOT NULL,
    state      CHAR(2) NOT NULL,
    zip_code   CHAR(5) NOT NULL,
    PRIMARY KEY (store_id)
) ENGINE=InnoDB;

CREATE TABLE categories (
    category_id INT UNSIGNED NOT NULL,
    category_name VARCHAR(100),
    PRIMARY KEY (category_id)
) ENGINE=InnoDB;

CREATE TABLE brands (
    brand_id INT UNSIGNED NOT NULL,
    brand_name VARCHAR(20),
    PRIMARY KEY (brand_id)
) ENGINE=InnoDB;

CREATE TABLE staffs (
    staff_id INT UNSIGNED NOT NULL,
    first_name VARCHAR(30),
    last_name  VARCHAR(30),
    email      VARCHAR(50) NOT NULL UNIQUE,
    phone      VARCHAR(20) NOT NULL,
    active     ENUM('YES','NO') NOT NULL DEFAULT 'YES',
    store_id   INT UNSIGNED NOT NULL,
    manager_id INT UNSIGNED NULL,
    PRIMARY KEY (staff_id),
    INDEX idx_staffs_store_id (store_id),
    INDEX idx_staffs_manager_id (manager_id),
    CONSTRAINT fk_staffs_store
        FOREIGN KEY (store_id) REFERENCES stores(store_id)
        ON UPDATE CASCADE,
    CONSTRAINT fk_staffs_manager
        FOREIGN KEY (manager_id) REFERENCES staffs(staff_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE products (
    product_id INT UNSIGNED NOT NULL,
    product_name VARCHAR(200) NOT NULL UNIQUE,
    brand_id INT UNSIGNED NULL,
    category_id INT UNSIGNED NOT NULL,
    model_year CHAR(4) NOT NULL,
    list_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (product_id),
    INDEX idx_products_brand_id (brand_id),
    INDEX idx_products_category_id (category_id),
    CONSTRAINT fk_products_brands
        FOREIGN KEY (brand_id) REFERENCES brands(brand_id)
        ON UPDATE CASCADE,
    CONSTRAINT fk_products_categories
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE orders (
    order_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    customer_id INT UNSIGNED NOT NULL,
    order_status ENUM('PENDING','CONFIRMED','PROCESSING','IN_TRANSIT','DELIVERED','CANCELLED','RETURNED')
        NOT NULL DEFAULT 'PENDING',
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    required_date TIMESTAMP NULL,
    shipped_date TIMESTAMP NULL,
    store_id INT UNSIGNED NOT NULL,
    staff_id INT UNSIGNED NOT NULL,
    PRIMARY KEY (order_id),
    INDEX idx_orders_customer_id (customer_id),
    INDEX idx_orders_store_id (store_id),
    INDEX idx_orders_staff_id (staff_id),
    INDEX idx_orders_order_status (order_status),
    INDEX idx_orders_order_date (order_date),
    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON UPDATE CASCADE,
    CONSTRAINT fk_orders_stores
        FOREIGN KEY (store_id) REFERENCES stores(store_id)
        ON UPDATE CASCADE,
    CONSTRAINT fk_orders_staffs
        FOREIGN KEY (staff_id) REFERENCES staffs(staff_id)
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE order_items (
    order_id INT UNSIGNED NOT NULL,
    item_id  INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    list_price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2),
    PRIMARY KEY (order_id, item_id),
    INDEX idx_order_items_product_id (product_id),
    CONSTRAINT fk_order_items_orders
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_order_items_products
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE stocks (
    store_id INT UNSIGNED NOT NULL,
    product_id INT UNSIGNED NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    PRIMARY KEY (store_id, product_id),
    CONSTRAINT fk_stocks_stores
        FOREIGN KEY (store_id) REFERENCES stores(store_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_stocks_products
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB;
