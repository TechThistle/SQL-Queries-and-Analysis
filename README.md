# Data Analyst Internship - Task 4: SQL for Data Analysis

## 📌 Project Overview
This project contains SQL scripts for data extraction, manipulation, and analysis using an E-commerce database.

## 🛠️ Tools Used
- **Database:** MySQL Workbench / MySQL Server
- **SQL Concepts:** SELECT, JOINs, Subqueries, Aggregate Functions, Views, Indexes

## 📸 Output Screenshot
![SQL Result Output](screenshot.png)

---

## ❓ Interview Questions & Answers

### 1. What is the difference between WHERE and HAVING?
- **WHERE:** Filters rows **before** any grouping occurs. Cannot be used with aggregate functions directly.
- **HAVING:** Filters groups **after** `GROUP BY` execution. Specifically used to filter aggregated results.

### 2. What are the different types of joins?
- **INNER JOIN:** Returns records with matching values in both tables.
- **LEFT JOIN:** Returns all records from the left table and matched records from the right table.
- **RIGHT JOIN:** Returns all records from the right table and matched records from the left table.
- **FULL JOIN:** Returns all records when there is a match in either left or right table.

### 3. How do you calculate average revenue per user (ARPU) in SQL?
ARPU is calculated by dividing the total revenue by total unique users[cite: 1]:
```sql
SELECT SUM(p.price * od.quantity) / COUNT(DISTINCT c.customer_id) AS ARPU
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id;
