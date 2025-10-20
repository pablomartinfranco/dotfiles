#!/bin/bash

# Source dotfiles
[ -f ~/.bashrc ] && . ~/.bashrc

# Basic environment
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export EDITOR="nano"
export VISUAL="$EDITOR"
export PAGER="less"

umask 022

path_add() {  # Add to PATH if not already present
    case ":$PATH:" in
        *":$1:"*) return ;;  # already in PATH
        *) PATH="$1:$PATH" ;;
    esac
}

if [ -d "${BIN:=$HOME/bin}" ]; then
    path_add "$BIN"
    for DIR in "$BIN"/*/; do
        [ -d "$DIR" ] || continue
	path_add "$DIR"
	echo "Added to PATH -> $DIR"
    done
    export PATH
fi

DIR="$HOME/bin/go"
if [ -d "$DIR" ]; then
    DEREF=$(readlink -f "$DIR")
    echo "Detected : $DIR -> $DEREF"
    export GOROOT=$(dirname "$DEREF")
    export GOPATH=$(dirname "$GOROOT")
fi

DIR="$HOME/bin/cabal"
if [ -d "$DIR" ]; then
    DEREF=$(readlink -f "$DIR")
    echo "Detected : $DIR -> $DEREF"
    export CABAL_HOME="$DEREF"
fi

DIR="$HOME/bin/python3/--disabled"
if [ -d "$DIR" ]; then
    DEREF=$(dirname $(readlink -f "$DIR"))
    echo "Detected : $DIR -> $DEREF"
    export PYTHON_FOR_BUILD="$DEREF/bin/python3"
    export PYTHON="$DEREF/bin/python3"
    export PATH="$DEREF:$PATH"
fi

DIR="$HOME/bin/graalvm"
if [ -d "$DIR" ]; then
    DEREF=$(dirname $(readlink -f "$DIR"))
    echo "Detected : $DIR -> $DEREF"
    export GRAALVM_HOME="$DEREF"
    export JAVA_HOME="$DEREF"
    JAVA_OPTS="-XX:+UseG1GC -XX:+UseStringDeduplication"
    JAVA_OPTS+=" -Xss4m -Xms100m"
    export JAVA_OPTS
fi

DIR = "$HOME/bin/kotlinc"
if [ -d "$DIR" ]; then
    DEREF=$(dirname $(readlink -f "$DIR"))
    echo "Detected : $DIR -> $DEREF"
    export KOTLIN_HOME="$DEREF"
fi

DIR="$HOME/opt/scala/scala3"
if [ -d "$DIR" ]; then
    echo "Detected : $DIR"
    export SCALA_HOME="$DIR"
fi

FILE="$HOME/opt/python/venv-cpy311/bin/activate"
[ -f "$FILE" ] && . "$FILE"
