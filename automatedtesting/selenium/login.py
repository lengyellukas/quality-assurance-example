# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options as ChromeOptions
from webdriver_manager.chrome import ChromeDriverManager
from selenium.common.exceptions import NoSuchElementException

# Start the browser and login with standard_user
def login (user, password):
    print ('Starting the browser...')
    options = ChromeOptions()
    options.add_argument("--headless") 
    driver = webdriver.Chrome(options=options)
    driver.maximize_window()
    print ('Browser started successfully. Navigating to the demo page to login.')
    driver.get('https://www.saucedemo.com/')
    #login
    print("Logging with user {}".format(user))
    WebDriverWait(driver, timeout=10).until(lambda d: d.find_element("id", "user-name"))
    driver.find_element(By.ID, "user-name").send_keys(user)
    driver.find_element(By.ID, "password").send_keys(password)
    driver.find_element(By.ID, "login-button").click()
    #wait for eshop page to load
    WebDriverWait(driver, timeout=10).until(lambda d: d.find_element(By.ID, "shopping_cart_container"))
    print("Successfully logged in with user {}".format(user))
    return driver

def add_all_products_to_cart(driver):
    print("Adding all products to the cart...")
    buttons = driver.find_elements(By.XPATH, "//button[contains(@id, 'add-to-cart-')]")
    for count, button in enumerate(buttons, start=1):
        button.click()
        print("Item numer %d added to the shopping cart" % count)
    #confirm the number of items in the shopping cart is equal to number of items
    capturedCount = driver.find_element(By.CLASS_NAME, "shopping_cart_badge").text
    assert int(capturedCount) == int(count)
    print("The number of added items to the cart (%d) is the same as number of items displayed in shopping cart icon" %count)
    return driver

def remove_all_products_from_cart(driver):
    print("Removing all products from the cart...")
    buttons = driver.find_elements("xpath", "//button[contains(@id, 'remove-')]")
    for count, button in enumerate(buttons, start=1):
        button.click()
        print("Item numer %d removed from the shopping cart" % count)
    #confirm the number of items in the shopping cart is 0
    capturedCount = 0
    try:
        capturedCount = driver.find_element(By.CLASS_NAME, "shopping_cart_badge").text
    except NoSuchElementException:
        print("Number of items in shopping cart not displayed, it should be 0")
    assert capturedCount == 0
    print("The number of items in the shopping cart is 0 after all items were removed")
    return driver

def tear_down(driver):
    driver.close()


driver = login('standard_user', 'secret_sauce')
driver = add_all_products_to_cart(driver)
driver = remove_all_products_from_cart(driver)
tear_down(driver)

