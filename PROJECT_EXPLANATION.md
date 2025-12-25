# MyEmoHealth - Project Technical Explanation

## 1. 🏗️ Global Architecture
The project follows a classic **3-Tier Client-Server Architecture**:

1.  **Client Layer (Frontend)**
    *   **Mobile App (Flutter)**: For patients to access services.
    *   **Web Portal (Angular)**: For doctors and admins to manage patients.
2.  **Logic Layer (Backend - Server)**
    *   **Spring Boot (Java 17)**: Handles all business logic, security, and AI integrations.
    *   **REST API**: Exposes data to both frontends via HTTP endpoints.
3.  **Data Layer (Database)**
    *   **PostgreSQL**: Relational database storing users, roles, chat history, and test results.

---

## 2. 📱 Flutter Mobile App (Deep Dive)
*For your defense, emphasize the following technical choices:*

### **A. Tech Stack & Libraries**
*   **Framework**: Flutter (Cross-platform iOS/Android).
*   **State Management**: **Provider** (`ChangeNotifierProvider`).
    *   *Why?* It's simple, efficient, and recommended by Google for apps of this scale.
*   **Networking**: `http` package for REST API calls.
*   **UI Components**: `glassmorphism` (for the transparent card look), `dash_chat_2` (for the chat UI).
*   **Storage**: `shared_preferences` (to store JWT tokens locally).

### **B. Project Structure (`lib/`)**
The app attempts to follow a **Feature-First** architecture:

*   `core/`: Contains shared logic.
    *   `services/`: `AuthService` (manages login state), `ApiService` (wraps HTTP calls).
    *   `theme/`: App colors and styles.
    *   `widgets/`: Reusable UI components (like `GlassCard`).
*   `features/`: Each major screen has its own folder.
    *   `auth/`: Login & Register screens.
    *   `home/`: Dashboard.
    *   `chat/`: Chat lists and conversation screens.
    *   `tests/`: QCM and voice analysis tests.

### **C. Key Feature Implementations**

#### **1. Authentication Flow**
1.  User enters credentials on `LoginScreen`.
2.  `AuthService.login()` sends a `POST` request to `/auth/login`.
3.  Server returns a **JWT Access Token**.
4.  App saves this token in **Shared Preferences**.
5.  `ApiService` automatically adds this token to the `Authorization: Bearer ...` header of every subsequent request.

#### **2. Real-time Chat (Critical Detail!)**
*   **Implementation**: **Polling** (Long-polling simulation).
*   *How it works*: Use `Timer` or `Future.delayed` to fetch messages every 2 seconds.
*   *Code Reference*: `ChatConversationScreen.dart` -> `_startPolling()` method.
*   *Why not WebSockets?* Polling is easier to implement for a school project, though WebSockets (Stomp) would be better for production scaling.
*   **UI**: Uses `DashChat` library to render the chat bubbles easily.

#### **3. Voice Analysis**
*   **Recording**: Uses `flutter_sound` or native plugins to capture audio.
*   **Sending**: Uses a **Multipart Request** (`http.MultipartRequest`).
*   *Process*: Handled in `ApiService.uploadVoiceRecord`. It sends the raw audio file byte-stream to the backend `/ai/analyze` endpoint.

#### **4. Dashboard**
*   **Data Fetching**: Uses `FutureBuilder`.
*   *Flow*: When `DashboardScreen` loads (`initState`), it calls `ApiService.getDashboardData()`. The UI shows a loading spinner until the data arrives.

---

## 3. 🧠 Backend Logic (Spring Boot)

### **Security**
*   **JWT Filter**: Every request is intercepted. The server checks the signature of the JWT token. If valid, it extracts the user ID and role (PATIENT/DOCTOR) and allows the request.
*   **Roles**: `DataInitializer` seeds the DB with roles (PATIENT, DOCTOR) on startup.

### **Database (PostgreSQL)**
*   **ORM**: Uses **Hibernate/JPA**. You don't write raw SQL. You create Java classes (`User`, `PatientProfile`) and Hibernate creates the tables for you.
*   **Relationships**: 
    *   `User` has one `PatientProfile`.
    *   `PatientProfile` has a `ManyToOne` relationship with a Doctor `User`.

---

## 🎓 Possible Exam Questions & Answers

**Q: Why did you use Provider?**
A: It separates UI from Logic efficiently. A global `AuthService` handles the user state, and any screen can listen to it to redirect to Login/Home automatically.

**Q: How do you handle secrets differently in Production?**
A: Currently, API keys are hardcoded or in `application.yml`. In production, we would use **Environment Variables** or a **Vault** service, and never commit secrets to Git.

**Q: Is the chat truly real-time?**
A: It simulates real-time using "polling" (fetching every 2 seconds). For a larger scale, we would switch to WebSockets to reduce server load.

**Q: How does the AI integration work?**
A: The mobile app sends audio/text to the Backend. The Backend acts as a proxy and forwards it to OpenAI (Whisper/GPT), adds our system prompts (e.g., "Act as a therapist"), and returns the result. This keeps our API keys hidden from the mobile app.
