#!/bin/bash

if [[ -z $JAVA_HOME ]]; then
    jpath=$(which java)
    if [[ $? != 0 ]]; then 
        echo "please install java first!"
        exit
    fi
    jpath=$(readlink $jpath)
    jpath=$(dirname $(dirname $jpath))
    if [[ -f "$HOME/.zshrc" ]]; then
        echo "export JAVA_HOME=\"$jpath\"" >> "$HOME/.zshrc"
        echo "JAVA_HOME is exported to ~/.zshrc, please run:\n    source ~/.zshrc"
        exit
    else
        if [[ -f "$HOME/.bash_profile" ]]; then
            fnm="$HOME/.bash_profile"
        else
            if [[ -f "$HOME/.profile" ]]; then
                fnm="$HOME/.profile"
            else
                fnm="$HOME/.bashrc"
            fi
        fi
    fi
else
    echo "JAVA_HOME is already in environment, exiting."
    exit
fi

echo "export JAVA_HOME=\"$jpath\"" >> $fnm
source $fnm
echo "JAVA_HOME is exported to $fnm"