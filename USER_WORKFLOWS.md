# MyEmoHealth - User Workflows

## 🏥 Doctor Workflow (Web Portal)
**Goal**: Monitor assigned patients and review their progress.

### 1. Login
*   **Credentials**: `doctor1@example.com` / `password`
*   **Action**: Enter credentials on the login page.
*   **System**: Validates JWT and redirects to Dashboard.

### 2. Dashboard Overview
*   **View**: See high-level stats (Total Patients, Alerts, Average Mood).
*   **Action**: Check "Recent Alerts" for patients with high stress or low mood scores.

### 3. Patient Management
*   **Action**: Navigate to "Patients" tab.
*   **List View**: See all patients registered in the system.
*   **Assignment**: Click "Assign" on a new patient to add them to your caseload (uses `POST /api/doctors/assign/{id}`).

### 4. Review Patient Progress
*   **Action**: Click on a specific patient name (e.g., "Alice").
*   **Details View**:
    *   **Mood Chart**: 7-day trend of their self-reported mood.
    *   **Test Results**: History of QCM assessments (Depression/Anxiety scales).
    *   **Voice Analysis**: Review flags from AI voice analysis (e.g., "High Stress Detected").

---

## 📱 Patient Workflow (Mobile App)
**Goal**: Track emotional health and communicate with the doctor.

### 1. Login
*   **Credentials**: `patient1@example.com` / `password`
*   **Action**: Login on mobile app.
*   **System**: Token saved locally for auto-login.

### 2. Daily Check-in (Dashboard)
*   **View**: "Current Mood", "Quick Actions".
*   **Action**: User sees their assigned Doctor and current phase (e.g., "Initial Assessment").

### 3. Taking a Test
*   **Action**: Tap "Start Test" or go to "Tests" tab.
*   **Flow**:
    1.  Select a questionnaire (e.g., "Daily Mood Check").
    2.  Answer multiple-choice questions.
    3.  **Submit**: Results are calculated immediately (0-10 scale) and sent to the server.

### 4. Voice Journal ("Talk to AI")
*   **Action**: Tap "Talk to AI" microphone icon.
*   **Workflow**:
    1.  **Record**: User speaks about their day (max 60s).
    2.  **Upload**: Audio sent to Backend -> OpenAI Whisper.
    3.  **Analysis**: Text analyzed for sentiment (Positive/Negative) and Stress.
    4.  **Feedback**: App displays "AI Analysis: You sound calm today."

### 5. Chat with Doctor
*   **Action**: Go to "Chat" tab -> Select Doctor.
*   **Feature**: Real-time messaging (polled every 2s).
*   **Usage**: Ask questions about medication or appointment scheduling.

---

## 🔄 Shared Workflows

### Phase Progression
*   Patients start at **Phase 1** (Initial Assessment).
*   **Logic**: After completing X tests with passing scores (managed by Backend logic), the system or Doctor promotes them to **Phase 2**, unlocking new content.
