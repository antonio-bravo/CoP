# Flyway Demo (SQL Server)

This demo repository shows a complete Flyway setup for SQL Server with:
- `flyway.conf` (connection + migration settings)
- `migrations/` (versioned `V...` scripts)
- `migrations-undo/` (undo `U...` scripts)
- `deploy.cmd` (Windows deploy wrapper)
- `migration_create.cmd` and `migration_create.sh` (timestamp-based script scaffolding)
- `.env` sample environment-driven secrets

---

## 1. Goals

1. Apply database schema changes with Flyway migrations.
2. Keep migrations in a structured folder for promotion and audit.
3. Support undo migration scripts for rollback strategies.
4. Use SQL Server as the target engine.

---

## 2. Config files

### `flyway.conf`

Base, user-agnostic configuration. In this demo it uses a local SQL Server database:
- `flyway.baselineOnMigrate=true`
- `flyway.url=jdbc:sqlserver://localhost:1433;databaseName=demo;trustServerCertificate=true`
- `flyway.user=demo`
- `flyway.password=demo`
- `flyway.locations=filesystem:./migrations,filesystem:./migrations-undo`

### `flyway.conf.template`

Example template with placeholders and integrated security path:
- `jdbc:sqlserver://<ServerName>.AMS-IRE-TT.COM:1433;databaseName=<database_name>;integratedSecurity=true;trustServerCertificate=true`
- migration location plus wildcard: `filesystem:./migrations,./sprint-*,filesystem:./migrations-undo`

---

## 3. Environment variables

Use `.env` to store private connection data and avoid hard-coding credentials.

### Example `demo/.env` (not committed):
```
FLYWAY_URL=jdbc:sqlserver://localhost:1433;databaseName=demo;trustServerCertificate=true
FLYWAY_USER=demo
FLYWAY_PASSWORD=demo
```

### Load for Linux/macOS/Git Bash:
```bash
export $(xargs < .env) && flyway migrate
```

### Load for Windows PowerShell:
```powershell
Get-Content .env | Foreach-Object { $name, $value = $_.split('=',2); [System.Environment]::SetEnvironmentVariable($name, $value) }
flyway migrate
```
### Load for Windows cmd (Batch):
```bash
for /f "tokens=*" %i in (.env) do set %i
```


---

## 4. Migration structure

Flyway uses filename prefixes to understand migration types:
- `V`: versioned migrations (applied once in order)
- `U`: undo migrations (Flyway Teams only; reverse a prior migration)
- `R`: repeatable migrations (re-run when checksum changes)

### 4.1 Versioned migrations (`migrations/`)

- `V20260317.095701__create_products_table.sql`
  - Creates `dbo.products` table: `id`, `name`, `price`
- `V20260318.100404__add stock column.sql`
  - Adds `stock INT DEFAULT 0` to `dbo.products`

### 4.2 Undo migrations (`migrations-undo/`)

- `U20260317.095701__create_products_table.sql`
  - Drops `dbo.products` table
- `U20260318.100404__add stock column.sql`
  - Drops `stock` column from `dbo.products`

---

## 5. Migration creation helpers

### `migration_create.cmd` (Windows)
- Creates new timestamped pair:
  - `migrations/V<timestamp>__<name>.sql`
  - `migrations-undo/U<timestamp>__<name>.sql`
- Enforces non-empty, no spaces migration name
- Uses UTC timestamp pattern `YYYYMMDD.HHMMSS`

### `migration_create.sh` (Linux/macOS)
- Same behavior as `migration_create.cmd`, for Bash shells

---

## 6. Deploy wrapper (Windows)

### `deploy.cmd`
1. Prints `flyway.conf`
2. Runs `flyway info -outOfOrder=true` and shows pending migrations
3. Prompts for confirmation
4. Runs `flyway -configFiles="./flyway.conf" migrate -outOfOrder=true`

Use this for safe interactive production-style apply.

---

## 7. SQL Server workflow

1. Set flyway connection vars: either in `flyway.conf`, environment variables, or both.
2. Add versioned SQL script in `migrations/`.
3. Add optional undo SQL script in `migrations-undo/`.
4. Validate with:
   - `flyway info -configFiles=./flyway.conf`
5. Execute migrate:
   - `flyway -configFiles=./flyway.conf migrate`
   - To migrate up to a specific version `V20260317.095701`:
     - `flyway -configFiles=./flyway.conf migrate -target="20260317.095701"`
   - To migrate up to the latest available version after target use:
     - `flyway -configFiles=./flyway.conf migrate -target="20260318.100404"`
6. To roll back (undo mode in Flyway Teams only):
   - `flyway undo -configFiles=./flyway.conf`

---

## 8. Recommended commands (demo)

### Windows `cmd`:
```bat
cd flyway/demo
.\deploy.cmd
```

### PowerShell:
```powershell
cd flyway/demo
Get-Content .env | Foreach-Object { $name, $value = $_.split('='); [System.Environment]::SetEnvironmentVariable($name, $value) }
flyway -configFiles='./flyway.conf' info
flyway -configFiles='./flyway.conf' migrate
```

### Bash:
```bash
cd flyway/demo
source .env
flyway -configFiles=./flyway.conf info
flyway -configFiles=./flyway.conf migrate
```

---

## 9. Notes

- This demo is built for SQL Server but can be adapted to other databases via URL, driver, and script syntax changes.
- Keep migration filenames immutable once applied; create new script for next change.
- `baselineOnMigrate` allows initial state in existing databases.
