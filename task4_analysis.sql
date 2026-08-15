-- ======================================================
-- DATA ANALYST INTERNSHIP - TASK 4: SQL FOR DATA ANALYSIS
-- ======================================================

-- 1. Database Creation
CREATE DATABASE IF NOT EXISTS Ecommerce_SQL_Database;
USE Ecommerce_SQL_Database;

-- 2. Drop existing tables if re-running
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

-- 3. Create Tables
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE OrderDetails (
    order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- 4. Insert Sample Data
INSERT INTO Customers (name, email, city) VALUES
('Rahul Sharma', 'rahul@example.com', 'Delhi'),
('Priya Patel', 'priya@example.com', 'Mumbai'),
('Amit Verma', 'amit@example.com', 'Delhi'),
('Neha Singh', 'neha@example.com', 'Bangalore');

INSERT INTO Products (product_name, category, price) VALUES
('Laptop', 'Electronics', 55000.00),
('Smartphone', 'Electronics', 20000.00),
('Headphones', 'Accessories', 2500.00),
('Desk Chair', 'Furniture', 7500.00);

INSERT INTO Orders (customer_id, order_date) VALUES
(1, '2026-03-01'),
(2, '2026-03-02'),
(1, '2026-03-05'),
(3, '2026-03-06');

INSERT INTO OrderDetails (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 3, 2),
(2, 2, 1),
(3, 3, 1),
(4, 4, 2);

-- ======================================================
-- DEMONSTRATING ALL TASK REQUIREMENTS (HINTS A - F)
-- ======================================================

-- Hint a: SELECT, WHERE, ORDER BY, GROUP BY
SELECT city, COUNT(customer_id) AS total_customers
FROM Customers
WHERE city IN ('Delhi', 'Mumbai')
GROUP BY city
ORDER BY total_customers DESC;

-- Hint b: INNER JOIN
SELECT c.name, o.order_id, o.order_date
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id;

-- Hint b: LEFT JOIN
SELECT c.name, o.order_id
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id;

-- Hint b: RIGHT JOIN
SELECT c.name, o.order_id
FROM Customers c
RIGHT JOIN Orders o ON c.customer_id = o.customer_id;

-- Hint c & d: Subquery + Aggregate Functions (SUM, AVG)
SELECT c.name, SUM(p.price * od.quantity) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
GROUP BY c.customer_id, c.name
HAVING total_spent > (
    SELECT AVG(order_total)
    FROM (
        SELECT SUM(p2.price * od2.quantity) AS order_total
        FROM Orders o2
        JOIN OrderDetails od2 ON o2.order_id = od2.order_id
        JOIN Products p2 ON od2.product_id = p2.product_id
        GROUP BY o2.order_id
    ) AS sub
);

-- Hint e: Create View for Analysis
CREATE OR REPLACE VIEW CustomerOrderSummary AS
SELECT 
    c.customer_id,
    c.name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COALESCE(SUM(p.price * od.quantity), 0) AS total_spent
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN OrderDetails od ON o.order_id = od.order_id
LEFT JOIN Products p ON od.product_id = p.product_id
GROUP BY c.customer_id, c.name;

-- Query the created view
SELECT * FROM CustomerOrderSummary;

-- Hint f: Optimize Queries with Indexes
CREATE INDEX idx_orders_customer_id ON Orders(customer_id);
CREATE INDEX idx_orderdetails_product_id ON OrderDetails(product_id);