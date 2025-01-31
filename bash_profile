# ~/.bash_profile: executed by bash(1) for login shells.

[ -f ~/.bashrc ] && . ~/.bashrc

[ -f ~/.config/bash/bash_aliases ] && . ~/.config/bash/bash_aliases

umask 002

GRN="\[\e[1;32m\]"
YLW="\[\e[1;33m\]"
BLU="\[\e[1;34m\]"
MAG="\[\e[1;35m\]"
CYN="\[\e[1;36m\]"
WHT="\[\e[1;37m\]"
RST="\[\e[0m\]"
VENV=$(if [[ -n "$VIRTUAL_ENV" ]]; then echo "${RST}($(basename $VIRTUAL_ENV)) "; fi)
USER_HOST="${CYN}\u${RST} @ ${CYN}\h${RST} "
DIR="[${BLU}\w${RST}]"

export PS1="\n${VENV}${USER_HOST}${DIR}\n\n${WHT}\$${RST} "

if [ -d "${BIN:=$HOME/bin}" ]; then
    for DIR in "$BIN"/*/; do
        [ -d "$DIR" ] && PATH="$DIR:$PATH"
    done
    export PATH="$BIN:$PATH"
fi

if [ -d "$HOME/bin/graalvm-bin" ]; then 
    export GRAALVM_HOME="$HOME/opt/java/graalvm-jdk-21"
fi
