# Bash Login Monitor: Real-Time Intrusion Detection with Webcam Snapshots

This project is a lightweight Bash script that monitors system login attempts in real-time, detects multiple failed logins, captures the attacker's image using your webcam, and sends you an email alert with the snapshot and timestamp.

Ideal for laptops especially Linux systems  or anyone learning Bash, Linux security, or automation.

---

## What It Does

- Monitors `/var/log/auth.log` for login events
- Detects **3 consecutive failed login attempts** (configurable)
- Takes a **snapshot** with your webcam of the potential intruder
- Waits for **internet connection**, then sends an **email alert**
- Attaches the attacker's photo and exact **timestamp**
- Runs automatically on system boot via `cron`

---

## Project Structure

```
login-monitor-alert/
├── login-monitor.sh                # Main Bash script
├── README.md                       # This file
├── .gitignore                      # Ignores logs/sensitive info
├── logs/
│   ├── auth_copy.log               # Copied auth log
│   ├── fswebcam.log                # Logs webcam command output         
├── snapshots/
│   └── snapshot.jpg                # Captured image of intruder
├── config/
   └── msmtprc_example             # Sample SMTP config for msmtp

```

---

## Prerequisites

Install dependencies (Debian/Ubuntu):

```bash
sudo apt update && sudo apt install fswebcam msmtp sharutils
```

---

## Setup Guide

### 1. Clone the Repo

```bash
git clone https://github.com/your-username/login-monitor-alert.git
cd login-monitor-alert
```

### 2. Edit the Script

Open `login-monitor.sh` and update the following line:

```bash
echo "youremail@example.com"  # Replace with your real email
```

Also ensure that directory paths match your local structure if you move folders around.

### 3. Set Up `msmtp`

Configure Gmail or another SMTP provider using:

```bash
cp config/msmtprc_example ~/.msmtprc
chmod 600 ~/.msmtprc
```

Use GPG to encrypt your password if needed.

### 4. Test Email Sending

```bash
echo -e "Subject: Test Email\n\nThis is a test." | msmtp your-email@example.com
```

---

## Example Output

- ✅ `snapshot.jpg` saved after intrusion
- ✅ Timestamp included in the email
- ✅ Email alert sent automatically once online

> 📸 You can test this by attempting multiple failed SSH or sudo logins, then reviewing the logs and inbox.

---

## Running the Script

To run manually:

```bash
sudo ./login-monitor.sh
```

---

## Run on Startup with Cron

To run on system reboot:

```bash
sudo crontab -e
```

Add:

```bash
@reboot /absolute/path/to/login-monitor-alert/login-monitor.sh
```

You can also redirect logs with:

```bash
@reboot /path/to/login-monitor.sh >> /var/log/monitor-script.log 2>&1
```

---

## Author & Contact

Made with ❤️ by [Your Name]\
📧 [your-email@gmail.com](mailto\:your-email@gmail.com)\
🔗 [LinkedIn](https://www.linkedin.com/in/yourprofile)\
📁 [View Full Guide](./docs/detailed-doc.md)

---

## License

MIT License — feel free to fork, improve, and use this script for educational or personal use.

