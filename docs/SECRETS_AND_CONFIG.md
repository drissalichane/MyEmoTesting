# Required Secrets and Configuration

To fully enable all features of the MyEmoHealth application, you need to configure the following external services and secrets. You can set these in `backend/src/main/resources/application.yml` or use environment variables (recommended for production).

## 1. 🔑 Critical Security Secrets

| Config Key | Description | Default / Placeholder | Action Required |
|------------|-------------|-----------------------|-----------------|
| `app.jwt.secret` | Signs authentication tokens. | `MyEmoHealth_Super_...` | **CHANGE THIS** to a long random string for production. |
| `app.voice-analysis.api-key` | Secures the internal voice analysis service. | `your_api_key_here` | Set a strong API key if deploying the voice service. |

## 2. 🤖 OpenAI Integration (AI Features)
Required for **Voice Transcription** and **AI Chat** features.

- **Config Key**: `openai.api.key`
- **Location**: `backend/src/main/resources/application.properties` (or passed as env var `OPENAI_API_KEY`)
- **Cost**: Uses `whisper-1` and `gpt-3.5-turbo`. Requires a paid OpenAI account with credits.

## 3. 📹 WebRTC (Video Calls)
The generic STUN server works for local testing, but for real-world usage (different networks), you need a **TURN Server**.

| Config Key | Description | Action Required |
|------------|-------------|-----------------|
| `app.webrtc.turn-server` | Relays video traffic around firewalls. | Sign up for Metered.ca, Twilio, or self-host Coturn. |
| `app.webrtc.turn-username` | TURN Auth User | Fill this in. |
| `app.webrtc.turn-password` | TURN Auth Password | Fill this in. |

## 4. 📧 Email Notifications
Required for sending alerts, password resets, etc.

- **Enabled by default**: `false` (See `app.email.enabled`)
- **Provider**: Defaults to Gmail SMTP (`smtp.gmail.com`).
- **Credentials**:
    - `app.email.username`: Your Gmail address.
    - `app.email.password`: Your **App Password** (not your login password).

## 5. ☁️ File Storage
Defaults to local storage at `/var/myemohealth/storage`. Ensure this directory exists and is writable, or change `app.storage.base-path` in `application.yml`.
