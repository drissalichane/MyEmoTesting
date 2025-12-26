package com.myemohealth.e2e.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;

public class DashboardPage extends BasePage {

    private final By dashboardContainer = By.cssSelector(".dashboard-container");
    private final By welcomeMessage = By.cssSelector(".header-section .subtitle");
    private final By kpiCards = By.cssSelector(".kpi-card");
    private final By totalPatientsValue = By.cssSelector(".kpi-card.primary .value");
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

    public String getWelcomeMessage() {
        return driver.findElement(welcomeMessage).getText();
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
}
