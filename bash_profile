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
VENV=$(if [[ -n $VIRTUAL_ENV ]]; then echo "${RST}($(basename $VIRTUAL_ENV)) "; fi)
USER_HOST="${CYN}\u${RST} @ ${CYN}\h${RST} "
DIR="[${BLU}\w${RST}]"

export PS1="\n${VENV}${USER_HOST}${DIR}\n\n${WHT}\$${RST} "

export PATH=$HOME/bin:$PATH
#if [ -d ${ DIR:=~/bin } ]; then
#    export PATH=$DIR:$PATH
#fi
#if [ -d ${ DIR:=~/opt/java/jdk-21/bin } ]; then
#    export PATH=$DIR:$PATH
#fi
#if [ -d ${ DIR:=~/opt/python/cpython-10/bin } ]; then
#    export PATH=$DIR:$PATH
#    [ -f ${ FILE:=~/opt/python/ansible/activate } ] && . $FILE
#fi
#if [ -d ${ DIR:=~/opt/haskell/bin } ]; then
#    export PATH=$DIR:$PATH
#    export PATH=$HOME/.cabal/bin:$PATH
#    export PATH=$HOME/opt/haskell/stack-3.1.1-x86_64:$PATH
#    export PATH=$HOME/opt/haskell/ghc-9.10.1-x86_64/bin:$PATH
#    export STACK_ROOT=$HOME/opt/haskell/.stack
#fi
#if [ -d ${ DIR:=~/opt/sdkman } ]; then
#    export SDKMAN_DIR=$DIR
#    [ -f ${ FILE:=$DIR/bin/sdkman-init.sh } ] && . $FILE
#fi
