if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

if hash brew 2>/dev/null; then
	if [ -f /usr/local/share/bash-completion/bash_completion ]; then
		. /usr/local/share/bash-completion/bash_completion
	fi
fi

export PATH="$HOME/.cargo/bin:$PATH"
