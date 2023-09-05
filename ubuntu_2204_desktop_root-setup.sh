#!/usr/bin/env bash

set -e

# Colours
COLOR_RED=$(tput setaf 1)
COLOR_GREEN=$(tput setaf 2)
COLOR_YELLOW=$(tput setaf 3)
COLOR_BLUE=$(tput setaf 4)
COLOR_RESET=$(tput sgr0)
SILENT=false

print() {
	if [[ "${SILENT}" == false ]]; then
		echo -e "$@"
	fi
}

if [[ "$EUID" -ne 0 ]]; then
	print "${COLOR_RED}"
	print "Please run this script as root!"
	print "${COLOR_RESET}"
	exit 0
fi

showLogo() {
	print "${COLOR_YELLOW}"
	print "Ubuntu Setup"
	print "${COLOR_BLUE}"
	print " ___    _____   __  _  _  _______   ___    ____   "
	print "|   \  |  ___| / / | |/ /|__   __| / _ \  |  _ \  "
	print "| |\ \ | |___ | |  |   /    | |   / / \ \ | (_) | "
	print "| | | ||  ___| \ \ |   \    | |  | |   | || .__/  "
	print "| |/ / | |___   | || |\ \   | |   \ \_/ / | |     "
	print "|___/  |_____| /_/ |_| \_\  |_|    \___/  |_|     "
	print "                                                  "
	print "${COLOR_RESET}"
}

showLogo
sleep 3

# install system software
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/ubuntu_2204_root-setup.sh | bash

print "${COLOR_YELLOW}"
print "Installing Desktop Software"
print "${COLOR_RESET}"
sleep 2
apt update && apt install vlc filezilla gnome-tweaks libreoffice libreoffice-help-en-gb virt-manager -y

if [[ -n $(command -v syncthing) ]]; then
	print "${COLOR_RED}"
	print "Syncthing is already installed!"
	print "${COLOR_RESET}"
	sleep 2
else
	print "${COLOR_YELLOW}"
	print "Installing Syncthing"
	print "${COLOR_RESET}"
	sleep 2

	curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
	echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | tee /etc/apt/sources.list.d/syncthing.list
	printf "Package: *\nPin: origin apt.syncthing.net\nPin-Priority: 990\n" | tee /etc/apt/preferences.d/syncthing
	apt update && apt install syncthing -y

    if [[ -n $(command -v syncthing) ]]; then
        print "${COLOR_GREEN}"
        print "Syncthing Installed Successfully!"
        print "${COLOR_RESET}"
        sleep 2
    else
        print "${COLOR_RED}"
        print "Syncthing Not Found On Path!"
        print "${COLOR_RESET}"
        sleep 2
    fi
fi

print "${COLOR_GREEN}"
print "Desktop Software Install Finished!"
print "${COLOR_RESET}"
sleep 2
