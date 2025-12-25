package com.myemohealth.e2e.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;

public class PatientListPage extends BasePage {

    private final By pageTitle = By.cssSelector(".page-header h1");
    private final By addPatientButton = By.cssSelector(".primary-btn");
    private final By patientTable = By.tagName("table");
    private final By searchInput = By.cssSelector("input[matInput]");

    public PatientListPage(WebDriver driver) {
        super(driver);
    }

    public boolean isLoaded() {
        try {
            wait.until(ExpectedConditions.visibilityOfElementLocated(pageTitle));
            return driver.findElement(pageTitle).getText().contains("Patients");
        } catch (Exception e) {
            return false;
        }
    }

    public boolean isAddPatientButtonVisible() {
        return driver.findElement(addPatientButton).isDisplayed();
    }

    public void searchPatient(String query) {
        driver.findElement(searchInput).sendKeys(query);
    }

    public boolean hasPatientRows() {
        // Wait for table to potentially load rows
        // This is a basic check.
        try {
            wait.until(ExpectedConditions.presenceOfElementLocated(patientTable));
            return driver.findElements(By.cssSelector("tr.patient-row")).size() > 0;
        } catch (Exception e) {
            return false;
        }
    }
}
