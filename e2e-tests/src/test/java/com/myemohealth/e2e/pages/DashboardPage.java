package com.myemohealth.e2e.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.util.List;
import java.util.stream.Collectors;

public class DashboardPage extends BasePage {

    private final By dashboardContainer = By.cssSelector(".dashboard-container");
    private final By kpiCards = By.cssSelector(".kpi-card");
    private final By totalPatientsValue = By.cssSelector(".kpi-card.primary .value");

    // Navigation (Assuming a side nav exists, but based on components, maybe
    // buttons or URL nav)
    // Looking at patient-list.html, it seems to be under /patients possibly.
    // Let's assume standard routing or check if there is a nav defined in
    // app.component.html
    // For now, we can test current page elements.

    private final By chartCards = By.cssSelector(".chart-card");

    public DashboardPage(WebDriver driver) {
        super(driver);
    }

    public boolean isDashboardLoaded() {
        try {
            wait.until(ExpectedConditions.visibilityOfElementLocated(dashboardContainer));
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public int getKpiCardCount() {
        return driver.findElements(kpiCards).size();
    }

    public String getTotalPatientsText() {
        return driver.findElement(totalPatientsValue).getText();
    }

    public int getChartCount() {
        return driver.findElements(chartCards).size();
    }

    // Helper to navigate to patients if no direct button is easily selectable
    public void navigateToPatients() {
        driver.get("http://localhost:4200/patients");
    }
}
