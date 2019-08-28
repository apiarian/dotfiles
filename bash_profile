if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh"  ]] && .  "/usr/local/etc/profile.d/bash_completion.sh"
