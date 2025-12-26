package com.myemohealth.e2e.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import java.util.List;
import java.util.stream.Collectors;

public class PatientListPage extends BasePage {

    private final By pageTitle = By.cssSelector(".page-header h1");
    private final By addPatientButton = By.cssSelector(".primary-btn");
    private final By patientTable = By.tagName("table");
    private final By patientRows = By.cssSelector("tr.patient-row");
    private final By patientNames = By.cssSelector("tr.patient-row .patient-name");
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
        WebElement input = driver.findElement(searchInput);
        input.clear();
        input.sendKeys(query);
        // Wait briefly for filter to apply (simple sleep for demo, can be improved with
        // explicit wait for table change)
        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
        }
    }

    public int getPatientRowCount() {
        return driver.findElements(patientRows).size();
    }

    public List<String> getPatientNames() {
        return driver.findElements(patientNames).stream()
                .map(WebElement::getText)
                .collect(Collectors.toList());
    }
}
