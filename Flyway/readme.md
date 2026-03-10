# Flyway: Database Migrations Made Easy
## 1. The Problem (3 min)

* The "Manual Chaos": We use Git for code, but how do we handle DB changes?
* Common issues:
* "It works on my machine" (but the production DB is missing a column).
   * Manually running SQL scripts via Slack or email.
   * No source of truth for the database schema.
* The Solution: Flyway. It’s version control for your database.

## 2. How it Works (5 min)

* The Metadata Table: Flyway creates a table called flyway_schema_history. It tracks every script executed, the date, and its status.
* Migration Types:
* Versioned (V): Unique version number. Applied once. (e.g., V1__Initial_setup.sql).
   * Repeatable (R): Re-runs whenever the file content changes. Great for Views or Stored Procedures.
* Naming Convention (Crucial):
* V<Number>__<Description>.sql (Note the double underscore).

## 3. Core Commands (2 min)

* migrate: Scans the folder, compares it to the history table, and applies new scripts.
* info: Tells you which migrations are applied, pending, or failed.
* validate: Ensures local scripts haven't been tampered with (checksum check).

## 4. Live Demo Script (8 min)

* Step 1: Show an empty database.
* Step 2: Add V1__Create_users_table.sql. Run flyway migrate. Show the new table and the history log.
* Step 3: Add V2__Add_phone_to_users.sql. Run flyway migrate again. Show the evolution.
* Step 4 (The "Cool" Part): Edit the text inside V1 and run flyway info. It will throw an error because the Checksum changed. This proves Flyway protects your history.

## 5. Summary & Key Takeaways (2 min)

* Consistency: Every environment (Dev, QA, Prod) is identical.
* Automation: Integrates perfectly into CI/CD pipelines.
* Simplicity: Plain SQL. No complex DSLs to learn.

------------------------------
## Quick Demo SQL Snippets (Copy-paste ready)
File: V1__Create_products.sql
```sql
CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2)
);
```
File: V2__Add_stock_column.sql
```sql
ALTER TABLE products ADD COLUMN stock INT DEFAULT 0;
```
Check Status command:
```
flyway info
```
Apply Changes command:
```
flyway migrate
```
