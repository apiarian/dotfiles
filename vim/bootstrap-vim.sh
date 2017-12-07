#!/bin/bash

set -xe

timestamp=`date`

cd ~

mv .vimrc ".vimrc-bkp-$timestamp" || true
mv .vim ".vim-bkp-$timestamp" || true

mkdir -p .vim/pack/minpac/opt
cd ~/.vim/pack/minpac/opt
git clone https://github.com/k-takata/minpac.git

cd ~/.vim

echo 'packadd minpac' > vimrc
echo 'call minpac#init()' >> vimrc

cd ~

ln -s .vim/vimrc .vimrc
