# How to Run MyEmoHealth Project

You have **three main options** to run the MyEmoHealth backend:

## 🚀 Option 1: Using Docker Compose (Recommended - Easiest)

This will run everything (database + backend) in containers automatically.

### Prerequisites
- Docker Desktop installed and running

### Steps

1. **Update docker-compose.yml credentials** (to match your local setup):
   ```bash
   cd c:\Users\byoud\OneDrive\Desktop\MyEmoHealth
   ```

2. **Start all services**:
   ```bash
   docker-compose up -d
   ```

3. **View logs** (to monitor startup):
   ```bash
   docker-compose logs -f backend
   ```

4. **Access the application**:
   - Backend API: http://localhost:8080/api
   - WildFly Admin Console: http://localhost:9990 (admin/admin123)
   - Database: localhost:5432

5. **Stop services**:
   ```bash
   docker-compose down
   ```

### Troubleshooting Docker
- If port 5432 is already in use (your local PostgreSQL), either:
  - Stop your local PostgreSQL: `Stop-Service postgresql-x64-17`
  - Or change the port in docker-compose.yml: `"5433:5432"`

---

## 🔧 Option 2: Local Development (Manual Setup)

Run the backend on your local machine with your existing PostgreSQL database.

### Prerequisites
- ✅ PostgreSQL installed and running (you have this)
- ✅ Database `suiviemot` created (you have this)
- Java 17 or higher
- Maven 3.8+
- WildFly application server (download from https://www.wildfly.org/downloads/)

### Steps

#### Step 1: Install WildFly (if not already installed)

1. Download WildFly 29: https://www.wildfly.org/downloads/
2. Extract to a location like `C:\wildfly-29.0.1.Final`
3. Add to PATH (optional):
   ```powershell
   $env:WILDFLY_HOME = "C:\wildfly-29.0.1.Final"
   ```

#### Step 2: Configure WildFly

1. **Start WildFly**:
   ```powershell
   cd C:\wildfly-29.0.1.Final\bin
   .\standalone.bat
   ```

2. **Add PostgreSQL JDBC Driver** (in a new terminal):
   ```powershell
   # Download PostgreSQL driver
   curl -o postgresql-42.6.0.jar https://jdbc.postgresql.org/download/postgresql-42.6.0.jar
   
   # Copy to WildFly
   copy postgresql-42.6.0.jar C:\wildfly-29.0.1.Final\standalone\deployments\
   ```

3. **Configure Datasource** (WildFly CLI):
   ```powershell
   cd C:\wildfly-29.0.1.Final\bin
   .\jboss-cli.bat --connect
   ```
   
   Then run these commands in the CLI:
   ```
   /subsystem=datasources/jdbc-driver=postgresql:add(driver-name=postgresql,driver-module-name=org.postgresql,driver-class-name=org.postgresql.Driver)
   
   data-source add --name=MyEmoHealthDS --jndi-name=java:jboss/datasources/MyEmoHealthDS --driver-name=postgresql --connection-url=jdbc:postgresql://localhost:5432/suiviemot --user-name=houssam --password=123456 --validate-on-match=true --background-validation=false --valid-connection-checker-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLValidConnectionChecker --exception-sorter-class-name=org.jboss.jca.adapters.jdbc.extensions.postgres.PostgreSQLExceptionSorter
   
   exit
   ```

#### Step 3: Build and Deploy

1. **Build the project**:
   ```powershell
   cd c:\Users\byoud\OneDrive\Desktop\MyEmoHealth\backend
   mvn clean package
   ```

2. **Deploy to WildFly**:
   ```powershell
   copy target\myemohealth-api.war C:\wildfly-29.0.1.Final\standalone\deployments\
   ```

3. **Check deployment** (watch WildFly console for):
   ```
   Deployed "myemohealth-api.war"
   ```

4. **Access the application**:
   - Backend API: http://localhost:8080/myemohealth-api/api
   - Test endpoint: http://localhost:8080/myemohealth-api/api/auth/login

#### Step 4: Verify Database Tables

After deployment, Hibernate should create all tables automatically:

```powershell
$env:PGPASSWORD='123456'; psql -U houssam -h localhost -d suiviemot -c "\dt"
```

You should see tables like: `user`, `role`, `patient_profile`, `phase`, etc.

---

## 🏃 Option 3: Quick Test with Maven (Development Only)

For quick testing without WildFly (uses embedded server).

### Steps

1. **Add TomEE Maven Plugin** to `pom.xml` (if not already there):
   ```xml
   <plugin>
       <groupId>org.apache.tomee.maven</groupId>
       <artifactId>tomee-maven-plugin</artifactId>
       <version>9.1.0</version>
       <configuration>
           <tomeeVersion>9.1.0</tomeeVersion>
           <tomeeClassifier>plus</tomeeClassifier>
       </configuration>
   </plugin>
   ```

2. **Run with Maven**:
   ```powershell
   cd c:\Users\byoud\OneDrive\Desktop\MyEmoHealth\backend
   mvn clean package tomee:run
   ```

3. **Access**: http://localhost:8080/myemohealth-api/api

---

## 🧪 Testing the API

Once the backend is running, test it:

### 1. Health Check (if you have one)
```powershell
curl http://localhost:8080/myemohealth-api/api/health
```

### 2. Register a Test User
```powershell
curl -X POST http://localhost:8080/myemohealth-api/api/auth/register `
  -H "Content-Type: application/json" `
  -d '{
    "email": "test@example.com",
    "password": "Password123!",
    "firstName": "Test",
    "lastName": "User"
  }'
```

### 3. Login
```powershell
curl -X POST http://localhost:8080/myemohealth-api/api/auth/login `
  -H "Content-Type: application/json" `
  -d '{
    "email": "test@example.com",
    "password": "Password123!"
  }'
```

---

## 📊 Monitoring & Logs

### WildFly Logs
```powershell
# View logs
Get-Content C:\wildfly-29.0.1.Final\standalone\log\server.log -Tail 50 -Wait
```

### Database Logs
```powershell
# Connect to database
$env:PGPASSWORD='123456'; psql -U houssam -h localhost -d suiviemot

# List tables
\dt

# Check user table
SELECT * FROM "user";

# Exit
\q
```

---

## 🐛 Common Issues

### Issue 1: Port 8080 already in use
```powershell
# Find process using port 8080
netstat -ano | findstr :8080

# Kill the process (replace PID)
taskkill /PID <PID> /F
```

### Issue 2: Database connection failed
- Verify PostgreSQL is running: `Get-Service postgresql*`
- Check credentials in `application.properties`
- Test connection: `psql -U houssam -h localhost -d suiviemot`

### Issue 3: Tables not created
- Check `persistence.xml` has `hibernate.hbm2ddl.auto = update`
- Check WildFly logs for Hibernate errors
- Verify datasource is configured correctly

### Issue 4: WAR file not deploying
- Check WildFly logs for errors
- Ensure no compilation errors: `mvn clean package`
- Verify datasource exists in WildFly

---

## 🎯 Recommended Approach

**For Development**: Use **Option 2** (Local WildFly) - gives you full control and faster iteration

**For Testing/Demo**: Use **Option 1** (Docker Compose) - easiest to set up and tear down

**For Quick Tests**: Use **Option 3** (Maven TomEE) - fastest startup, but limited features

---

## 📝 Next Steps After Running

1. **Verify tables created**: Check database for all entity tables
2. **Create admin user**: Either via SQL or registration endpoint
3. **Test API endpoints**: Use Postman or curl
4. **Run mobile app**: Point Flutter app to `http://localhost:8080`
5. **Run web admin**: Point Angular app to `http://localhost:8080`

---

## 🔗 Useful URLs

- **API Base**: http://localhost:8080/myemohealth-api/api
- **WildFly Console**: http://localhost:9990
- **Database**: localhost:5432/suiviemot
- **API Documentation**: See `docs/API_DOCUMENTATION.md`
