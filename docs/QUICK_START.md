# MyEmoHealth Backend - Quick Start Guide

## What's Been Implemented

### ✅ Core Backend Components

1. **Database Layer**
   - Complete PostgreSQL schema (18 tables)
   - Sample data with test users
   - Indexes and constraints

2. **JPA Entities** (18 classes)
   - User management (User, Role, PatientProfile, DoctorProfile)
   - QCM system (QcmTemplate, QcmQuestion, TestInstance, Answer)
   - Communication (ChatThread, ChatMessage, CallLog)
   - Voice analysis (VoiceRecord, VoiceAnalysisResult)
   - System (Notification, AuditLog, RefreshToken, etc.)

3. **Repositories** (5 classes)
   - UserRepository
   - RoleRepository
   - TestInstanceRepository
   - QcmTemplateRepository
   - ChatThreadRepository

4. **Security**
   - JwtUtil - Token generation and validation
   - PasswordEncoder - BCrypt hashing
   - CorsFilter - Cross-origin support

5. **Services** (2 classes)
   - AuthService - Login, registration, token refresh
   - TestService - Test execution with scoring algorithm

6. **REST Controllers** (3 classes)
   - AuthController - `/api/auth/*`
   - UserController - `/api/users/*`
   - TestController - `/api/tests/*`

---

## 🚀 Running the Backend

### Prerequisites
- Java 17+
- Maven 3.8+
- PostgreSQL 13+
- WildFly 29+ (or Payara/TomEE)

### Step 1: Database Setup

```bash
# Create database
createdb suiviemot

# Run initialization scripts
psql -d suiviemot -f database/init-db.sql
psql -d suiviemot -f database/seed-data.sql
```

### Step 2: Configure Database Connection

For WildFly, create a datasource in `standalone.xml`:

```xml
<datasource jndi-name="java:jboss/datasources/MyEmoHealthDS" pool-name="MyEmoHealthDS">
    <connection-url>jdbc:postgresql://localhost:5432/suiviemot</connection-url>
    <driver>postgresql</driver>
    <security>
        <user-name>postgres</user-name>
        <password>postgres</password>
    </security>
</datasource>
```

### Step 3: Build the Project

```bash
cd backend
mvn clean package
```

This creates `target/myemohealth-api.war`

### Step 4: Deploy to WildFly

```bash
# Copy WAR to deployments directory
cp target/myemohealth-api.war $WILDFLY_HOME/standalone/deployments/

# Start WildFly
$WILDFLY_HOME/bin/standalone.sh
```

The API will be available at: `http://localhost:8080/myemohealth-api/api`

---

## 📡 Testing the API

### 1. Login (Get JWT Token)

```bash
curl -X POST http://localhost:8080/myemohealth-api/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "patient1@test.com",
    "password": "Password123!"
  }'
```

**Response:**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "tokenType": "Bearer",
  "expiresIn": 3600,
  "userId": 4,
  "email": "patient1@test.com",
  "firstName": "Marie",
  "lastName": "Lefebvre",
  "role": "PATIENT"
}
```

### 2. Register New Patient

```bash
curl -X POST http://localhost:8080/myemohealth-api/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "newpatient@test.com",
    "password": "SecurePass123!",
    "firstName": "Jean",
    "lastName": "Dupont",
    "dateNaissance": "1990-05-15",
    "sexe": "M",
    "consentVoiceRecording": true,
    "consentDataSharing": true
  }'
```

### 3. Get User Info

```bash
curl -X GET http://localhost:8080/myemohealth-api/api/users/4 \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 4. Start a Test

```bash
curl -X POST http://localhost:8080/myemohealth-api/api/tests \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "patientId": 4,
    "qcmId": 1,
    "phaseId": 1
  }'
```

### 5. Submit Test Answers

```bash
curl -X POST http://localhost:8080/myemohealth-api/api/tests/1/answers \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "answers": [
      {
        "question": {"id": 1},
        "valueNumeric": 8
      },
      {
        "question": {"id": 2},
        "selectedOptions": {"value": "A"}
      }
    ]
  }'
```

---

## 🔑 Test Credentials

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@myemohealth.com | Password123! |
| Doctor | dr.martin@myemohealth.com | Password123! |
| Doctor | dr.dubois@myemohealth.com | Password123! |
| Patient | patient1@test.com | Password123! |
| Patient | patient2@test.com | Password123! |

---

## 📊 Scoring Algorithm

The `TestService` implements the business rule:
- **Passing score**: ≥ 7.5/10
- **Question types supported**:
  - Single choice (points per option)
  - Multiple choice (cumulative points)
  - Scale (1-10 normalized)
  - Text (manual grading needed)

**Example calculation:**
```
Question 1 (weight=1.0): 8/10 points
Question 2 (weight=1.0): 9/10 points
Question 3 (weight=1.0): 6/10 points

Total: (8 + 9 + 6) / 3 = 7.67/10 → PASSED ✅
```

---

## 🔐 Security Features

### JWT Authentication
- **Access token**: 1 hour validity
- **Refresh token**: 7 days validity
- **Algorithm**: HS256
- **Claims**: userId, email, role

### Password Security
- **Algorithm**: BCrypt
- **Rounds**: 10
- **Minimum length**: 8 characters

### CORS
- Allows all origins (configure for production)
- Methods: GET, POST, PUT, DELETE, OPTIONS
- Headers: Content-Type, Authorization

---

## 🛠️ Next Steps

### To Complete Backend:
1. **QCM Management Controller** - CRUD for questionnaires
2. **Phase Progress Service** - Track patient progression
3. **Chat Service & Controller** - Messaging system
4. **Voice Service & Controller** - Upload and analysis
5. **Admin Controller** - User management endpoints
6. **JWT Filter** - Automatic authentication on endpoints
7. **Exception Handlers** - Global error handling
8. **Validation** - Bean validation on DTOs

### To Start Mobile App:
```bash
flutter create mobile --org com.myemohealth
cd mobile
flutter pub add dio flutter_riverpod flutter_secure_storage
```

### To Start Web Admin:
```bash
ng new web-admin
cd web-admin
ng add @angular/material
npm install @ngrx/store socket.io-client
```

---

## 📝 API Endpoints Summary

### Authentication
- `POST /api/auth/login` - Login
- `POST /api/auth/register` - Register patient
- `POST /api/auth/refresh` - Refresh token
- `POST /api/auth/logout` - Logout

### Users
- `GET /api/users/me` - Current user
- `GET /api/users/{id}` - Get user
- `GET /api/users` - List all users
- `GET /api/users/patients` - List patients
- `GET /api/users/doctors` - List doctors
- `PUT /api/users/{id}` - Update user

### Tests
- `POST /api/tests` - Start test
- `POST /api/tests/{id}/answers` - Submit answers
- `GET /api/tests/{id}/result` - Get result
- `GET /api/tests/patient/{id}` - Patient tests
- `GET /api/tests/patient/{id}/phase/{phaseId}` - Tests by phase

---

## 🐛 Troubleshooting

### Database Connection Issues
```bash
# Check PostgreSQL is running
pg_isready

# Test connection
psql -U postgres -d suiviemot -c "SELECT COUNT(*) FROM \"user\";"
```

### Build Errors
```bash
# Clean and rebuild
mvn clean install -U

# Skip tests if needed
mvn clean package -DskipTests
```

### Deployment Issues
```bash
# Check WildFly logs
tail -f $WILDFLY_HOME/standalone/log/server.log

# Verify datasource
$WILDFLY_HOME/bin/jboss-cli.sh --connect
/subsystem=datasources/data-source=MyEmoHealthDS:test-connection-in-pool
```

---

## 📚 Resources

- [Jakarta EE Documentation](https://jakarta.ee/specifications/)
- [WildFly Documentation](https://docs.wildfly.org/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [JWT.io](https://jwt.io/) - JWT debugger

---

**Status**: Backend core is functional! Ready for mobile and web development.
