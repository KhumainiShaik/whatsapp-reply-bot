mkdir -p ~/.config/systemd/user
nano ~/.config/systemd/user/whatsapp-bot.service

# Paste the following content into the file
[Unit]
Description=Start WhatsApp bot on boot
After=network.target

[Service]
WorkingDirectory=/home/khumaini1011/WhatsApp-reply-bot
ExecStart=/usr/bin/xvfb-run /usr/bin/npm run start
Restart=always
RestartSec=10

[Install]
WantedBy=default.target

systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable whatsapp-bot.service

sudo loginctl enable-linger khumaini1011

systemctl --user start whatsapp-bot.service


gcloud projects add-iam-policy-binding propane-library-372214 \
  --member=serviceAccount:941099290859-compute@developer.gserviceaccount.com \
  --role=roles/compute.instanceAdmin.v1

gcloud functions deploy start-vm \
  --runtime python310 \
  --trigger-http \
  --entry-point start_vm \
  --source start_vm_cf \
  --allow-unauthenticated

gcloud functions deploy stop-vm \
  --runtime python310 \
  --trigger-http \
  --entry-point stop_vm \
  --source stop_vm_cf \
  --allow-unauthenticated
