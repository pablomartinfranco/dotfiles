case $- in *i*) ;; *) return;; esac

umask 002

[ -f ~/.bash_aliases ] && . ~/.bash_aliases
