#!/bin/bash
set -e

if [[ -z "$1" ]] || [[ "$1" -lt 21029 ]] || [[ "$1" -gt 21100 ]]; then
	echo "Please enter a valid port number (>21030 && <21100) to register on diablos"
	exit 1
fi
echo "Registering on port number $1 ..."

if [[ ! -d ~/.ssh ]]; then
	mkdir ~/.ssh
fi

if [[ ! -e ~/.ssh/reverseSSH.pub  ]]; then
    echo "Generating new pair of key for tunnel..."
    ssh-keygen -f ~/.ssh/reverseSSH
fi

echo "Copying new public key to diablos..."
scp ~/.ssh/reverseSSH.pub "manu@diablos.cgnan.fr:~/publicKeys/reverseSSH$(hostname).pub"

if [[ ! -e ~/.ssh/config ]]; then
    echo "Creating ~/.ssh/config file..."
	touch ~/.ssh/config
fi

if ! grep -q Host\ diablos < ~/.ssh/config; then
    echo "Adding host diablos to the config..."
	cat >> ~/.ssh/config << EOF
Host diablos
	Hostname diablos.cgnan.fr
	IdentityFile ~/.ssh/bastion

EOF
fi

if ! grep -q Host\ diablosTunnel < ~/.ssh/config; then
    echo "Adding host diablosTunnel to the config..."
	cat >> ~/.ssh/config << EOF
Host diablosTunnel
	Hostname diablos.cgnan.fr
	IdentityFile ~/.ssh/reverseSSH
	User sshtunnel
	RemoteForward "$1" localhost:22
EOF
fi

echo "Reloading remote config..."
ssh -t manu@diablos "./reloadKeys.sh"


read -p "Do you wish to install service ? (Y/n) : " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
	mkdir -p ~/.config/systemd/user/
	echo "Generating service..."
	cat > ~/.config/systemd/user/reverseSSH.service << EOF
[Unit]
Description=Keeps a tunnel to 'diablos.cgnan.fr' open
After=network-online.target

[Service]
# -M 0 --> no monitoring
# -N Just open the connection and do nothing (not interactive)
ExecStart=/usr/bin/autossh -N -M 0 -o "ServerAliveInterval 30" -o "ServerAliveCountMax 3" diablosTunnel

[Install]
WantedBy=default.target
EOF
	systemctl --user daemon-reload
	read -p "Do you wish to launch & enable service ? (Y/n) : " -n 1 -r
    echo
	if [[ ! $REPLY =~ ^[Nn]$ ]]
	then
        echo "Enabling service..."
		systemctl --user enable reverseSSH.service
		systemctl --user start reverseSSH.service
	fi
fi

echo "Done !"
