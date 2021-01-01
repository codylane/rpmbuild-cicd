# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH

[ -f ~/.aliases ]     && . ~/.aliases
[ -f ~/.bash_prompt ] && . ~/.bash_prompt
