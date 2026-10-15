
/*
=========================================================
Task 1: Database Schema Creation
Project: Supermarket Sales & Inventory Management System
=========================================================

Objective:
Create the database tables required to manage
customers, products, inventory, sales orders,
and order details.

Tables:
1. customers
   - Stores customer information.

2. products
   - Stores product details, prices, and categories.

3. inventory
   - Tracks available stock quantities for products.

4. orders
   - Stores customer orders, transaction dates,
     total sales amounts, and order statuses.

5. order_details
   - Stores products, quantities, and unit prices
     associated with sales orders.

Key Concepts:
- CREATE TABLE and DROP TABLE
- Primary Keys
- Foreign Keys
- Composite Primary Keys
- CHECK Constraints
- NOT NULL Constraints
- Relational Database Design

Purpose:
Establish a structured relational database that
supports sales processing, inventory management,
order cancellation, and business reporting.

=========================================================
*/


IF OBJECT_ID ('orders' , U) IS NOT NULL
  DROP TABLE orders
  GO;

CREATE TABLE orders
(
	order_id INT PRIMARY KEY,
	c_id INT,
	order_date DATE,
	total_sales INT,
	order_status NVARCHAR(50) NOT NULL

	CONSTRAINT fk_customer FOREIGN KEY (c_id) REFERENCES customers (c_id),
)

IF OBJECT_ID ('order_details' , U) IS NOT NULL
  DROP TABLE order_details
  GO;
CREATE TABLE order_details 
(
	order_id INT,
	p_id INT,
	quantity INT CHECK (quantity > 0),
	unit_price INT CHECK (unit_price > 0) 

	CONSTRAINT composite_primary_key PRIMARY KEY (order_id , p_id)
)

IF OBJECT_ID ('inventory' , U) IS NOT NULL
  DROP TABLE inventory
  GO;

CREATE TABLE inventory 
(
	p_id INT,
	quantity INT CHECK (quantity >= 0)

	CONSTRAINT fk_product FOREIGN KEY (p_id) REFERENCES products (p_id)
)

  IF OBJECT_ID ('customers' , U) IS NOT NULL
  DROP TABLE customers
  GO;

CREATE TABLE customers 
(
	c_id INT PRIMARY KEY,
	c_name NVARCHAR(50) NOT NULL,
	c_phone_number NVARCHAR(50)
)

  
IF OBJECT_ID ('products' , U) IS NOT NULL
  DROP TABLE products
  GO;

CREATE TABLE products 
(
	p_id INT PRIMARY KEY,
	p_name NVARCHAR(50) NOT NULL,
	p_price INT CHECK (p_price > 0),
	p_category NVARCHAR(50) NOT NULL
) 


ALTER TABLE customers
ADD CONSTRAINT unique_phoneNumber UNIQUE (c_phone_number)

ALTER TABLE Inventory
ADD CONSTRAINT fk_product_inv FOREIGN KEY (p_id) REFERENCES products (p_id)

ALTER TABLE orders
ADD CONSTRAINT checking_sales CHECK (total_sales >= 0)
