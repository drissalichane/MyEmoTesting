# MyEmoHealth API Documentation

Base URL: `http://localhost:8080/myemohealth-api/api`

## Authentication

All endpoints except `/auth/login` and `/auth/register` require a valid JWT token in the Authorization header:

```
Authorization: Bearer <access_token>
```

---

## Auth Endpoints

### POST /auth/login

Authenticate user and receive JWT tokens.

**Request:**
```json
{
  "email": "patient1@test.com",
  "password": "Password123!"
}
```

**Response:** `200 OK`
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

**Errors:**
- `401 Unauthorized` - Invalid credentials
- `400 Bad Request` - Validation error

---

### POST /auth/register

Register a new patient account.

**Request:**
```json
{
  "email": "newpatient@example.com",
  "password": "SecurePass123!",
  "firstName": "Jean",
  "lastName": "Dupont",
  "dateNaissance": "1990-05-15",
  "sexe": "M",
  "consentVoiceRecording": true,
  "consentDataSharing": true
}
```

**Response:** `201 Created`
```json
{
  "accessToken": "...",
  "refreshToken": "...",
  "tokenType": "Bearer",
  "expiresIn": 3600,
  "userId": 9,
  "email": "newpatient@example.com",
  "firstName": "Jean",
  "lastName": "Dupont",
  "role": "PATIENT"
}
```

**Errors:**
- `400 Bad Request` - Email already exists or validation error

---

### POST /auth/refresh

Refresh access token using refresh token.

**Request:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response:** `200 OK`
```json
{
  "accessToken": "new_access_token...",
  "refreshToken": "same_refresh_token...",
  "tokenType": "Bearer",
  "expiresIn": 3600,
  "userId": 4,
  "email": "patient1@test.com",
  "firstName": "Marie",
  "lastName": "Lefebvre",
  "role": "PATIENT"
}
```

**Errors:**
- `401 Unauthorized` - Invalid or expired refresh token

---

### POST /auth/logout

Logout user (client should discard tokens).

**Response:** `200 OK`
```json
{
  "message": "Logged out successfully"
}
```

---

## User Endpoints

### GET /users/me

Get current authenticated user information.

**Headers:**
```
Authorization: Bearer <access_token>
```

**Response:** `200 OK`
```json
{
  "id": 4,
  "uuid": "550e8400-e29b-41d4-a716-446655440000",
  "email": "patient1@test.com",
  "firstName": "Marie",
  "lastName": "Lefebvre",
  "role": "PATIENT",
  "enabled": true,
  "emailVerified": false
}
```

---

### GET /users/{id}

Get user by ID.

**Parameters:**
- `id` (path) - User ID

**Response:** `200 OK`
```json
{
  "id": 4,
  "uuid": "550e8400-e29b-41d4-a716-446655440000",
  "email": "patient1@test.com",
  "firstName": "Marie",
  "lastName": "Lefebvre",
  "role": "PATIENT",
  "enabled": true,
  "emailVerified": false
}
```

**Errors:**
- `404 Not Found` - User not found

---

### GET /users

Get all users (admin only).

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "uuid": "...",
    "email": "admin@myemohealth.com",
    "firstName": "Admin",
    "lastName": "System",
    "role": "ADMIN",
    "enabled": true,
    "emailVerified": true
  },
  ...
]
```

---

### GET /users/patients

Get all patients.

**Response:** `200 OK`
```json
[
  {
    "id": 4,
    "uuid": "...",
    "email": "patient1@test.com",
    "firstName": "Marie",
    "lastName": "Lefebvre",
    "role": "PATIENT",
    "enabled": true,
    "emailVerified": false
  },
  ...
]
```

---

### GET /users/doctors

Get all doctors.

**Response:** `200 OK`
```json
[
  {
    "id": 2,
    "uuid": "...",
    "email": "dr.martin@myemohealth.com",
    "firstName": "Sophie",
    "lastName": "Martin",
    "role": "DOCTOR",
    "enabled": true,
    "emailVerified": true
  },
  ...
]
```

---

### PUT /users/{id}

Update user information.

**Parameters:**
- `id` (path) - User ID

**Request:**
```json
{
  "firstName": "Marie-Claire",
  "lastName": "Lefebvre-Dubois"
}
```

**Response:** `200 OK`
```json
{
  "id": 4,
  "uuid": "...",
  "email": "patient1@test.com",
  "firstName": "Marie-Claire",
  "lastName": "Lefebvre-Dubois",
  "role": "PATIENT",
  "enabled": true,
  "emailVerified": false
}
```

---

## Test Endpoints

### POST /tests

Start a new test for a patient.

**Request:**
```json
{
  "patientId": 4,
  "qcmId": 1,
  "phaseId": 1
}
```

**Response:** `201 Created`
```json
{
  "id": 10,
  "uuid": "...",
  "patient": { "id": 4, ... },
  "qcmTemplate": { "id": 1, ... },
  "phase": { "id": 1, ... },
  "status": "IN_PROGRESS",
  "startedAt": "2024-12-11T10:30:00",
  "maxScore": 10.0,
  "attemptNumber": 1
}
```

**Errors:**
- `400 Bad Request` - Invalid parameters

---

### POST /tests/{id}/answers

Submit answers for a test.

**Parameters:**
- `id` (path) - Test instance ID

**Request:**
```json
{
  "answers": [
    {
      "question": { "id": 1 },
      "valueNumeric": 8
    },
    {
      "question": { "id": 2 },
      "selectedOptions": { "value": "A" }
    },
    {
      "question": { "id": 3 },
      "selectedOptions": { "values": ["A", "E"] }
    }
  ]
}
```

**Response:** `200 OK`
```json
{
  "id": 10,
  "uuid": "...",
  "score": 8.2,
  "status": "PASSED",
  "startedAt": "2024-12-11T10:30:00",
  "finishedAt": "2024-12-11T10:45:00",
  "timeSpentSeconds": 900
}
```

**Errors:**
- `400 Bad Request` - Test not in progress or invalid answers
- `404 Not Found` - Test not found

---

### GET /tests/{id}/result

Get test result.

**Parameters:**
- `id` (path) - Test instance ID

**Response:** `200 OK`
```json
{
  "id": 10,
  "uuid": "...",
  "patient": { "id": 4, ... },
  "qcmTemplate": { "id": 1, "title": "Évaluation Émotionnelle Initiale" },
  "phase": { "id": 1, "number": 1, "label": "Phase Initiale" },
  "score": 8.2,
  "maxScore": 10.0,
  "status": "PASSED",
  "startedAt": "2024-12-11T10:30:00",
  "finishedAt": "2024-12-11T10:45:00",
  "timeSpentSeconds": 900,
  "attemptNumber": 1
}
```

**Errors:**
- `404 Not Found` - Test not found

---

### GET /tests/patient/{patientId}

Get all tests for a patient.

**Parameters:**
- `patientId` (path) - Patient user ID

**Response:** `200 OK`
```json
[
  {
    "id": 10,
    "uuid": "...",
    "qcmTemplate": { "id": 1, "title": "..." },
    "phase": { "id": 1, "number": 1 },
    "score": 8.2,
    "status": "PASSED",
    "finishedAt": "2024-12-11T10:45:00"
  },
  ...
]
```

---

### GET /tests/patient/{patientId}/phase/{phaseId}

Get tests for a patient in a specific phase.

**Parameters:**
- `patientId` (path) - Patient user ID
- `phaseId` (path) - Phase ID (1-5)

**Response:** `200 OK`
```json
[
  {
    "id": 10,
    "uuid": "...",
    "qcmTemplate": { "id": 1, "title": "..." },
    "score": 8.2,
    "status": "PASSED",
    "finishedAt": "2024-12-11T10:45:00"
  }
]
```

---

## Data Models

### User
```json
{
  "id": 4,
  "uuid": "550e8400-e29b-41d4-a716-446655440000",
  "email": "patient1@test.com",
  "firstName": "Marie",
  "lastName": "Lefebvre",
  "role": "PATIENT",
  "enabled": true,
  "emailVerified": false
}
```

### TestInstance
```json
{
  "id": 10,
  "uuid": "...",
  "patient": { "id": 4 },
  "qcmTemplate": { "id": 1 },
  "phase": { "id": 1 },
  "scheduledAt": "2024-12-11T10:00:00",
  "startedAt": "2024-12-11T10:30:00",
  "finishedAt": "2024-12-11T10:45:00",
  "score": 8.2,
  "maxScore": 10.0,
  "status": "PASSED",
  "attemptNumber": 1,
  "timeSpentSeconds": 900
}
```

### Answer
```json
{
  "id": 50,
  "testInstance": { "id": 10 },
  "question": { "id": 1 },
  "selectedOptions": { "value": "A" },
  "valueNumeric": 8.0,
  "textResponse": null,
  "isCorrect": true,
  "pointsEarned": 10.0,
  "answeredAt": "2024-12-11T10:35:00"
}
```

---

## Business Rules

### Test Scoring
- **Passing score**: ≥ 7.5/10
- **Max score**: 10.0
- **Status**: Automatically set to PASSED or FAILED based on score

### Phase Progression
- **5 phases** total
- **3 tests** required per phase
- All 3 tests must be PASSED to complete a phase

### Question Types
1. **SINGLE_CHOICE**: One correct answer, points defined per option
2. **MULTIPLE_CHOICE**: Multiple answers, cumulative points
3. **SCALE**: Numeric value (1-10), normalized to 0-10
4. **TEXT**: Free text, requires manual grading

---

## Error Responses

All error responses follow this format:

```json
{
  "error": "Error message description"
}
```

### HTTP Status Codes
- `200 OK` - Success
- `201 Created` - Resource created
- `400 Bad Request` - Validation error or invalid request
- `401 Unauthorized` - Authentication required or invalid token
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Resource not found
- `500 Internal Server Error` - Server error

---

## Rate Limiting

Currently no rate limiting is implemented. Consider adding in production.

---

## Versioning

API Version: 1.0.0

Future versions will use URL versioning: `/api/v2/...`

---

**Last Updated**: December 11, 2024
