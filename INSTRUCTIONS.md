# Jenkins + SonarQube CI/CD Detailed Setup Guide

This guide is refined to match the granular steps from your lab content and tailored for the **MyEmoHealth** project (Spring Boot + Angular).

## Part A: Jenkins & Tools Configuration (Critical First Step)

You asked if "Maven is enough". **No**, because you have an Angular app.
*   **Maven**: Builds your Spring Boot Backend.
*   **NodeJS**: Builds your Angular Frontend.
*   **SonarScanner**: Scans both (Maven plugin for Java, generic scanner for TypeScript).

### 1. Configure Jenkins Tools
Go to **Dashboard -> Manage Jenkins -> Tools**:

1.  **JDK**:
    *   Find "JDK installations".
    *   Click **Add JDK**.
    *   Name: `jdk17` (Must match `Jenkinsfile`).
    *   JAVA_HOME: Path to your JDK 17 (uncheck "Install automatically" if using local path, or check it to download).

2.  **Maven**:
    *   Find "Maven installations".
    *   Click **Add Maven**.
    *   Name: `maven` (Must match `Jenkinsfile`).
    *   Version: 3.9.x.

3.  **NodeJS** (For Angular):
    *   *Prerequisite*: You likely need to install the **NodeJS Plugin** in "Manage Jenkins -> Plugins".
    *   After plugin install, go back to **Tools**.
    *   Find "NodeJS installations".
    *   Click **Add NodeJS**.
    *   Name: `node20` (or `node` - we will match this in Jenkinsfile).
    *   Version: NodeJS 20.x (LTS) or 18.x.

4.  **SonarQube Scanner**:
    *   Find "SonarQube Scanner installations".
    *   Click **Add SonarQube Scanner**.
    *   Name: `sonar-scanner`.
    *   Check "Install automatically".

---

## Part B: SonarQube Setup

### 1. Start SonarQube
Use the `sonarqube-compose.yml` you have.
```bash
cd tools/sonarqube
docker compose -f sonarqube-compose.yml up -d
```
Access: `http://localhost:9000` (Login: `admin` / `admin`, then change password).

### 2. Create Projects & Tokens (Manual Step)
You need to register **two** projects in SonarQube manually to get the keys.

**For Backend:**
1.  Click **Create Project** -> **Manually**.
2.  Project display name: `MyEmoHealth Backend`.
3.  Project Key: `myemohealth-backend`.
4.  Main branch: `main`.
5.  **Setup analysis**: Choose "Locally".
6.  Generate a token named `jenkins-backend-token`. **COPY THIS TOKEN**.

**For Frontend (Angular):**
1.  Click **Create Project** -> **Manually**.
2.  Project display name: `MyEmoHealth Frontend`.
3.  Project Key: `myemohealth-frontend`.
4.  Main branch: `main`.
5.  Generate a token named `jenkins-frontend-token`. **COPY THIS TOKEN**.

### 3. Connect Jenkins to SonarQube
Go to **Dashboard -> Manage Jenkins -> System**:

1.  Find **SonarQube servers**.
2.  Click **Add SonarQube**.
3.  **Name**: `SonarQube-Local` (Critical: Must match `Jenkinsfile`).
4.  **Server URL**: `http://localhost:9000` (or Docker IP if Jenkins is in container).
5.  **Server authentication token**:
    *   Click **Add** -> **Jenkins**.
    *   Kind: **Secret Text**.
    *   Secret: Paste *any* valid token created above (often an Admin User Token is best here so Jenkins can post to *any* project, or usage of specific project tokens can be handled via pipeline parameters, but usually one "Global Analysis Token" is easiest for the server config).
    *   ID: `sonarqube-token`.

---

## Part C: The Jenkinsfile Pipeline

The provided `Jenkinsfile` (updated below) will now:
1.  **Clone** your repo.
2.  **Backend Stage**: Use Maven to Compile & Scan (pushes to `myemohealth-backend` project).
3.  **Frontend Stage**: Use NodeJS to Install, Build, & Scan (pushes to `myemohealth-frontend` project).
4.  **Skip Deployment**: As requested, we comment out the `docker run` parts for now.

---

## Part D: GitHub & Webhook (for automation)
1.  **Ngrok**: `ngrok http 8080`.
2.  **GitHub Settings -> Webhook**:
    *   Payload URL: `https://<ngrok-id>.ngrok.io/github-webhook/`
    *   Content type: `application/json`.
    *   Event: **Push**.
