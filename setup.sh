#!/bin/bash

sudo apt update

### Deps
sudo apt install -y git curl ca-certificates build-essential libz-dev libffi-dev libssl-dev libreadline-dev libyaml-dev wget
sudo install -m 0755 -d /etc/apt/keyrings

### Git
git config --global user.name "$USERNAME"
git config --global user.email $USERMAIL

ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -q -N "$SSHPWD" -C $USERMAIL

git config --global commit.gpgsign true
git config --global gpg.format ssh
git config --global user.signingkey $(echo ~/.ssh/id_ed25519.pub)


### Neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz 

echo "export PATH=\"\$PATH:/opt/nvim-linux64/bin\"" >> ~/.bashrc

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

# restart

exec $SHELL
