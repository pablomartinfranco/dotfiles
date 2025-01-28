# dotfiles

## Use SSH (if set up)...
git clone git@github.com:pablomartinfranco/dotfiles.git ~/.dotfiles

## ...or use HTTPS and switch remotes later
git clone https://github.com/pablomartinfranco/dotfiles.git ~/.dotfiles

## Create symlinks in the Home directory manualy or with cli tool (stow)
```bash
ln -s ~/.dotfiles/bash_profile ~/.bash_profile
ln -s ~/.dotfiles/gitconfig ~/.gitconfig
```

## [OPTIONAL]
## Generate a list of installed packages:
```bash
dpkg --get-selections > installed_packages.txt
```

## Reinstall packages from the list:
```bash
sudo apt-get update
sudo apt-get install dselect
sudo dpkg --set-selections < installed_packages.txt
sudo apt-get dselect-upgrade
```
