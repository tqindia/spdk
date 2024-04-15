#!/bin/bash
ulimit -l

ufw disable

ufw allow 6443/tcp #apiserver
ufw allow from 10.42.0.0/16 to any #pods
ufw allow from 10.43.0.0/16 to any #services

sudo ufw allow 6443/tcp
sudo ufw reload

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -s -
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
sudo systemctl status k3s.service
sudo systemctl restart k3s.service


curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod a+x ./kubectl
mv ./kubectl /usr/local/bin/kubectl


