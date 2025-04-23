```markdown
# 🛒 Retail Sales SQL Analysis Project

This project contains a series of SQL queries and data exploration tasks performed on a retail sales dataset.
The goal is to analyze customer behavior, product category performance, and sales trends.

---

## 📂 Database Setup

```sql
CREATE DATABASE project_sql;
```

### 📋 Table: `retail_sales`

```sql
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

---

## 🔍 Data Exploration Queries

- View all data:
  ```sql
  SELECT * FROM retail_sales;
  ```

- Record count:
  ```sql
  SELECT COUNT(*) FROM retail_sales;
  ```

- Unique customer count:
  ```sql
  SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
  ```

- Category count and list:
  ```sql
  SELECT COUNT(DISTINCT category), ARRAY_AGG(DISTINCT category) FROM retail_sales;
  ```

- Null check and cleanup:
  ```sql
  SELECT * FROM retail_sales WHERE
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR
    gender IS NULL OR age IS NULL OR category IS NULL OR
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

  DELETE FROM retail_sales WHERE
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR
    gender IS NULL OR age IS NULL OR category IS NULL OR
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
  ```

---

## 📊 Analytical Queries

- Sales made on `2022-11-05`:
  ```sql
  SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';
  ```

- Clothing transactions with quantity ≥ 4 in November 2022:
  ```sql
  SELECT * FROM retail_sales
  WHERE category = 'Clothing' AND quantity >= 4 AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';
  ```

- Total sales by category:
  ```sql
  SELECT category, SUM(total_sale) AS total_sale
  FROM retail_sales
  GROUP BY category
  ORDER BY total_sale DESC;
  ```

- Average age of 'Beauty' category customers:
  ```sql
  SELECT category, ROUND(AVG(age)) AS average_age
  FROM retail_sales
  WHERE category = 'Beauty'
  GROUP BY category;
  ```

- Transactions with sales > 1000:
  ```sql
  SELECT * FROM retail_sales
  WHERE total_sale > 1000
  ORDER BY total_sale DESC;
  ```

- Number of transactions by gender per category:
  ```sql
  SELECT category, gender, COUNT(transactions_id)
  FROM retail_sales
  GROUP BY category, gender
  ORDER BY category;
  ```

---

## 📅 Monthly Analysis

- Average sale per month & best-selling month of each year:
  ```sql
  WITH cte1 AS (
    SELECT EXTRACT(YEAR FROM sale_date) AS year,
           TO_CHAR(sale_date, 'FMMonth') AS month,
           EXTRACT(MONTH FROM sale_date) AS month_num,
           ROUND(AVG(total_sale)::numeric, 2) AS avg_sale
    FROM retail_sales
    GROUP BY year, month, month_num
  ),
  cte2 AS (
    SELECT year, month, avg_sale,
           RANK() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS rank
    FROM cte1
  )
  SELECT * FROM cte2 WHERE rank = 1;
  ```

---

## 🏆 Insights

- **Top 5 customers** by total sales:
  ```sql
  SELECT customer_id, SUM(total_sale) AS total_sale
  FROM retail_sales
  GROUP BY customer_id
  ORDER BY total_sale DESC
  LIMIT 5;
  ```

- **Unique customers** per category:
  ```sql
  SELECT category, COUNT(DISTINCT customer_id)
  FROM retail_sales
  GROUP BY category;
  ```

- **Shift-based order count**:
  ```sql
  SELECT shift, COUNT(*) FROM (
    SELECT CASE
      WHEN sale_time < '12:00:00' THEN 'Morning'
      WHEN sale_time BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'
      ELSE 'Evening'
    END AS shift
    FROM retail_sales
  ) AS shifts
  GROUP BY shift;
  ```
---

---

### 📌 Key Findings

#### 🧮 General Stats:
- **Total Transactions**: `1987`
- **Unique Customers**: `155`
- **Product Categories**: `3` → *Electronics, Clothing, Beauty*

---

#### 💰 Category-wise Sales:
| Category     | Total Sales |
|--------------|-------------|
| Electronics  | 311,445     |
| Clothing     | 309,995     |
| Beauty       | 286,790     |

---

#### 👥 Customer Demographics:
- **Average Age of Customers** in *Beauty* Category: **40 years**
- **Unique Customers per Category**:
  - Beauty: 141
  - Clothing: 149
  - Electronics: 144

---

#### 👨‍🦰 Gender Breakdown by Category:
| Category     | Female Transactions | Male Transactions |
|--------------|---------------------|-------------------|
| Beauty       | 330                 | 281               |
| Clothing     | 347                 | 351               |
| Electronics  | 335                 | 343               |

---

#### 🏆 Top 5 Customers by Total Sales:
| Customer ID | Total Sales |
|-------------|-------------|
| 3           | 38,440      |
| 1           | 30,750      |
| 5           | 30,405      |
| 2           | 25,295      |
| 4           | 23,580      |

---

#### ⏰ Sales by Shift:
| Shift     | Order Count |
|-----------|-------------|
| Morning   | 548         |
| Afternoon | 164         |
| Evening   | 1275        |

> 📊 *Evening* is the most active sales period.

---

## 📈 Tools Used

- **PostgreSQL**
- **SQL CTEs & Window Functions**
- **Date & Time Functions**
- **Aggregation & Ranking**
