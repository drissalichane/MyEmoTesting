# Jenkins + SonarQube CI/CD Detailed Setup Guide

**Updated for compatibility with standard Maven installations.**

## 1. Jenkins Tools Configuration (Manage Jenkins -> Tools)

Ensure these names match your `Jenkinsfile`:

1.  **Maven**:
    *   Name: `maven`

2.  **NodeJS**:
    *   Name: `node`

3.  **SonarQube Scanner**:
    *   Name: `SonarQube-Server` (used for Angular analysis).

---

## 2. SonarQube Server Configuration (Manage Jenkins -> System)

Ensure these servers are added in "SonarQube servers":

1.  **Server 1**: Name `SonarQube-Backend` (Token: Backend Project Token).
2.  **Server 2**: Name `SonarQube-Frontweb` (Token: Frontend Project Token).

---

## 3. Explaining the Fix: "No plugin found for prefix 'sonar'"

We added the **SonarQube Maven Plugin** directly to your `backend/pom.xml`. This allows Maven to recognize the `sonar:sonar` command without needing the long, fully qualified name in the Jenkinsfile.

The plugin was added here:
```xml
<plugin>
    <groupId>org.sonarsource.scanner.maven</groupId>
    <artifactId>sonar-maven-plugin</artifactId>
    <version>3.10.0.2594</version>
</plugin>
```

---

## 4. Run Locally (Optional)
If you still want to run locally:
1.  **Backend**: `mvn spring-boot:run` (Ensure Postgres is running on port 5432).
2.  **Frontend**: `npm start` (Ensure Backend is running).
