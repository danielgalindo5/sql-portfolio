# Bike Store (MySQL) — SQL Project

Relational database project built in MySQL using a bike store dataset.  
The project focuses on database design, primary/foreign keys, and business analytics queries.

## Tools
- MySQL 8+
- CSV datasets

## Dataset
The project uses the following CSV files:
- `brands.csv`
- `customers.csv`
- `orders.csv`
- `order_items.csv`
- `products.csv`
- `staffs.csv`
- `stocks.csv`
- `stores.csv`

## How to Run
Execute the SQL scripts in the following order:

1. `sql/00_create_db.sql`
2. `sql/01_schema.sql`
3. `sql/02_seed_data.sql`
4. `sql/03_load_data.sql`  
   (Update the absolute CSV path before running)
5. `sql/04_queries.sql`

## Database Design
Key design decisions:
Primary Keys
  - Composite primary key on `order_items (order_id, item_id)`
  - Composite primary key on `stocks (store_id, product_id)`
Foreign Keys
  - `orders.customer_id → customers.customer_id`
  - `orders.store_id → stores.store_id`
  - `orders.staff_id → staffs.staff_id`
  - `order_items.order_id → orders.order_id`
  - `order_items.product_id → products.product_id`
  - `products.brand_id → brands.brand_id`
  - `products.category_id → categories.category_id`
  - `staffs.manager_id → staffs.staff_id (self-reference)`



## Analytics & KPIs
The project includes analytical SQL queries focused on business insights, such as:
- Total revenue
- Average order value (AOV)
- Orders by status
- Revenue by store
- Top customers by total spend
- Best-selling products (by units and revenue)
- Revenue by product category
- Inventory and stock analysis

All analytics are written directly against base tables (no views), keeping the logic explicit and easy to follow.

## Purpose
This project demonstrates:
- Strong understanding of relational database design
- Correct use of PKs, FKs, and constraints
- Ability to translate business questions into SQL queries
- Clean, readable, and well-structured SQL suitable for analytics roles
