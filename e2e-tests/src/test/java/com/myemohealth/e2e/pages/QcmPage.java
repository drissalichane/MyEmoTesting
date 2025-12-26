package com.myemohealth.e2e.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;

import java.util.List;

import org.openqa.selenium.JavascriptExecutor;

public class QcmPage extends BasePage {

    // Main QCM List Page Elements
    private final By createTemplateButton = By.cssSelector("button[class*='primary-btn']");
    private final By templateCards = By.cssSelector(".template-card");
    private final By viewQuestionsButton = By.xpath("//button[.//mat-icon[text()='quiz']]");

    // Create Template Dialog Elements
    private final By titleInput = By.cssSelector("mat-dialog-container input[name='title']");
    private final By descriptionInput = By.cssSelector("mat-dialog-container textarea[name='description']");
    private final By categorySelect = By.cssSelector("mat-dialog-container mat-select[name='category']");
    // Strict selector for Create button inside the dialog
    private final By createButton = By.xpath("//mat-dialog-container//button[normalize-space()='Create']");
    private final By moodOption = By.cssSelector("mat-option[value='MOOD']");

    // Question Editor Dialog Elements
    private final By dialogTitle = By.cssSelector(".dialog-header h2");
    // Strict selector for Add button inside question editor
    private final By addNewQuestionButton = By
            .xpath("//app-question-editor-dialog//button[contains(., 'Add New Question')]");

    // Add Question Form inside Dialog
    private final By questionTextInput = By.xpath("//app-question-editor-dialog//textarea[@rows='3']");
    private final By questionTypeSelect = By
            .cssSelector("app-question-editor-dialog mat-select[aria-label='Question Type']");
    private final By saveQuestionButton = By.xpath("//app-question-editor-dialog//button[contains(., 'Save Changes')]");

    public QcmPage(WebDriver driver) {
        super(driver);
    }

    public void clickCreateTemplate() {
        WebElement btn = wait.until(ExpectedConditions.presenceOfElementLocated(createTemplateButton));
        // Use JS click to avoid ElementClickInterceptedException from overlays
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", btn);
    }

    public void fillTemplateForm(String title, String description) {
        WebElement titleEl = wait.until(ExpectedConditions.visibilityOfElementLocated(titleInput));
        titleEl.clear();
        titleEl.sendKeys(title);

        WebElement descEl = driver.findElement(descriptionInput);
        descEl.clear();
        descEl.sendKeys(description);

        // Select Category
        wait.until(ExpectedConditions.elementToBeClickable(categorySelect)).click();
        wait.until(ExpectedConditions.elementToBeClickable(moodOption)).click();

        // Click body to blur inputs and trigger validation
        driver.findElement(By.tagName("body")).click();

        // Short sleep to allow Angular validation to update button state
        try {
            Thread.sleep(1500);
        } catch (InterruptedException e) {
        }
    }

    public void submitTemplate() {
        WebElement btn = wait.until(ExpectedConditions.elementToBeClickable(createButton));
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", btn);
    }

    public boolean isTemplatePresent(String title) {
        try {
            wait.until(ExpectedConditions.visibilityOfElementLocated(templateCards));
            List<WebElement> cards = driver.findElements(templateCards);
            return cards.stream().anyMatch(card -> card.getText().contains(title));
        } catch (Exception e) {
            return false;
        }
    }

    public void openQuestionsForTemplate(String title) {
        // Find specific card and click view questions
        // This is complex with just CSS, using XPath for precision
        By viewBtn = By.xpath(
                "//div[@class='template-card' and contains(., '" + title + "')]//button[.//mat-icon[text()='quiz']]");
        wait.until(ExpectedConditions.elementToBeClickable(viewBtn)).click();
    }

    public String addQuestion(String text) {
        // Wait for the dialog to appear first
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.tagName("app-question-editor-dialog")));

        wait.until(ExpectedConditions.elementToBeClickable(addNewQuestionButton)).click();

        // Fill form
        wait.until(ExpectedConditions.visibilityOfElementLocated(questionTextInput)).sendKeys(text);

        // Save
        WebElement btn = driver.findElement(saveQuestionButton);
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", btn);

        // Handle Alert
        try {
            org.openqa.selenium.Alert alert = wait.until(ExpectedConditions.alertIsPresent());
            String alertText = alert.getText();
            alert.accept();
            return alertText;
        } catch (org.openqa.selenium.TimeoutException e) {
            return null;
        }
    }

    public boolean isQuestionPresent(String text) {
        try {
            // wait.until(ExpectedConditions.textToBePresentInElementLocated(By.cssSelector(".questions-list"),
            // text));
            // Better generic wait
            By qText = By.xpath("//div[@class='question-text' and contains(text(), '" + text + "')]");
            wait.until(ExpectedConditions.visibilityOfElementLocated(qText));
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
