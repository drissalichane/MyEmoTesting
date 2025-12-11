# MyEmoHealth - Emotional Telemonitoring System

A comprehensive emotional telemonitoring application for post-hospitalization patient follow-up, built with Flutter (mobile), Jakarta EE (backend), Angular (web admin), and PostgreSQL.

## 🎯 Project Overview

MyEmoHealth enables patients to complete emotional assessment tests (QCMs) with voice analysis, communicate with their doctors via chat and video calls, and allows medical staff to monitor patient progress through a web admin interface.

### Key Features

- **Patient Mobile App (Flutter)**
  - 📊 Dashboard with progress tracking and charts
  - ✅ QCM tests with voice recording
  - 💬 Real-time chat with assigned doctor
  - 📞 Audio/video calls
  - 🔐 Secure authentication

- **Backend API (Jakarta EE)**
  - RESTful API with JWT authentication
  - Role-based access control (PATIENT, DOCTOR, ADMIN)
  - PostgreSQL database with JPA/Hibernate
  - Voice analysis integration
  - Audit logging for security

- **Web Admin (Angular)**
  - Patient management
  - QCM builder interface
  - Results visualization
  - Chat interface for doctors
  - Statistics and reports

### Business Rules

- **5 Phases**: Patients progress through 5 treatment phases
- **3 Tests per Phase**: Each phase requires 3 QCM tests
- **Passing Score**: ≥ 7.5/10 to pass a test
- **Phase Validation**: All 3 tests must be passed to complete a phase

## 🏗️ Architecture

```
MyEmoHealth/
├── backend/              # Jakarta EE REST API
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/myemohealth/
│   │   │   │   ├── entity/       # JPA entities
│   │   │   │   ├── repository/   # Data access
│   │   │   │   ├── service/      # Business logic
│   │   │   │   ├── controller/   # REST endpoints
│   │   │   │   ├── dto/          # Data transfer objects
│   │   │   │   ├── security/     # JWT & RBAC
│   │   │   │   └── util/         # Utilities
│   │   │   └── resources/
│   │   │       ├── META-INF/persistence.xml
│   │   │       └── application.properties
│   │   └── test/
│   └── pom.xml
├── mobile/               # Flutter mobile app
│   ├── lib/
│   │   ├── core/         # Config, theme, constants
│   │   ├── data/         # Models, repositories, API
│   │   ├── domain/       # Entities, use cases
│   │   └── presentation/ # UI screens & widgets
│   └── pubspec.yaml
├── web-admin/            # Angular web admin
│   ├── src/
│   │   └── app/
│   │       ├── core/     # Auth, guards, services
│   │       ├── shared/   # Shared components
│   │       └── features/ # Feature modules
│   └── package.json
├── database/             # Database scripts
│   ├── init-db.sql       # Schema creation
│   └── seed-data.sql     # Sample data
└── docs/                 # Documentation
```

## 📋 Prerequisites

### Backend
- Java 17 or higher
- Maven 3.8+
- PostgreSQL 13+
- Jakarta EE application server (WildFly, Payara, or TomEE)

### Mobile
- Flutter SDK 3.16+
- Dart 3.2+
- Android Studio / Xcode

### Web Admin
- Node.js 18+
- npm 9+
- Angular CLI 17+

## 🚀 Getting Started

### 1. Database Setup

```bash
# Create database
createdb suiviemot

# Initialize schema
psql -d suiviemot -f database/init-db.sql

# Load sample data
psql -d suiviemot -f database/seed-data.sql
```

### 2. Backend Setup

```bash
cd backend

# Configure database connection
# Edit src/main/resources/application.properties

# Build the project
mvn clean install

# Deploy to application server
# Copy target/myemohealth-api.war to your server's deployment directory
```

**Default Test Credentials:**
- Admin: `admin@myemohealth.com` / `Password123!`
- Doctor: `dr.martin@myemohealth.com` / `Password123!`
- Patient: `patient1@test.com` / `Password123!`

### 3. Mobile App Setup

```bash
cd mobile

# Install dependencies
flutter pub get

# Run on iOS simulator
flutter run -d ios

# Run on Android emulator
flutter run -d android
```

### 4. Web Admin Setup

```bash
cd web-admin

# Install dependencies
npm install

# Start development server
ng serve

# Open browser at http://localhost:4200
```

## 🔐 Security Features

- **JWT Authentication**: Secure token-based authentication with refresh tokens
- **RBAC**: Role-based access control (PATIENT, DOCTOR, ADMIN)
- **Encrypted Storage**: Voice recordings encrypted at rest
- **Audit Logging**: All sensitive operations logged
- **GDPR Compliance**: Patient consent tracking, data export, right to deletion

## 📊 Database Schema

### Core Tables
- `user` - All system users
- `role` - User roles
- `patient_profile` - Patient-specific data
- `doctor_profile` - Doctor-specific data

### QCM System
- `phase` - 5 treatment phases
- `qcm_template` - Questionnaire templates
- `qcm_question` - Individual questions
- `test_instance` - Patient test attempts
- `answer` - Patient answers

### Communication
- `chat_thread` - Conversation threads
- `chat_message` - Individual messages
- `call_log` - Audio/video call logs

### Voice Analysis
- `voice_record` - Voice file metadata (encrypted)
- `voice_analysis_result` - AI analysis results

### System
- `notification` - User notifications
- `audit_log` - Security audit trail
- `refresh_token` - JWT refresh tokens

## 🔌 API Endpoints

### Authentication
```
POST   /api/auth/login          # Login
POST   /api/auth/register       # Register patient
POST   /api/auth/refresh        # Refresh token
POST   /api/auth/logout         # Logout
```

### Users
```
GET    /api/users/{id}          # Get user
PUT    /api/users/{id}          # Update user
GET    /api/users/me            # Get current user
```

### QCM & Tests
```
GET    /api/qcms                # List QCMs
POST   /api/qcms                # Create QCM [DOCTOR/ADMIN]
GET    /api/qcms/{id}           # Get QCM details
POST   /api/tests               # Start test
POST   /api/tests/{id}/answers  # Submit answers
GET    /api/tests/{id}/result   # Get result
```

### Phases
```
GET    /api/phases              # List phases
GET    /api/patients/{id}/progress  # Patient progress
```

### Chat
```
GET    /api/threads             # List threads
POST   /api/threads             # Create thread
POST   /api/threads/{id}/messages  # Send message
GET    /api/threads/{id}/messages  # Get messages
```

### Voice
```
POST   /api/voice/upload        # Upload voice recording
GET    /api/voice/{id}/analysis # Get analysis result
```

### Admin
```
GET    /api/admin/patients      # List patients
POST   /api/admin/patients      # Create patient
PUT    /api/admin/users/{id}/role  # Update user role
```

## 🧪 Testing

### Backend Tests
```bash
cd backend
mvn test
```

### Mobile Tests
```bash
cd mobile
flutter test
```

### Web Admin Tests
```bash
cd web-admin
npm test
```

## 📦 Deployment

### Using Docker Compose
```bash
# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

### Manual Deployment
See [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md) for detailed deployment instructions.

## 📝 Configuration

### Backend Configuration
Edit `backend/src/main/resources/application.properties`:
- Database connection
- JWT secret and expiration
- File storage paths
- Voice analysis service URL

### Mobile Configuration
Edit `mobile/lib/core/config/api_config.dart`:
- API base URL
- WebSocket URL
- WebRTC configuration

### Web Admin Configuration
Edit `web-admin/src/environments/environment.ts`:
- API base URL
- WebSocket URL

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Team

- Backend Development: Jakarta EE + PostgreSQL
- Mobile Development: Flutter
- Web Development: Angular
- UI/UX Design: iOS 16-inspired design

## 📞 Support

For questions or support, please contact:
- Email: support@myemohealth.com
- Documentation: [docs/](docs/)

## 🗺️ Roadmap

- [ ] Multi-language support (FR, AR, EN)
- [ ] Push notifications
- [ ] Offline mode for mobile app
- [ ] Advanced analytics dashboard
- [ ] Integration with wearable devices
- [ ] Telemedicine video consultations
- [ ] AI-powered insights and recommendations

---

**Note**: This is an academic/research project for emotional telemonitoring in post-hospitalization care. Always consult with healthcare professionals for medical decisions.
