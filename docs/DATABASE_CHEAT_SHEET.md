# PostgreSQL Database Guide

## 🖥️ Visual Tools (GUI)
PostgreSQL does not have a built-in GUI like phpMyAdmin, but you can install these popular tools to view your tables visually:

1.  **pgAdmin 4** (Official, most common) - [Download](https://www.pgadmin.org/)
2.  **DBeaver** (Universal database tool, excellent UI) - [Download](https://dbeaver.io/)
3.  **IntelliJ IDEA / VS Code** - Both have excellent built-in database plugins.
    - **VS Code**: Install the "PostgreSQL" extension by Chris Kolkman or "SQLTools".

## ⌨️ Command Line (psql) Cheat Sheet

If you are using the terminal (`psql`), here are the essential commands to interrogate your database.

### Connection
```bash
# Connect to specific database
psql -U houssam -d suiviemot
```

### Exploration Commands
| Command | Description | MySQL Equivalent |
|---------|-------------|------------------|
| `\l` | List all databases | `SHOW DATABASES;` |
| `\c dbname` | Connect to a database | `USE dbname;` |
| `\dt` | List all tables in current db | `SHOW TABLES;` |
| `\d tablename` | Describe table structure (columns) | `DESCRIBE tablename;` |
| `\du` | List all users/roles | `SELECT * FROM mysql.user;` |
| `\dn` | List schemas | N/A |

### Common Queries
```sql
-- Select all users
SELECT * FROM "user";  -- Note: "user" must be quoted because it's a reserved keyword in Postgres!

-- Check patient profiles
SELECT * FROM patient_profile;

-- Check roles
SELECT * FROM role;
```

### Exiting
- `\q`: Quit psql
