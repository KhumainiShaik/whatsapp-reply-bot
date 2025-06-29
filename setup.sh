#!/bin/bash
set -euxo pipefail

# 1️⃣ Avoid interactive prompts / deferred restarts
export DEBIAN_FRONTEND=noninteractive

# 3️⃣ Update & install dependencies
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends \
  unzip wget git curl gnupg2 ca-certificates at libu2f-udev \
  fonts-liberation libasound2 libatk-bridge2.0-0 libatk1.0-0 libc6 libcairo2 \
  libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgbm1 libgcc1 libglib2.0-0 \
  libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libx11-6 libx11-xcb1 libxcb1 \
  libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 \
  libxrandr2 libxrender1 libxss1 libxtst6 xdg-utils

git clone https://github.com/KhumainiShaik/whatsapp-reply-bot.git
cd whatsapp-reply-bot/src

# 9️⃣ Pull your WhatsApp profile from GCS and unzip
gsutil cp gs://whatsapp-bot-profile-secured/whatsapp_data.zip .
unzip -q whatsapp_data.zip -d .

# Download and install nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"

# Download and install Node.js:
nvm install 22

# Verify the Node.js version:
node -v # Should print "v22.16.0".
nvm current # Should print "v22.16.0".

# Verify npm version:
npm -v # Should print "10.9.2".


npm install playwright
npm install --save-dev typescript ts-node @types/node
npx tsc --init
npx playwright install firefox

# create bot.ts with your code

xvfb-run npm run start

sudo apt install --assume-yes ubuntu-gnome-desktop dbus-x11 x11-utils xinit

wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
sudo apt-get install --assume-yes ./chrome-remote-desktop_current_amd64.deb


# #!/bin/bash

# export DISPLAY=:99
# export NODE_OPTIONS=--no-deprecation

# # Start virtual X display
# Xvfb :99 -screen 0 1920x1080x24 &

# # Wait a bit for X to initialize
# sleep 3

# # Start DBus session
# eval "$(dbus-launch --sh-syntax)"
# export DBUS_SESSION_BUS_ADDRESS

# # Start GNOME session (optional for Firefox GUI rendering)
# gnome-session &

# # Wait for session
# sleep 10

# # Move to bot directory
# cd /home/YOUR_USERNAME/bot-folder

# # Run bot
# npx ts-node bot.ts



# # Clean any leftover Chrome locks (optional safety)
# find /root/whatsapp_profile -type f -name '*lock*' -delete || true

# rm -f /root/whatsapp_profile/SingletonLock
# rm -f /root/whatsapp_profile/SingletonCookie
# rm -f /root/whatsapp_profile/SingletonSocket
# rm -f /root/whatsapp_profile/.org.chromium.Chromium.lock

