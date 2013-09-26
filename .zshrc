# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="sunrise"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(cabal colored-man git mvn nvm rvm tmux vi-mode)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

# Lets me cd into any directory immediately under the given paths
# without typing the full path.
cdpath=($HOME $HOME/projects .)
# If an unmatched glob is used, just use it as literal text instead of giving an error.
# Helpful for my lazy fingers considering how often I use scp:
#   scp suchandsuch.host:files/* ./
# gives an error if nomatch is set.
unsetopt nomatch
# Wait until the next prompt is printed to say whether a job is finished.
unsetopt notify

# Exporting options for less breaks `git diff`.  Not sure why.
unset LESS

# Use Solarized theme colors for directory listings
[[ -s "$HOME/.dircolors" ]] && eval `dircolors "$HOME/.dircolors"`

# Customizes terminal titles
ZSH_THEME_TERM_TAB_TITLE_IDLE="%1~" #Just the name of the working directory

# Prompt customizations
ZSH_THEME_GIT_PROMPT_UNTRACKED=""

# Right-prompt customizations
local return_code="%(?..%{$R%}%? ↵%{$RESET%})"
function custom_vi_mode_prompt_info() {
  # Displays indicator when in insert mode or non-zero exit status
  echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/$return_code}"
}
RPS1='$(custom_vi_mode_prompt_info)'

# Aliases
alias ack="ack-grep"
alias beep="aplay --quiet /usr/share/sounds/pop.wav"
alias t="todo.sh -d ~/Dropbox/todo/todo.cfg"

# Instructs shell to use todo.sh completions for the command `t`.
compdef _todo.sh t

# I have so many things in ~/bin 
export PATH=/home/jesse/.cabal/bin:/home/jesse/bin:~/Dropbox/todo:$PATH
# That's right
export EDITOR=vim
# And again
export VISUAL=$EDITOR

# Configuration for SBT, the Scala Simple Build Tool
export SBT_OPTS="-Dfile.encoding=UTF8 -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=512m"

# Ruby settings: this option automatically loads rubygems so that I don't need
# any explicit require lines.
export RUBYOPT='rubygems'

# Run multiple Ruby versions with RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

# Tells zsh where to look for completion scripts.
fpath=(~/.zsh/functions/Completion $fpath)

# Source ~/.zsh/local for configuration specific to this machine.
[[ -s "$HOME/.zsh/local" ]] && source "$HOME/.zsh/local"
