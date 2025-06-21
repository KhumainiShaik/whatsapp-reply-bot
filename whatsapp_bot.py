import time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By

GROUP_NAME = "Testing bot"
TRIGGER_TEXT_1 = "available shifts next week"
TRIGGER_TEXT_2 = "please respond"
REPLY_TEXT = "Please book me in for 0600-1400 Monday - Friday"

options = Options()
options.add_argument("--user-data-dir=./whatsapp_profile")
driver = webdriver.Chrome(options=options)

driver.get("https://web.whatsapp.com")
print("[INFO] Please scan QR code (first time only)...")
time.sleep(10)

last_replied_text = None

try:
    while True:
        try:
            group = driver.find_element(By.XPATH, f"//span[@title='{GROUP_NAME}']")
            group.click()
            time.sleep(2)

            messages = driver.find_elements(By.XPATH, "//div[@id='main']//span[contains(@class, 'selectable-text') and @dir='ltr']")
            if messages:
                last_msg = messages[-1].text.strip().lower()
                last_msg_but_one = messages[-2].text.strip().lower() if len(messages) > 1 else ""
                print(f"[INFO] Last message: {last_msg}")

                if last_msg != last_replied_text and TRIGGER_TEXT_1 in last_msg and TRIGGER_TEXT_2 in last_msg:
                    print("[INFO] Trigger detected in last message, sending reply...")
                    input_box = driver.find_element(By.XPATH, "//footer//p[contains(@class, 'copyable-text')]")
                    input_box.send_keys(REPLY_TEXT)
                    input_box.send_keys("\n")
                    last_replied_text = last_msg 

                elif last_msg_but_one != last_replied_text and TRIGGER_TEXT_1 in last_msg_but_one and TRIGGER_TEXT_2 in last_msg_but_one:
                    print("[INFO] Trigger detected in second-last message, sending reply...")
                    input_box = driver.find_element(By.XPATH, "//footer//p[contains(@class, 'copyable-text')]")
                    input_box.send_keys(REPLY_TEXT)
                    input_box.send_keys("\n")
                    last_replied_text = last_msg_but_one 

            time.sleep(1)

        except Exception as e:
            print(f"[WARN] {e}")
            time.sleep(5)

except KeyboardInterrupt:
    print("Bot stopped by user.")
    driver.quit()
