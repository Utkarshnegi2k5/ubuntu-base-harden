# Ubuntu Linux Base Hardening Script

This repository provides a **base hardening script** for Ubuntu 22.04 (Jammy Jellyfish). It's intended to quickly raise the baseline security level of your Linux VM or server with a single command.

---

## 🔐 What It Does

The script performs the following tasks:

### ✅ System Preparation

	* Updates all packages
	* Installs essential security tools: `ufw`, `fail2ban`, `clamav`, `lynis`, `apparmor`, `auditd`, `debsums`, `mailutils`

### 🔥 Firewall Configuration

	* Enables and configures UFW

  		* Deny all incoming traffic by default
  		* Allow outgoing traffic
  		* Allow SSH (port 22)

### 🛡️ Fail2Ban Setup

	* Enables brute-force protection
	* Sets SSH bantime to permanent (`-1`)

### 🔐 SSH Hardening

	* Disables root login
	* Disables password authentication

### 🧱 AppArmor Enforcement

	* Ensures all profiles are in `enforce` mode

### 🦠 ClamAV Antivirus

	* Updates virus definitions
	* Scans the full filesystem for threats

### ⚙️ Service Hardening

	* Disables unneeded services: `snapd`, `multipathd`, `serial-getty`

### 📝 Logging and Auditing

	* Enables audit logging with `auditd`
	* Validates installed packages with `debsums`

### 🔎 Lynis Security Audit

	* Runs `lynis` and saves the result to `~/lynis_report.txt`

-----------------------------------------------------------------------------

## 🧪 Requirements

	* Ubuntu 22.04 (Jammy)
	* `sudo` privileges

-----------------------------------------------------------------------------

## 🚀 How to Use

```bash
# Clone the repo
	git clone https://github.com/Utkarshnegi2k5/ubuntu-base-harden.git
	cd linux-base-harden

# Run the hardening script
	chmod +x base-harden.sh
	sudo ./base-harden.sh
```

After execution, view the Lynis report:

```bash
	cat ~/lynis_report.txt
```

---

## 📈 Security Score

	* You should expect a **Lynis Hardening Index** of around **69–72** with this script.
	* It's intended as a baseline. Advanced users can extend this by adding stricter rules in a custom script (e.g., secure-harden.sh).

---

## 🧩 Customization

Users can:

* Modify SSH ports or user access
* Add email alerts from `fail2ban`
* Enable secure logging to remote syslog

---

## 📬 Contribution

Feel free to fork and submit pull requests to enhance this script for various scenarios (cloud, desktop, or production servers).

---

## ⚠️ Disclaimer

This script performs **security-sensitive changes**. It is intended for VMs and servers under your control. Please test thoroughly before using in production.
