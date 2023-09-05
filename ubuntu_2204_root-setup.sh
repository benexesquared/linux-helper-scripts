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

print "${COLOR_YELLOW}"
print "Updating System..."
print "${COLOR_RESET}"
sleep 2

apt update && apt upgrade -y
snap refresh
apt autoremove -y

print "${COLOR_YELLOW}"
print "Installing System Software"
print "${COLOR_RESET}"
sleep 2

apt install gnupg git build-essential openjdk-17-jdk python3-dev python3-pip python3-venv mesa-utils-bin -y
apt install vim shellcheck tmux ripgrep fd-find xclip trash-cli multitail tree jq rsync fzf libfuse2 -y
apt install apt-transport-https ca-certificates inetutils-traceroute net-tools curl wget httpie -y
apt install neofetch htop cmatrix lolcat sl bat duf hyperfine hexyl exa -y
apt install mariadb-server nginx software-properties-common -y

systemctl enable --now nginx.service
sed -i 's/#server_tokens/server_tokens/g' /etc/nginx/nginx.conf
systemctl restart nginx.service

# install docker
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/docker-install.sh | bash

if [[ -z $(command -v docker) ]]; then
    print "${COLOR_RED}"
    print "Docker Not Installed!"
    print "${COLOR_RESET}"
    sleep 2
fi

# install php
wget --quiet -O - https://raw.githubusercontent.com/benmoses-dev/linux-helper-scripts/main/php-install.sh | bash

if [[ -z $(command -v php) ]]; then
    print "${COLOR_RED}"
    print "PHP Not Installed!"
    print "${COLOR_RESET}"
    sleep 2
fi

print "${COLOR_GREEN}"
print "System Software Install Finished!"
print "${COLOR_RESET}"
sleep 2
