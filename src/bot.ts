import { firefox, BrowserContext } from 'playwright';
import path from 'path';

const GROUP_NAME = 'Ev-Cargo Perfect Draft';
const TRIGGER_TEXT_1 = 'available shifts next week';
const TRIGGER_TEXT_2 = 'please respond';
const REPLY_TEXT = 'Hi, please book me in for 0600-1400 monday - friday. Thank you'.toLowerCase();

const USER_DATA_DIR = path.join(__dirname, 'whatsapp_profile');

function sanitizeMessage(message: string): string {
  return message.replace(/\s+/g, " ").trim();
}

(async () => {
  const context: BrowserContext = await firefox.launchPersistentContext(USER_DATA_DIR, {
    headless: false,
    args: [],
    viewport: null
  });

  const page = await context.newPage();
  await page.goto('https://web.whatsapp.com');
  console.log('[INFO] Please scan QR code (first time only)...');

  let lastRepliedText: string | null = null;

  while (true) {
    try {
      await page.waitForSelector(`span[title='${GROUP_NAME}']`, { timeout: 10000 });
      await page.click(`span[title='${GROUP_NAME}']`);

      await page.waitForSelector("div#main span.selectable-text[dir='ltr']", { timeout: 10000 });
      const messages = await page.$$("div#main span.selectable-text[dir='ltr']");

      if (messages.length) {
        const lastMsg = sanitizeMessage((await messages[messages.length - 1].innerText())).toLowerCase();
        const secondLastMsg = messages.length > 1
          ? sanitizeMessage((await messages[messages.length - 2].innerText())).toLowerCase()
          : '';

        console.log(`[INFO] Last message: ${lastMsg}`);

        const inputBox = await page.locator('div[contenteditable="true"][data-tab="10"]');        
        
        if (
          lastMsg !== lastRepliedText &&
          lastMsg.includes(TRIGGER_TEXT_1) &&
          lastMsg.includes(TRIGGER_TEXT_2)
        ) {
          console.log('[INFO] Trigger detected in last message, sending reply...');
          await inputBox?.fill(REPLY_TEXT);
          await inputBox?.press('Enter');
          lastRepliedText = lastMsg;
        }
        else if (
          lastMsg !== REPLY_TEXT &&
          secondLastMsg !== lastRepliedText &&
          secondLastMsg.includes(TRIGGER_TEXT_1) &&
          secondLastMsg.includes(TRIGGER_TEXT_2)
        ) {
          console.log('[INFO] Trigger detected in second-last message, sending reply...');
          await inputBox?.fill(REPLY_TEXT);
          await inputBox?.press('Enter');
          lastRepliedText = secondLastMsg;
        }
        else{
            console.log('[INFO] No trigger detected, skipping...');
        }
      }

      await new Promise(resolve => setTimeout(resolve, 1000));
    } catch (e) {
      console.warn('[WARN]', e);
      await new Promise(resolve => setTimeout(resolve, 5000));
    }
  }
})();
