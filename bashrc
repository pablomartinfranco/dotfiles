#!/bin/bash

case $- in *i*) ;; *) return;; esac

umask 002

load_bash_module() { [ -f "$1" ] && . "$1" }

# Load configuration modules
load_bash_module "~/.config/bash/env"
load_bash_module "~/.config/bash/aliases"
load_bash_module "~/.config/bash/functions"
load_bash_module "~/.config/bash/prompt"
load_bash_module "~/.config/bash/completion"
load_bash_module "~/.config/bash/local"

# History and interactive behavior
HISTSIZE=5000
HISTFILESIZE=10000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend checkwinsize cmdhist

# Load bash completion if available
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi
