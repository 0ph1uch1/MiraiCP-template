#!/bin/bash

if [[ -z $JAVA_HOME ]];then
    jpath=$(which java)
    if [[ $? != 0 ]];then 
        echo "please install java first!"
        exit
    fi
    jpath=$(readlink $jpath)
    jpath=$(dirname $(dirname $jpath))
    if [[ -f "$HOME/.zshrc" ]];then
        echo "export JAVA_HOME=\"$jpath\"" >> "$HOME/.zshrc"
        echo "JAVA_HOME is exported to .zshrc, please run:\n    source ~/.zshrc"
    else
        if [[ -f "$HOME/.bash_profile" ]];then
            echo "export JAVA_HOME=\"$jpath\"" >> "$HOME/.bash_profile"
            source "$HOME/.bash_profile"
        else
            if [[ -f "$HOME/.profile" ]];then
                echo "export JAVA_HOME=\"$jpath\"" >> "$HOME/.profile"
                source "$HOME/.profile"
            else
                echo "export JAVA_HOME=\"$jpath\"" >> "$HOME/.bashrc"
                source "$HOME/.bashrc"
            fi
        fi
    fi
else
    echo "JAVA_HOME is already in environment, exiting."
    exit
fi

