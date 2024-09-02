sudo apt update

### Deps
sudo apt install -y git curl build-essential libz-dev libffi-dev libssl-dev libreadline-dev libyaml-dev wget


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

exec $SHELL
