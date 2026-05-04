# sql-supply-chain-projects
Analyzed supply chain data using SQL to compare inventory vs production demand. Identified shortages, excess stock, and scrap cost drivers using JOINs, aggregations, and CTEs. Highlighted inefficiencies in planning, cost, and inventory utilization to support better decision-making.


# 📊 Supply Chain Inventory & Production Analysis (SQL Project)

## 🔹 Overview
This project analyzes supply chain data to understand why inventory levels appear sufficient while production still experiences shortages.

Using SQL, the analysis focuses on identifying gaps between inventory availability and production demand, along with cost inefficiencies in material usage and scrap.

---

## 🔹 Dataset
The project uses two main tables:

- **Inventory (`inventory_5x`)**
  - Product ID, Name, Category
  - On-hand Quantity
  - Unit Price, Total Value

- **Production Orders (`production_orders_5x`)**
  - Production Order ID, Job Name
  - Order Quantity, Material Used, Scrap
  - Order Dates, Status

---

## 🔹 Key Objectives

- Compare **inventory vs production demand**
- Identify **shortages and excess stock**
- Analyze **production efficiency and scrap**
- Evaluate **cost drivers (material + scrap cost)**
- Detect **slow-moving, high-value inventory**
- Compare **performance across product categories**

---

## 🔹 SQL Techniques Used

- JOINs (INNER JOIN, LEFT JOIN)
- Aggregations (SUM, AVG, COUNT)
- GROUP BY & HAVING
- Subqueries & EXISTS
- CTE (Common Table Expressions)
- Window Functions (RANK)
- Date Functions (DATEDIFF, MONTH)

---

## 🔹 Key Analysis Performed

### Inventory vs Demand
- Compared total inventory and production demand per product  
- Identified shortages using aggregation and HAVING clause  
- Detected excess inventory with no production demand using LEFT JOIN  

### Production & Efficiency
- Analyzed jobs with highest material usage and scrap  
- Identified longest-running production orders  
- Evaluated production status and in-progress jobs  

### Cost Analysis
- Calculated:
  - Total material cost per job  
  - Scrap cost per job and category  
  - Cost per unit produced  
- Identified top cost-driving jobs and categories  

### Category Insights
- Compared inventory and demand at category level  
- Identified categories with high stock imbalance  
- Highlighted efficient vs inefficient categories based on scrap and output  

---

