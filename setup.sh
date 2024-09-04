#!/bin/bash

sudo apt update

### Deps
sudo apt install -y git curl ca-certificates build-essential libz-dev libffi-dev libssl-dev libreadline-dev libyaml-dev wget
sudo install -m 0755 -d /etc/apt/keyrings

### Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz 

echo "export PATH=\"\$PATH:/opt/nvim-linux64/bin\"" >> ~/.bashrc

### Go
sudo rm -rf /usr/local/go
curl -LO https:/go.dev/dl/go1.23.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz
echo "export PATH=\"\$PATH:/usr/local/go/bin\"" >> ~/.bashrc
echo "export PATH=\"\$PATH:/usr/local/go/bin\"" >> ~/.zprofile

### NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

### Python3
sudo apt install -y python3 python3-pip

### Ruby Dev
rm -rf ~/.rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
~/.rbenv/bin/rbenv init

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

### Docker
sudo sh -c "printf \"[boot]\nsystemd=true\n\" > /etc/wsl.conf"

for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo groupadd docker
sudo usermod -aG docker $USER

### restart WSL ###

exec $SHELL
