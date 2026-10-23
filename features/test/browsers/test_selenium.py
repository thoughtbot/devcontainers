import subprocess

from selenium import webdriver
from selenium.webdriver.chrome.service import Service

from selenium.common.exceptions import SessionNotCreatedException

service = Service(
  executable_path="/usr/local/bin/chromedriver",
  service_args=['--log-level=ALL'],
  log_output=subprocess.STDOUT)
options = webdriver.ChromeOptions()
options.add_argument("--headless")
options.add_argument("--no-sandbox")

try:
    driver = webdriver.Chrome(service=service, options=options)
except SessionNotCreatedException as e:
    print(e.msg)
    exit(1)

driver.get("https://example.com")
title = driver.title
driver.quit()

if title != "Example Domain":
    print("Expected example.com page title to be \"Example Domain\", "
          "but it was \"%s\"" % title)
    exit(2)
