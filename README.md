
<div align="center">

# 🛒 Supermarket Sales & Inventory Management System

### A SQL Server Database Project

**A database-driven system for managing supermarket sales, inventory, customer orders, and business reporting.**

<br>

![SQL Server](https://img.shields.io/badge/SQL_Server-Database-CC2927?style=for-the-badge&logo=microsoftsqlserver&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-Stored_Procedures-0078D4?style=for-the-badge)
![Status](https://img.shields.io/badge/Project-Completed-28A745?style=for-the-badge)

</div>

---

## 📖 Project Overview

The **Supermarket Sales & Inventory Management System** is a SQL Server project designed to simulate essential supermarket database operations.

The project focuses on building a structured relational database, implementing business rules through stored procedures, maintaining inventory consistency, and generating useful sales reports.

It demonstrates practical database development skills, including **SQL queries, relational database design, transactions, error handling, and data integrity**.

---

## ✨ Key Features

- **Customer Management:** Store customer information and associate customers with orders.
- **Product Management:** Maintain product information, categories, and prices.
- **Inventory Tracking:** Monitor available stock quantities.
- **Sales Processing:** Create sales orders and automatically reduce inventory.
- **Order Cancellation:** Cancel completed orders and restore inventory quantities.
- **Inventory Restocking:** Increase stock quantities through a stored procedure.
- **Sales Reporting:** Generate business reports using SQL queries.
- **Transaction Management:** Use transactions to protect database consistency.
- **Error Handling:** Validate operations and handle errors using T-SQL.

---

## 🗂️ Database Structure

The database consists of five main tables:

| Table | Description |
|---|---|
| `customers` | Stores customer information |
| `products` | Stores product information, prices, and categories |
| `inventory` | Tracks available quantities for products |
| `orders` | Stores customer orders, total sales, dates, and statuses |
| `order_details` | Stores products, quantities, and prices associated with orders |

### Database Relationships

- One customer can have multiple orders.
- One order can contain product details.
- One product can appear in multiple order details.
- Each product has at most one inventory record.
- Foreign keys maintain relationships between tables.

---

## 🏗️ Entity Relationship Diagram (ERD)

<div align="center">

**Database ERD**

<!-- Upload your ERD image to an images folder and uncomment the following line. -->

<!-- <img src="images/erd.png" alt="Supermarket Database ERD" width="850"> -->

</div>

---

## ⚙️ Stored Procedures

### 1. CreateSale

Processes a new supermarket sale.

**Responsibilities:**

- Validate customer and product existence.
- Validate the requested quantity.
- Verify sufficient inventory.
- Create the order and order details.
- Calculate the total sale amount.
- Reduce available inventory.
- Use transactions and error handling to prevent incomplete operations.

### 2. cancelOrder

Cancels an existing completed order.

**Responsibilities:**

- Verify that the order exists.
- Reject orders that are not eligible for cancellation.
- Update the order status to `Cancelled`.
- Restore the sold quantity to inventory.
- Protect database consistency using transactions.

### 3. RestockInventory

Adds new stock to the inventory.

**Responsibilities:**

- Validate the product and restock quantity.
- Update an existing inventory record.
- Insert a new inventory record when necessary.
- Use transactions and locking mechanisms to support safe inventory updates.

---

## 📊 Sales & Inventory Reports

The project includes eight SQL reports:

| # | Report | Purpose |
|---|---|---|
| 01 | Total Sales Revenue | Calculate revenue from completed orders |
| 02 | Orders Per Customer | Count completed orders for each customer |
| 03 | Top 5 Best-Selling Products | Identify products with the highest units sold |
| 04 | Low Stock Products | Find products with fewer than 10 units available |
| 05 | Revenue Per Category | Analyze sales revenue by product category |
| 06 | Monthly Sales Report | Track monthly revenue and completed orders |
| 07 | Customers With No Completed Orders | Identify customers without successful purchases |
| 08 | Average Order Value | Calculate the average value of completed orders |

### Example: Top 5 Best-Selling Products

```sql
SELECT TOP 5
    p.p_id,
    p.p_name,
    SUM(od.quantity) AS total_units_sold
FROM products AS p
INNER JOIN order_details AS od
    ON od.p_id = p.p_id
INNER JOIN orders AS o
    ON o.order_id = od.order_id
WHERE o.order_status = 'Completed'
GROUP BY
    p.p_id,
    p.p_name
ORDER BY total_units_sold DESC;
```

---

## 🔐 Data Integrity & Transaction Management

The project applies several database integrity techniques:

- **Primary Keys:** Ensure unique identification of records.
- **Foreign Keys:** Maintain valid relationships between tables.
- **CHECK Constraints:** Prevent invalid values such as negative inventory quantities.
- **Transactions:** Group related database operations into a single unit.
- **ROLLBACK:** Reverse incomplete operations when an error occurs.
- **TRY...CATCH:** Handle SQL execution errors.
- **Conditional Updates:** Prevent sales from reducing inventory below zero.

### Transaction Example

```sql
BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE inventory
    SET quantity = quantity - @quantity
    WHERE p_id = @productID
      AND quantity >= @quantity;

    IF @@ROWCOUNT = 0
        THROW 50001, 'Insufficient inventory.', 1;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
```

This example demonstrates how a conditional inventory update can prevent insufficient-stock sales.

---

## 🧪 Testing & Validation

Stored procedures were tested against successful and unsuccessful operations.

**Testing scenarios include:**

- Successful sale creation.
- Insufficient inventory.
- Invalid customer or product IDs.
- Invalid sale quantities.
- Duplicate order IDs.
- Order cancellation and inventory restoration.
- Inventory restocking.
- Transaction rollback and error handling.

These tests help verify that operations follow the intended business rules.

---

## 🛠️ Technologies & Concepts

| Technology / Concept | Usage |
|---|---|
| Microsoft SQL Server | Relational database management |
| T-SQL | Database queries and procedural logic |
| Stored Procedures | Implementing business operations |
| SQL Joins | Combining related tables |
| Aggregate Functions | Sales and inventory reporting |
| Transactions | Maintaining consistent operations |
| Constraints | Enforcing data integrity |
| Subqueries & NOT EXISTS | Filtering and validating records |

---

## 🚀 Getting Started

### Prerequisites

- Microsoft SQL Server
- SQL Server Management Studio (SSMS) or a compatible SQL client

### Setup

1. Clone or download this repository.
2. Open SQL Server Management Studio.
3. Create the supermarket database.
4. Execute the table creation scripts.
5. Insert the provided sample data.
6. Execute the stored procedure scripts.
7. Run the reporting queries.
8. Test sales, cancellations, and inventory updates.

> **Note:** Execute SQL scripts in dependency order to avoid foreign key and missing-object errors.

---

## 🎯 Learning Outcomes

Through this project, I practiced:

- Designing relational database schemas.
- Defining primary and foreign key relationships.
- Writing SQL queries for real business requirements.
- Developing stored procedures.
- Applying transactions and rollback mechanisms.
- Handling errors and validating input.
- Generating analytical reports.
- Maintaining data consistency across related tables.

---

## 🔮 Potential Future Improvements

- Support multiple products in a single sale transaction.
- Add supplier and purchasing management.
- Introduce inventory movement history.
- Implement role-based database permissions.
- Integrate the database with a backend API.
- Build a dashboard for sales analytics.

---

<div align="center">

### ⭐ Project Status: Completed

**Built as a practical SQL Server database development project.**

</div>
