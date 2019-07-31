#!/bin/bash
set -e

cd ~/.ssh

if [[ ! -e "reverseSSH.pub"  ]]; then
        ssh-keygen -f "reverseSSH";
fi

scp "reverseSSH.pub" "manu@diablos.cgnan.fr:~/publicKeys/reverseSSH$(hostname).pub"

cat >> ~/.ssh/config << EOF
Host diablos
        Hostme diablos.cgnan.fr
        IdentityFile ~/.ssh/bastion

Host diablosTunnel
        Hostname diablos
        IdentityFile ~/.ssh/reverseSSH
        User sshtunnel
EOF

ssh -t manu@diablos "./reloadKeys.sh"

echo "Done !"
