#!/bin/sh
pip install pep8
pip install nose
pip install nose_machineout
pip install vim_bridge
pip install mock

if [ -e ~/.vimrc ] ; then
    mv ~/.vimrc ~/.vimrc_back
fi

if [ -e ~/.vim ] ; then
    mv ~/.vim ~/.vim_back
fi

DIR=$(dirname $0)
cp -R $DIR/.vim ~/.vim
cp $DIR/.vimrc ~/.vimrc
