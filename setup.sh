#!/bin/sh
easy_install pep8
easy_install nose
esay_install nose_machineout
easy_install vim_bridge
easy_install mock

if [ -e ~/.vimrc ] ; then
    mv ~/.vimrc ~/.vimrc_back
fi

if [ -e ~/.vim ] ; then
    mv ~/.vim ~/.vim_back
fi

DIR=$(dirname $0)
cp -R $DIR/.vim ~/.vim
cp $DIR/.vimrc ~/.vimrc
