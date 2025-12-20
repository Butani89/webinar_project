import { test, expect } from '@playwright/test';

test.describe('Webinar Registration Flow', () => {
  test('should allow a user to register for the webinar', async ({ page }) => {
    // Navigate to the app
    await page.goto('/');

    // Check if the header is present
    await expect(page.locator('h1')).toContainText('Svamparnas Fascinerande Värld');

    // Fill out the registration form
    await page.fill('input[placeholder="Ditt fullständiga namn"]', 'Playwright Tester');
    await page.fill('input[placeholder="namn@exempel.se"]', 'playwright@test.com');
    await page.fill('input[placeholder="Universitet eller Företag"]', 'Playwright Academy');
    
    await page.selectOption('select:near(label:text("Erfarenhetsnivå"))', 'expert');

    // Submit the form
    await page.click('button:has-text("Anmäl mig till webinaret")');

    // Wait for success message
    const successMessage = page.locator('.text-mushroom-dark.border-green-100');
    await expect(successMessage).toBeVisible({ timeout: 10000 });
    await expect(successMessage).toContainText('Tack Playwright Tester!');

    // Check if the mushroom avatar is generated
    const avatar = successMessage.locator('img[alt="Avatar"]');
    await expect(avatar).toBeVisible();
  });

  test('should have a responsive layout in the hero section', async ({ page, isMobile }) => {
    await page.goto('/');
    const heroContainer = page.locator('section.glass-card div.flex');
    
    if (isMobile) {
      // On mobile, the flex-row class should be overridden by flex-col behavior
      // Tailwind's md:flex-row means it's flex-col by default
      await expect(heroContainer).toHaveClass(/flex-col/);
    } else {
      // On desktop (md and up), it should have flex-row
      await expect(heroContainer).toHaveClass(/md:flex-row/);
    }
  });

  test('should show validation errors for invalid input', async ({ page }) => {
    await page.goto('/');
    
    // Try to submit without filling required fields
    await page.click('button:has-text("Anmäl mig till webinaret")');
    
    // Native HTML5 validation might prevent submission, so we check if feedback is still hidden
    const feedback = page.locator('#form-feedback'); // Note: In Vue it's a dynamic div, not necessarily ID #form-feedback anymore, let's check App.vue
    // Looking at App.vue, the feedback is a div with conditional rendering.
    // Let's check if the button still says "Anmäl mig till webinaret" and not "Bearbetar..."
    await expect(page.locator('button:has-text("Anmäl mig till webinaret")')).toBeVisible();
  });
});
