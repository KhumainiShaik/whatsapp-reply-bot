 #!/bin/bash

echo "[STARTUP] Updating system..."
apt-get update
apt-get install -y unzip wget python3-pip xvfb curl gnupg2

# Install Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb || apt -fy install

# Install ChromeDriver
CHROME_VERSION=$(google-chrome --version | cut -d ' ' -f 3 | cut -d '.' -f 1)
DRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION")
wget "https://chromedriver.storage.googleapis.com/$DRIVER_VERSION/chromedriver_linux64.zip"
unzip chromedriver_linux64.zip
mv chromedriver /usr/bin/
chmod +x /usr/bin/chromedriver

# Unzip Chrome profile
unzip /root/whatsapp_profile.zip -d /root/whatsapp_profile

# Install Python requirements
pip install selenium

# Launch bot in background and shutdown at 3:05 PM
echo "python3 /root/whatsapp_bot.py &" >> /root/launch_bot.sh
echo "echo 'shutdown -h now' | at 15:05" >> /root/launch_bot.sh
chmod +x /root/launch_bot.sh
bash /root/launch_bot.sh
