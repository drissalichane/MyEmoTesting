package com.myemohealth.e2e.tests;

import com.myemohealth.e2e.pages.DashboardPage;
import com.myemohealth.e2e.pages.LoginPage;
import com.myemohealth.e2e.pages.PatientListPage;
import io.github.bonigarcia.wdm.WebDriverManager;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import java.time.Duration;

public class FullFlowTest {

    private WebDriver driver;
    private LoginPage loginPage;
    private DashboardPage dashboardPage;
    private PatientListPage patientListPage;

    private static final String APP_URL = "http://localhost:4200/login";

    @BeforeEach
    public void setUp() {
        WebDriverManager.chromedriver().setup();
        ChromeOptions options = new ChromeOptions();
        // options.addArguments("--headless");
        // options.addArguments("--disable-gpu");
        driver = new ChromeDriver(options);
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
        driver.manage().window().maximize();

        driver.get(APP_URL);
        loginPage = new LoginPage(driver);
        dashboardPage = new DashboardPage(driver);
        patientListPage = new PatientListPage(driver);
    }

    @Test
    public void testLoginAndDashboardNavigation() {
        // 1. Login
        loginPage.login("e2e_doctor@example.com", "password123");

        // 2. Verify Dashboard
        Assertions.assertTrue(dashboardPage.isDashboardLoaded(), "Dashboard should load after login");

        // 3. Check KPIs
        int kpiCount = dashboardPage.getKpiCardCount();
        Assertions.assertTrue(kpiCount >= 4, "Should be at least 4 KPI cards");

        // 4. Navigate to Patients
        dashboardPage.navigateToPatients();

        // 5. Verify Patient List
        Assertions.assertTrue(patientListPage.isLoaded(), "Patient list page should load");
        Assertions.assertTrue(patientListPage.isAddPatientButtonVisible(), "Add Patient button should be visible");
    }

    @AfterEach
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}
