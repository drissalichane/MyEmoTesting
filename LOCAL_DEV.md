# How to Run MyEmoHealth Locally

## Prerequisites
- Java 17+
- Node.js & npm
- Flutter SDK
- PostgreSQL

## 1. Database Setup
Ensure PostgreSQL is running on port **5432**.
You need to create a database and user matching `backend/src/main/resources/application.yml`.
**Note:** For PostgreSQL 15+, you must explicitly grant permissions on the `public` schema.

Run these commands in `psql` or pgAdmin:

```sql
-- 1. Create User and Database
CREATE USER houssam WITH PASSWORD '123456';
CREATE DATABASE suiviemot;
ALTER DATABASE suiviemot OWNER TO houssam;

-- 2. Connect to the new database (Important!)
\c suiviemot

-- 3. Grant Schema Permissions (Fixes "permission denied for schema public")
GRANT ALL ON SCHEMA public TO houssam;
```

## 2. Backend (Spring Boot)
The backend runs on port **8082**.

```bash
cd backend
mvn spring-boot:run
```

**Swagger UI / API Docs**: http://localhost:8082/swagger-ui.html (if enabled) or check `/api/health`.

## 3. Web Frontend (Angular)
The web admin runs on port **4200**.

```bash
cd frontend-web
npm install
npm start
```
Access: http://localhost:4200

## 4. Mobile App (Flutter)
Requires an emulator or physical device.

```bash
cd frontend_mobile
flutter pub get
flutter run
```

## Notes
- `RUNNING.md` appears to contain outdated instructions for a Jakarta EE/WildFly deployment. This project is configured as a Spring Boot application.
- The backend listens on port **8082**, not 8080.
- `docker-compose.yml` also references the old WildFly setup and may need updating to work with the Spring Boot Dockerfile.
