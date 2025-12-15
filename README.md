# MyEmoHealth - Emotional Telemonitoring Platform

MyEmoHealth is a full-stack platform designed to monitor and improve patients' emotional well-being through AI-assisted analysis and direct doctor-patient communication.

## 🏗️ Architecture

### 1. Backend API (Spring Boot)
-   **Port**: `8082`
-   **Features**: JWT Auth, WebSocket Chat, Voice Analysis (AI Simulation), Patient Management.
-   **Tech**: Java 17, Spring Boot 3.2, PostgreSQL, WebSocket (STOMP).

### 2. Admin/Doctor Portal (Angular)
-   **Port**: `4200`
-   **Features**: Dashboard, Patient List, QCM Management.
-   **Design**: Glassmorphism, Turquoise/Teal Palette.

### 3. Patient App (Flutter)
-   **Platform**: iOS/Android
-   **Features**: Emotional Check-in, Voice Chat with AI, Real-time Doctor Chat.
-   **Design**: iOS-style, Soft Blur, Interactive Animations.

---

## 🚀 Quick Start

### 1. Database
Ensure PostgreSQL is running (`myemohealth` db).

### 2. Backend
```bash
cd backend
mvn spring-boot:run
```

### 3. Web App (Doctor)
```bash
cd frontend-web
npm install
npm start
# Login: doctor1@example.com / password
```

### 4. Mobile App (Patient)
```bash
cd frontend_mobile
flutter pub get
flutter run
# Login: patient1@example.com / password
```

## � Key Features to Test
-   **Voice AI**: Mobile App -> Dashboard -> "Talk to AI".
-   **Real-time Chat**: Mobile App -> Chat Tab.
-   **Doctor Dashboard**: Web App -> Login -> View Charts.

## 📄 Documentation
See `docs/` for detailed documentation.
