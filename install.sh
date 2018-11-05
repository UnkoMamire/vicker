#!/usr/bin/env sh

ListFile=${ListFile:-`dirname $0`/list}
PackName=${PackName:-vicker}

while read line
do
	repo=`echo $line | cut -d: -f1`
	type=`echo $line | cut -d: -f2`
	build=`echo $line | cut -d: -f3`

	installpath=~/.vim/pack/$PackName/$type
	reponame=`basename $repo`
	mkdir -p $installpath
	if [ -d $installpath/$reponame ]; then
		git -C $installpath/$reponame pull
	else
		git -C $installpath clone https://github.com/$repo
	fi

	echo "cd $installpath/$reponame; $build" | sh

done < $ListFile

if which nvim; then
	which pip3 && ! (pip3 list --format=legacy | grep "neovim") && pip3 --user install neovim
	mkdir -p ~/.config
	ln -sfnv ~/.vim ~/.config/nvim
	ln -sfnv ~/.vimrc ~/.config/nvim/init.vim
	nvim +'UpdateRemotePlugins | q'
fi
