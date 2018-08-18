if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

if hash brew 2>/dev/null; then
	if [ -f $(brew --prefix)/etc/bash_completion ]; then
		. $(brew --prefix)/etc/bash_completion
	fi

	for f in $(brew --prefix)/share/bash-completion/completions/*; do
		source "$f";
	done
fi

export PATH="$HOME/.cargo/bin:$PATH"
