import os
import time
from random import randrange

from playwright.sync_api import sync_playwright

def test_app():
    with sync_playwright() as playwright:
        browser = playwright.chromium.launch(headless=False)
        context = browser.new_context()
        page = context.new_page()
        page.goto(os.environ.get("APP_URL"))
        iter = 1
        max = randrange(4, 9)
        while iter <= max:
            page.reload()
            iter += 1
            time.sleep(2)
        browser.close()
