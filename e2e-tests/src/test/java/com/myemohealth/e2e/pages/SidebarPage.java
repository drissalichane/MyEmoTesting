package com.myemohealth.e2e.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;

public class SidebarPage extends BasePage {

    private final By logoutButton = By.xpath("//button[.//mat-icon[text()='logout']]");
    private final By userProfile = By.cssSelector(".user-profile");

    // Navigation Links
    private final By dashboardLink = By.cssSelector("a[routerLink='/dashboard']");
    private final By patientsLink = By.cssSelector("a[routerLink='/patients']");
    private final By qcmsLink = By.cssSelector("a[routerLink='/qcms']");
    private final By chatLink = By.cssSelector("a[routerLink='/chat']");

    public SidebarPage(WebDriver driver) {
        super(driver);
    }

    public boolean isUserProfileVisible() {
        try {
            wait.until(ExpectedConditions.visibilityOfElementLocated(userProfile));
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public void clickLogout() {
        wait.until(ExpectedConditions.elementToBeClickable(logoutButton)).click();
    }

    public void navigateToDashboard() {
        driver.findElement(dashboardLink).click();
    }

    public void navigateToPatients() {
        driver.findElement(patientsLink).click();
    }
}
