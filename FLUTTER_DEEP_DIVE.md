# Flutter Technical Deep Dive

## 1. 🏗️ State Management Architecture
The application uses a **Hybrid State Management** approach:
*   **Global State (Provider)**: For data that must be accessible everywhere (Authentication, User Profile).
*   **Local State (`setState`)**: For ephemeral UI state (e.g., current question index in a test, form inputs).

### Why Provider?
In `lib/main.dart`, we define the `MultiProvider` at the root:
```dart
ChangeNotifierProvider(create: (_) => AuthService()),
```
This allows any widget in the tree to access user data using `Provider.of<AuthService>(context)`. It's efficient because it only rebuilds widgets that specifically listen to changes.

---

## 2. 🎨 UI & Theming (Glassmorphism)
The app's distinctive look comes from the custom `GlassCard` widget (`lib/core/widgets/glass_card.dart`).

**Key Technical Details:**
*   **BackdropFilter**: The core widget that applies Gaussian blur to the content *behind* it.
*   **ImageFilter.blur**: Used with `sigmaX` and `sigmaY` (set to 10.0) to create the "frosted glass" effect.
*   **Gradients**: A subtle white linear gradient (20% opacity to 5% opacity) creates the 3D shiny surface effect.
*   **ClipRRect**: Required to clip the blur effect to the rounded corners of the card.

---

## 3. 🚦 Asynchronous Data Flow
We avoid "blocking" the UI by using `FutureBuilder`.

**Pattern (e.g., `TestListScreen.dart`):**
1.  **State Initialization**: A `Future` variable (`_testsFuture`) is initialized in `initState()`.
2.  **Builder**: `FutureBuilder` listens to this future.
3.  **States**:
    *   `ConnectionState.waiting`: Show `CircularProgressIndicator`.
    *   `hasError`: Show error message.
    *   `hasData`: Render the `ListView`.
*   **Refresh**: To reload data, we simply call `setState(() { _testsFuture = _fetchTests(); });`, triggering a re-render.

---

## 4. 📝 Dynamic Form Rendering (QCM Runner)
The `QcmRunnerScreen.dart` is the most complex widget. It renders a test dynamically based on backend JSON configuration.

**Logic Flow:**
1.  **JSON Parsing**: It receives a list of questions where `questionType` can be `SINGLE_CHOICE`, `MULTIPLE_CHOICE`, `SCALE`, or `TEXT`.
2.  **Widget Factory (`_buildInput`)**: A switch-case logic determines which Flutter widget to return:
    *   `SINGLE_CHOICE` -> `RadioListTile`
    *   `MULTIPLE_CHOICE` -> `CheckboxListTile` (Manages a `Set<String>` for state)
    *   `SCALE` -> `Slider` (Mapped to min/max values from JSON)
    *   `TEXT` -> `TextField`

This purely "data-driven UI" allows the backend to change test questions without updating the mobile app code.

---

## 5. 🔌 Networking & API Integration
*   **Service Pattern**: All HTTP logic is encapsulated in `ApiService`.
*   **Interceptors**: The `getHeaders()` method acts like an interceptor, automatically injecting the `Bearer ` token from `SharedPreferences` into every request.
*   **Multipart Requests**: For voice files, we use `http.MultipartRequest` instead of simple POST, allowing us to stream binary audio data directly to the server.

---

## 💡 "Pro" Tips for Defense
*   **Handling Lists**: "We used `ListView.builder` instead of `ListView` because it's lazily loaded—it only renders items currently visible on screen, which is better for performance if the list of tests grows large."
*   **Safe Areas**: "We wrapped screens in `SafeArea` to ensure content isn't hidden behind the notch on modern iPhones."
