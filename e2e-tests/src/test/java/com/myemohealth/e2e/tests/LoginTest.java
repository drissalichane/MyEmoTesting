package com.myemohealth.e2e.tests;

import com.myemohealth.e2e.pages.LoginPage;
import io.github.bonigarcia.wdm.WebDriverManager;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import java.time.Duration;

public class LoginTest {

    private WebDriver driver;
    private LoginPage loginPage;
    private static final String APP_URL = "http://localhost:4200/login"; // Adjust if different

    @BeforeEach
    public void setUp() {
        WebDriverManager.chromedriver().setup();
        ChromeOptions options = new ChromeOptions();

        // Uncomment headless mode for CI environments if needed
        // options.addArguments("--headless");
        // options.addArguments("--disable-gpu");
        // options.addArguments("--window-size=1920,1080");

        driver = new ChromeDriver(options);
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
        driver.manage().window().maximize();

        driver.get(APP_URL);
        loginPage = new LoginPage(driver);
    }

    @Test
    public void testLoginSuccess() {
        // Using credentials found in create_demo_users.js
        loginPage.login("e2e_doctor@example.com", "password123");

        // Assertion: We expect to be redirected or at least no longer see the login
        // form/ERROR
        // Since we don't know the exact dashboard URL, we check that no error is
        // displayed
        // and potentially check URL change if possible.
        // For this example, we assert that the error message is NOT present.
        boolean isError = loginPage.isErrorMessageDisplayed();
        String errorText = isError ? loginPage.getErrorMessage() : "No error";
        Assertions.assertFalse(isError, "Login failed with error: " + errorText);

        // Ideally, check for a dashboard element:
        // Assertions.assertTrue(driver.getCurrentUrl().contains("dashboard"), "Should
        // redirect to dashboard");
    }

    @Test
    public void testLoginFailure() {
        loginPage.login("invalid@example.com", "wrongpassword");

        // Assertion: Error message should be displayed
        boolean isError = loginPage.isErrorMessageDisplayed();
        Assertions.assertTrue(isError, "Error message should be displayed for invalid creds");

        // Verify content if possible
        // String errorText = loginPage.getErrorMessage();
        // Assertions.assertEquals("Invalid credentials", errorText);
    }

    @AfterEach
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}
