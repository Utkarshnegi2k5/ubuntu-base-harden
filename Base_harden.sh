#!/bin/bash
# Harden Ubuntu Linux - Base Hardening Script (Score ~69+)
# Tested on Ubuntu 22.04 Jammy

set -e

log() {
  echo -e "[+] $1"
}

############################
# 1. Update & Basic Tools #
############################
log "Updating packages..."
sudo apt update && sudo apt upgrade -y
log "Installing hardening tools..."
sudo apt install -y ufw fail2ban clamav clamav-daemon lynis apparmor apparmor-utils auditd debsums mailutils

####################
# 2. UFW Firewall #
####################
log "Setting up UFW..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable

########################
# 3. Fail2Ban         #
########################
log "Configuring Fail2Ban..."
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
sudo bash -c 'echo -e "[sshd]\nbantime = -1" > /etc/fail2ban/jail.d/sshd.local'
sudo systemctl restart fail2ban

########################
# 4. SSH Configuration #
########################
log "Hardening SSH config..."
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart ssh

#######################
# 5. AppArmor         #
#######################
log "Enabling AppArmor..."
sudo systemctl enable apparmor
sudo systemctl start apparmor
sudo aa-enforce /etc/apparmor.d/* || true

##########################
# 6. ClamAV Antivirus   #
##########################
log "Updating ClamAV..."
sudo systemctl stop clamav-freshclam || true
sudo freshclam
log "Running full system scan..."
sudo clamscan -r -i --bell /

########################
# 7. Disable Unneeded #
########################
log "Disabling unnecessary services..."
sudo systemctl disable multipathd.service || true
sudo systemctl disable serial-getty@ttyS0.service || true
sudo systemctl disable snapd || true
sudo apt purge snapd -y

#########################
# 8. Clean & Mail Setup #
#########################
log "Installing mail support..."
sudo apt install mailutils -y
log "Cleaning unused packages..."
sudo apt autoremove --purge -y

#############################
# 9. Auditd & Integrity     #
#############################
log "Enabling AuditD (activity logging)..."
sudo apt install auditd -y
sudo systemctl enable auditd
sudo systemctl start auditd

log "Verifying package integrity with debsums..."
sudo apt install debsums -y
sudo debsums -s || true

######################
# 10. Lynis Audit    #
######################
log "Running Lynis audit..."
sudo lynis audit system > ~/lynis_report.txt

log "Base hardening complete. See ~/lynis_report.txt for details."
#echo "To reach 75+ score, run: sudo bash harden-more.sh (WIP)"
