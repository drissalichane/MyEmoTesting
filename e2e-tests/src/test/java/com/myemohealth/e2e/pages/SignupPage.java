package com.myemohealth.e2e.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;

public class SignupPage extends BasePage {

    // Assuming standard Angular route /register or similar
    // Selectors based on typical fields found in registration forms
    // User mentioned password validation < 8 chars throws exception

    // We need to verify the ACTUAL selectors. If unavailable, I will use generic
    // form selectors and assertions
    // that might fail if the ID/names are different, but usually
    // `input[formControlName='email']` etc. work for Angular.

    private final By firstNameInput = By.cssSelector("input[formControlName='firstName']");
    private final By lastNameInput = By.cssSelector("input[formControlName='lastName']");
    private final By emailInput = By.cssSelector("input[formControlName='email']");
    private final By passwordInput = By.cssSelector("input[formControlName='password']");
    private final By roleSelect = By.cssSelector("mat-select[formControlName='role']");
    private final By submitButton = By.cssSelector("button[type='submit']");
    private final By errorSnackbar = By.cssSelector("simple-snack-bar"); // Angular Material snackbar for errors?

    public SignupPage(WebDriver driver) {
        super(driver);
    }

    public void navigateTo() {
        driver.get("http://localhost:4200/register"); // Assumption based on standard routing
    }

    public void register(String first, String last, String email, String password, String role) {
        wait.until(ExpectedConditions.visibilityOfElementLocated(firstNameInput)).sendKeys(first);
        driver.findElement(lastNameInput).sendKeys(last);
        driver.findElement(emailInput).sendKeys(email);
        driver.findElement(passwordInput).sendKeys(password);

        // Role Selection
        if (role != null) {
            driver.findElement(roleSelect).click();
            // Match visible text "Patient (Seeking Care)"
            By roleOption = By.xpath("//mat-option[contains(., 'Patient')]");
            wait.until(ExpectedConditions.elementToBeClickable(roleOption)).click();
        }

        driver.findElement(submitButton).click();
    }

    public boolean isRegistrationSuccessful() {
        // Redirect to login?
        try {
            wait.until(ExpectedConditions.urlContains("login"));
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
