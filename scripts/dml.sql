 -- ================== INSERTS ======================

-- insert Products
INSERT INTO products (p_id, p_name, p_price, p_category)
VALUES
(1, 'Milk', 2, 'Dairy'),
(2, 'Bread', 1, 'Bakery'),
(3, 'Rice', 4, 'Grains'),
(4, 'Eggs', 3, 'Dairy'),
(5, 'Chicken', 6, 'Meat'),
(6, 'Sugar', 2, 'Groceries'),
(7, 'Cooking Oil', 4, 'Groceries'),
(8, 'Cheese', 3, 'Dairy'),
(9, 'Pasta', 1, 'Grains'),
(10, 'Orange Juice', 2, 'Beverages');



-- Insert Customers
INSERT INTO customers (c_id, c_name, c_phone_number)
VALUES
(1, 'Ahmad Ali', '0791111111'),
(2, 'Omar Khaled', '0792222222'),
(3, 'Sara Mohammad', '0793333333'),
(4, 'Lina Hassan', '0794444444'),
(5, 'Yousef Sami', '0795555555');


-- Insert Inventory
INSERT INTO inventory (p_id, quantity)
VALUES
(1, 50),
(2, 100),
(3, 30),
(4, 40),
(5, 15),
(6, 60),
(7, 20),
(8, 3),
(9, 80),
(10, 2);
