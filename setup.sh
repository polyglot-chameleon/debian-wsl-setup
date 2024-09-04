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


### zsh & co
sudo apt install -y zsh

rm -rf "$HOME/.oh-my-zsh"
curl -fsSLO https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh

export RUNZSH=no

# Disable dialog
sed -i 's/\(echo "${FMT_BLUE}Time to change\)/<<nope\n  \1/g' install.sh
sed -i 'N;s/\(Shell change skipped."; return ;;\n  esac\)/\1\nnope/g' install.sh

# Disable pwd dialog
sed -i 's/sudo -k chsh -s "$zsh" "$USER"/sudo chsh -s "$zsh" "$USER"/g' install.sh

# Call with autocontinue
sed -i 's/exec zsh -l/exec zsh -9/g' install.sh

sh install.sh

### Neovim
echo "Downloading NVIM"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim-linux64
sudo tar -C /opt -xzf nvim-linux64.tar.gz 

echo "export PATH=\"\$PATH:/opt/nvim-linux64/bin\"" >> ~/.bashrc
echo "export PATH=\"\$PATH:/opt/nvim-linux64/bin\"" >> ~/.zshrc

zsh <<EOF
### Ruby Dev
echo "Downloading Ruby Dev env"
rm -rf ~/.rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
~/.rbenv/bin/rbenv init

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
EOF

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
