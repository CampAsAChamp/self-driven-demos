import os
import time
from random import randrange

from playwright.sync_api import sync_playwright

def test_app():
    with sync_playwright() as playwright:
        browser = playwright.chromium.launch(headless=False)
        context = browser.new_context()
        page = context.new_page()
        url = "http://localhost:8000"
        page.goto(url)

        # Picked 5 as an arbitrary number
        for i in range(5):
            time.sleep(2)
            page.reload()

        browser.close()
