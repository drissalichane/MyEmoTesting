# E2E Testing Instructions

This module contains Selenium E2E tests for the MyEmoHealth application.

## Prerequisites

- Java 17+
- Maven
- Chrome Browser installed on the machine running the tests

## Running Tests Locally

1. Ensure the Backend is running (`mvn spring-boot:run` in `../backend`).
2. Ensure the Frontend is running (`npm start` in `../frontend-web`).
3. Run the tests:
   ```bash
   mvn test
   ```

## Running in Jenkins Pipeline

The `Jenkinsfile` has been configured to run these tests in the `E2E Tests` stage.

**Note on CI Environment:**
- The Jenkins agent must have a browser installed (Chrome/Firefox) for Selenium to work.
- For headless execution (recommended for CI), uncomment the headless options in `LoginTest.java`.
- If the agent is a Docker container, ensure it includes a browser and WebDriver.
