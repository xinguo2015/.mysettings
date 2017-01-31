#!/bin/bash

if [ ! -d ~/.vim ]; then
	mkdir ~/.vim
fi
cat ~/.mysettings/vim/vimrc >> ~/.vimrc


