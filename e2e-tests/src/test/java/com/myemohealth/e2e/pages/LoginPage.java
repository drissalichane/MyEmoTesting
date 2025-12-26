package com.myemohealth.e2e.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;

public class LoginPage extends BasePage {

    private final By emailInput = By.cssSelector("input[formControlName='email']");
    private final By passwordInput = By.cssSelector("input[formControlName='password']");
    // Identifying the button by its content or class since it lacks a unique
    // ID/Name
    private final By loginButton = By.cssSelector("button.primary-btn");
    private final By errorMessage = By.cssSelector(".error-message");

    public LoginPage(WebDriver driver) {
        super(driver);
    }

    public void enterEmail(String email) {
        wait.until(ExpectedConditions.visibilityOfElementLocated(emailInput));
        driver.findElement(emailInput).sendKeys(email);
    }

    public void enterPassword(String password) {
        driver.findElement(passwordInput).sendKeys(password);
    }

    public void clickLogin() {
        driver.findElement(loginButton).click();
    }

    public void login(String email, String password) {
        enterEmail(email);
        enterPassword(password);
        clickLogin();
        try {
            wait.until(ExpectedConditions.urlContains("dashboard"));
        } catch (Exception e) {
            // Log or ignore if specific test handles verification,
            // but for general helper it's good to wait.
            // If login fails (e.g. invalid creds), this will timeout.
            // We might want to allow failing/checking error in test,
            // but for 'login' helper, success is usually implied.
        }
    }

    public String getErrorMessage() {
        return wait.until(ExpectedConditions.visibilityOfElementLocated(errorMessage)).getText();
    }

    public boolean isErrorMessageDisplayed() {
        try {
            return driver.findElement(errorMessage).isDisplayed();
        } catch (Exception e) {
            return false;
        }
    }

    public void clickSignupLink() {
        wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector(".register-link a"))).click();
    }
}
