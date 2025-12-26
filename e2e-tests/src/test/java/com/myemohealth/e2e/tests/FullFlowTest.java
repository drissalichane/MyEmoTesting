package com.myemohealth.e2e.tests;

import com.myemohealth.e2e.pages.DashboardPage;
import com.myemohealth.e2e.pages.LoginPage;
import com.myemohealth.e2e.pages.PatientListPage;
import com.myemohealth.e2e.pages.SidebarPage;
import io.github.bonigarcia.wdm.WebDriverManager;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import java.time.Duration;
import java.util.List;

public class FullFlowTest {

    private WebDriver driver;
    private LoginPage loginPage;
    private DashboardPage dashboardPage;
    private PatientListPage patientListPage;
    private SidebarPage sidebarPage;

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
        sidebarPage = new SidebarPage(driver);
    }

    @Test
    public void testFullApplicationFlow() {
        // --- SCENARIO 1: Login ---
        loginPage.login("testpatient@test.com", "12345678");
        Assertions.assertTrue(dashboardPage.isDashboardLoaded(), "Dashboard should load after login");

        // --- SCENARIO 2: Dashboard Validation ---

        // Check Welcome Message
        String welcome = dashboardPage.getWelcomeMessage();
        Assertions.assertTrue(welcome.contains("Welcome back"), "Welcome message should be present");
        // Note: The demo user lastName is 'Tester'
        Assertions.assertTrue(welcome.contains("patient"), "Welcome message should contain user's last name");

        // Check KPI Consistency
        int kpiCount = dashboardPage.getKpiCardCount();
        Assertions.assertEquals(4, kpiCount, "Should feature exactly 4 KPI cards");

        // --- SCENARIO 3: Navigation ---
        sidebarPage.navigateToPatients();
        Assertions.assertTrue(patientListPage.isLoaded(), "Should navigate to Patient List");

        // --- SCENARIO 4: Patient List Filtering ---
        // Assuming demo data includes specific patients. 'patient1@example.com' ->
        // Alice Dupont
        // Let's verify initial state
        int initialCount = patientListPage.getPatientRowCount();
        Assertions.assertTrue(initialCount > 0, "Should feature some patients initially");

        // Search for 'Alice'
        patientListPage.searchPatient("Alice");

        // Verify filter results
        List<String> names = patientListPage.getPatientNames();
        Assertions.assertFalse(names.isEmpty(), "Search should find 'Alice'");
        Assertions.assertTrue(names.stream().anyMatch(n -> n.contains("Alice")), "Filtered list should contain Alice");

        // --- SCENARIO 5: Logout ---
        sidebarPage.clickLogout();

        // Verify return to login page (checking URL or Login Button presence)
        // Since LoginPage doesn't have a 'isLoaded' yet, we check for email input
        // visibility
        try {
            // Re-instantiate or just use existing loginPage object's check
            // Actually reusing loginPage instance is fine as long as driver is same
            // loginPage.enterEmail(""); // This would throw if not present
            Assertions.assertTrue(driver.getCurrentUrl().contains("login"),
                    "Should redirect to login page after logout");
        } catch (Exception e) {
            Assertions.fail("Failed to verify logout redirection");
        }
    }

    @AfterEach
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}
