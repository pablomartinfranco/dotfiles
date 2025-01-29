# dotfiles

### Use SSH (if set up)...
```bash
git clone git@github.com:pablomartinfranco/dotfiles.git ~/.dotfiles
```

### ...or use HTTPS and switch remotes later
```bash
git clone https://github.com/pablomartinfranco/dotfiles.git ~/.dotfiles
```

### Create symlinks in the Home directory manualy or with cli tool (stow)
```bash
ln -s ~/.dotfiles/bash_profile ~/.bash_profile
ln -s ~/.dotfiles/gitconfig ~/.gitconfig
```

### [OPTIONAL]
### Generate a list of installed packages:
```bash
dpkg --get-selections > installed_packages.txt
```

### Reinstall packages from the list:
```bash
sudo apt-get update
sudo apt-get install dselect
sudo dpkg --set-selections < installed_packages.txt
sudo apt-get dselect-upgrade
```
### TODO .dotfiles

karabiner
nvim
skhd
ssh
starship
go-blocksite
raycast
ranger
fish
fzf
btop
htop
tmux
tmuxinator
wezterm
zellij
zshrc

functions
gdbinit
gitattributes
gitconfig
curlrc
wgetrc
aliases
exports
editorconfig
bash_profile
bash_prompt
inputrc
hushlogin
screenrc
tmux.conf
nvimrc
vimrc
