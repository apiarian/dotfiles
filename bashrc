export PROMPT_COMMAND='history -a'
export CC="/usr/bin/clang"
export GOPATH="$HOME/code/go"
export PATH="/usr/local/go/bin:$GOPATH/bin:$PATH"
export VAUL_ADDR="https://vault.prod.flatiron.io"
# make lifesci_portal_v2 scripts work
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
if [[ `uname` == 'Darwin' ]]; then
	export PATH="/usr/local/bin:/usr/local/sbin:/$HOME/bin:$PATH"
	export MANPATH="$MANPATH:/usr/local/man"

	alias lyrics='slyrics;elyrics'
	alias plyrics="osascript $HOME/development/Applescript/lyrics.scpt | tr \"#\" \"\n\""

	alias new-alacritty='open -n -a /Applications/Alacritty.app'

	cdf () {
		currFolderPath=$( /usr/bin/osascript <<EOT
tell application "Finder"
	try
		set currFolder to (folder of the front window as alias)
	on error
		set currFolder to (path to desktop folder as alias)
	end try
	POSIX path of currFolder
end tell
EOT
)
	echo "cd to \"$currFolderPath\""
	cd "$currFolderPath"
}

  manpdf () { man -t "$1" | open -f -a /Applications/Preview.app/; }

  #export CC="xcrun clang"
  export CXX="xcrun clang++"
  export OBJC="xcrun clang"
fi

# Reset
Color_Off='\[\e[0m\]'       # Text Reset

# Regular Colors
Black='\[\e[0;30m\]'        # Black
Red='\[\e[0;31m\]'          # Red
Green='\[\e[0;32m\]'        # Green
Yellow='\[\e[0;33m\]'       # Yellow
Blue='\[\e[0;34m\]'         # Blue
Purple='\[\e[0;35m\]'       # Purple
Cyan='\[\e[0;36m\]'         # Cyan
White='\[\e[0;37m\]'        # White

# Bold
BBlack='\[\e[1;30m\]'       # Black
BRed='\[\e[1;31m\]'         # Red
BGreen='\[\e[1;32m\]'       # Green
BYellow='\[\e[1;33m\]'      # Yellow
BBlue='\[\e[1;34m\]'        # Blue
BPurple='\[\e[1;35m\]'      # Purple
BCyan='\[\e[1;36m\]'        # Cyan
BWhite='\[\e[1;37m\]'       # White

# Underline
UBlack='\[\e[4;30m\]'       # Black
URed='\[\e[4;31m\]'         # Red
UGreen='\[\e[4;32m\]'       # Green
UYellow='\[\e[4;33m\]'      # Yellow
UBlue='\[\e[4;34m\]'        # Blue
UPurple='\[\e[4;35m\]'      # Purple
UCyan='\[\e[4;36m\]'        # Cyan
UWhite='\[\e[4;37m\]'       # White

# Background
On_Black='\[\e[40m\]'       # Black
On_Red='\[\e[41m\]'         # Red
On_Green='\[\e[42m\]'       # Green
On_Yellow='\[\e[43m\]'      # Yellow
On_Blue='\[\e[44m\]'        # Blue
On_Purple='\[\e[45m\]'      # Purple
On_Cyan='\[\e[46m\]'        # Cyan
On_White='\[\e[47m\]'       # White

# High Intensty
IBlack='\[\e[0;90m\]'       # Black
IRed='\[\e[0;91m\]'         # Red
IGreen='\[\e[0;92m\]'       # Green
IYellow='\[\e[0;93m\]'      # Yellow
IBlue='\[\e[0;94m\]'        # Blue
IPurple='\[\e[0;95m\]'      # Purple
ICyan='\[\e[0;96m\]'        # Cyan
IWhite='\[\e[0;97m\]'       # White

# Bold High Intensty
BIBlack='\[\e[1;90m\]'      # Black
BIRed='\[\e[1;91m\]'        # Red
BIGreen='\[\e[1;92m\]'      # Green
BIYellow='\[\e[1;93m\]'     # Yellow
BIBlue='\[\e[1;94m\]'       # Blue
BIPurple='\[\e[1;95m\]'     # Purple
BICyan='\[\e[1;96m\]'       # Cyan
BIWhite='\[\e[1;97m\]'      # White

# High Intensty backgrounds
On_IBlack='\[\e[0;100m\]'   # Black
On_IRed='\[\e[0;101m\]'     # Red
On_IGreen='\[\e[0;102m\]'   # Green
On_IYellow='\[\e[0;103m\]'  # Yellow
On_IBlue='\[\e[0;104m\]'    # Blue
On_IPurple='\[\e[10;95m\]'  # Purple
On_ICyan='\[\e[0;106m\]'    # Cyan
On_IWhite='\[\e[0;107m\]'   # White

function gitPSpart() {
  s=`git status --porcelain=2 --branch 2>&1`;
  if [[ $? -ne 0 ]]; then return; fi;
  echo "$s" | grep '# branch.head .*' | sed 's/# branch.head //' | tr  '\n' ' ';
  if [[ `echo "$s" | grep -vc '#.*'` -ne 0  ]]; then echo -n '*'; fi;
}
function gitBranch() {
  git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

export PS1="${Red}[${Green} \t ${Red}] ${Cyan}\u${Red}@${Cyan}\h${Red}: ${Yellow}\w ${Green}\`gitBranch\` $VIMTERM``${Cyan}\`if [[ -z \"\\\`jobs\\\`\" ]]; then echo ''; else echo -n {; jobs|awk '{print \$3}'|tr '\n' ' '|xargs echo -n; echo -n }; fi\`\n${Color_Off}"
export PS2="${Yellow}) ${Color_Off}"

shopt -s histappend
shopt -s histverify
export HISTIGNORE="&:exit"
export HISTFILESIZE=5000
export HISTSIZE=5000
export HISTCONTROL=ignoreboth
shopt -s cmdhist

export CLICOLOR=1
export LSCOLORS='Gxfxcxdxbxegedabagacad'
export LESS='-XFR'

export LANG=en_US.UTF-8
export PYTHONIOENCODING=utf-8

export EDITOR=vim

export GPG_TTY=`tty`

alias ls='ls -lah'
alias lsc='ls -aC'
alias lsf='ls -d "$PWD"/*'
alias bell='echo -e "\a"'
alias vimp='vim +Project'
alias gits='git status'
alias gitc='git commit -v'
alias gitp='git push origin master'
alias passphrase='xkcdpass --min=4 --max=7 --numwords=5 --count=5'
alias rot13="tr a-zA-Z n-za-mN-ZA-M"
alias :q="exit"
alias psqlservices="less ~/.pg_service.conf | grep -e '\[.*\]' | sed -E 's/\[(.*)]/\1/' | sort"
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias activate-env-3="source ~/code/env3/bin/activate"
alias start_postgres='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias gmerge='export _CUR_BRANCH=`git branch --show-current` && git fetch origin master && git rebase origin/master && git checkout master && git reset --hard origin/master && git merge --ff-only --no-commit $_CUR_BRANCH'
alias gpush='git fetch origin master && git rebase origin/master && git push origin HEAD'

function anybar { echo -n $1 | nc -4u -w0 localhost ${2:-1738}; }

# cd () { builtin cd "$1"; ls; }

mkcd () {
    mkdir -p "$*"
    cd "$*"
}

SSH_ENV="$HOME/.ssh/environment"
function start_agent() {
  touch $SSH_ENV
  chmod 0600 $SSH_ENV
  /usr/bin/ssh-agent | sed 's/^echo/#echo/' > $SSH_ENV
  . $SSH_ENV > /dev/null
  /usr/bin/ssh-add
}
if [ -f $SSH_ENV ]; then
  . $SSH_ENV > /dev/null
  ps -p $SSH_AGENT_PID > /dev/null || {
    start_agent;
  }
else
  start_agent;
fi

preexec() {
  commandwas="$1"
  commandstarted=`date +%s`
}

precmd() {
  if [ -z ${commandwas+x} ]; then
    return;
  fi

  currenttime=`date +%s`
  elapsed=$((currenttime - commandstarted))
  if (( elapsed < 30 )); then
    return;
  fi

  osascript -e "display notification \"ran in ${elapsed}s: $?\" with title \"$commandwas\""

  unset commandwas
  unset commandstarted
}

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"
