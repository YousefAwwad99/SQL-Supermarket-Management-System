
/*
=========================================================
Task 3: Stored Procedures & Business Logic
Project: Supermarket Sales & Inventory Management System
=========================================================

Objective:
Implement stored procedures to automate sales
processing, order cancellation, and inventory
restocking while maintaining data integrity.

Purpose:
- Automate the creation of customer sales orders.
- Validate customers, products, and quantities.
- Calculate total sales based on product prices.
- Automatically decrease inventory after a sale.
- Prevent sales when stock is insufficient.
- Allow cancellation of completed orders.
- Restore inventory quantities after cancellation.
- Support inventory restocking for existing products.
- Create inventory records when they do not exist.
- Ensure data consistency using SQL transactions.
- Handle errors and roll back failed operations.
- Reduce inventory conflicts using conditional
  updates and database locking mechanisms.

Stored Procedures:
1. CreateSale
   - Creates a completed sales order.
   - Inserts order details.
   - Deducts the sold quantity from inventory.

2. cancelOrder
   - Validates an existing completed order.
   - Changes its status to Cancelled.
   - Restores the sold quantity to inventory.

3. RestockInventory
   - Validates the product and restock quantity.
   - Updates existing inventory quantities.
   - Inserts missing inventory records.

SQL Concepts:
- CREATE PROCEDURE
- IF EXISTS / NOT EXISTS
- Variables and Parameters
- BEGIN TRANSACTION / COMMIT / ROLLBACK
- TRY...CATCH
- THROW
- @@ROWCOUNT / @@TRANCOUNT
- UPDLOCK / HOLDLOCK
- INSERT / UPDATE

=========================================================
*/



IF OBJECT_ID ('CreateSale' , 'P') IS NOT NULL
	DROP PROCEDURE CreateSale;
GO


CREATE PROCEDURE CreateSale 
@orderID INT , @customerID INT , @productID INT , @quantity INT
AS
DECLARE @price INT , @tSales INT;
IF EXISTS 
(SELECT 1 FROM customers WHERE c_id = @customerID)
BEGIN
	IF EXISTS 
	(SELECT 1 FROM products WHERE p_id = @productID)
	BEGIN
		IF @quantity > 0
		BEGIN
			
			SET @price = (SELECT p_price FROM products WHERE p_id = @productID)
			SET @tSales = @quantity * @price
			BEGIN TRY
			BEGIN TRANSACTION
			-- INSERT INTO ORDER TABLE
			INSERT INTO orders (order_id , c_id , order_date , total_sales , order_status)
			VALUES (@orderID , @customerID , GETDATE() , @tSales , 'Completed')

			-- INSERT INTO ORDER DETAILS TABLE
			INSERT INTO order_details (order_id , p_id , quantity , unit_price)
			VALUES (@orderID , @productID , @quantity , @price)

			UPDATE inventory
			SET quantity = quantity - @quantity
			WHERE p_id = @productID
			AND quantity >= @quantity
			
			IF @@ROWCOUNT = 0
			BEGIN
			THROW 50001, 'Insufficient stock or product not found', 1
			END

			COMMIT;
			PRINT 'process has been done sucsessfully'
			END TRY
			BEGIN CATCH
			IF @@TRANCOUNT > 0
			ROLLBACK;

			PRINT '======================= ERROR OCCURED =================='
			PRINT ERROR_NUMBER();
			PRINT ERROR_MESSAGE();
			END CATCH
		END
		ELSE
		BEGIN
		PRINT 'please add quantity more than zero'
		END
	END
	ELSE
	BEGIN
	PRINT 'Product does not exists !!!'
	END
END
ELSE 
BEGIN
PRINT 'Customer does not exists !!'
END

-- ============ cancelOrder ===================


IF OBJECT_ID('cancelOrder' , 'P') IS NOT NULL
DROP PROCEDURE  cancelOrder
GO

CREATE PROCEDURE cancelOrder
@orderID INT
AS
DECLARE @sold_quantity INT , @productID INT

IF EXISTS (SELECT 1 FROM orders WHERE order_id = @orderID)
BEGIN
	IF EXISTS (SELECT 1 FROM orders WHERE order_id = @orderID AND order_status = 'Completed')
	BEGIN
		BEGIN TRY
		BEGIN TRANSACTION
		SET @sold_quantity = (SELECT quantity FROM order_details WHERE order_id = @orderID)

		SET @productID = (SELECT p_id FROM order_details WHERE order_id = @orderID)

		UPDATE orders
		SET order_status = 'Cancelled'
		WHERE order_id = @orderID AND order_status = 'Completed'

		IF @@ROWCOUNT = 0
		BEGIN
		THROW 50001, 'Order is not completed or does not exist', 1;
		END;

		UPDATE inventory
		SET quantity = quantity + @sold_quantity
		WHERE p_id = @productID
		

		IF @@ROWCOUNT = 0
		BEGIN
		THROW 50001, 'Inventory record not found', 1;
		END;

		COMMIT;
		PRINT 'Cancell has done sucsesfuuly';
		END TRY
		BEGIN CATCH
		IF @@TRANCOUNT > 0
		ROLLBACK;
		PRINT '============== ERROR OCCURED ==============='
		PRINT ERROR_NUMBER();
		PRINT ERROR_MESSAGE();
		END CATCH
	END
	ELSE
	BEGIN
	PRINT 'Only completed orders can be cancelled'
	END
END
ELSE
BEGIN
PRINT 'order is not exists!!'
END


-- ============== RestockInventory ===================

IF OBJECT_ID ('RestockInventory' , 'P') IS NOT NULL
DROP PROCEDURE RestockInventory
GO

CREATE PROCEDURE RestockInventory
@productID INT , @Quantity INT
AS
IF EXISTS (SELECT 1 FROM products WHERE p_id = @productID)
BEGIN
	IF @Quantity IS NOT NULL AND @Quantity > 0
	BEGIN
	BEGIN TRY
	BEGIN TRANSACTION
		IF EXISTS (SELECT 1 FROM inventory WITH (UPDLOCK, HOLDLOCK) WHERE @productID = p_id)
		BEGIN
			
			UPDATE inventory
			SET quantity = quantity + @Quantity
			WHERE p_id = @productID
			
			
		END
		
		ELSE
		INSERT INTO inventory (p_id , quantity) VALUES (@productID , @Quantity)
		COMMIT;
		PRINT 'DONE'
		END TRY
		
		BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK;
			PRINT '=============== ERROR OCCURED ==============='
			PRINT ERROR_NUMBER();
			PRINT ERROR_MESSAGE();
		END CATCH
	END
	ELSE
	BEGIN
	PRINT 'Quantity cant be null'
	END
END
ELSE
BEGIN
PRINT 'Product is not exists!!!!!'
END

