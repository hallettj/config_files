# mboeh's zshrc
 
# Where history is stored.
HISTFILE=~/.histfile      
# Up to 2500 lines of history will be stored in a given shell session...
HISTSIZE=2500
# ... and up to 2500 will be saved when the shell exits.
SAVEHIST=2500
# Append new history lines to .histfile when the shell closes (instead of clobbering it).
# A must-have for someone who uses a lot of ZSH sessions (I have 5-10 open at any given time).
setopt appendhistory
# Do not record commands in .histfile if there is a leading space.
setopt hist_ignore_space
# If a command is given several times in succession only record one
# entry in history.
setopt hist_ignore_dups
# Type the name of a directory to cd into it. The laziest option ever.
setopt autocd
# Lets me cd into any directory immediately under the given paths
# without typing the full path.
cdpath=($HOME $HOME/projects)
# Expansions also work if zsh is prompting you, not just on the command line.
setopt prompt_subst
# Turn off irritating/unsightly beeps when expansion fails.
unsetopt beep 
# Turn off extended globbing, which I never use and which makes too many characters magic.
# IMHO, fancy filename selection is a job for find(1).
unsetopt extendedglob
# If an unmatched glob is used, just use it as literal text instead of giving an error.
# Helpful for my lazy fingers considering how often I use scp:
#   scp suchandsuch.host:files/* ./
# gives an error if nomatch is set.
unsetopt nomatch
# Wait until the next prompt is printed to say whether a job is finished.
unsetopt notify
# VIM-style keybindings.
bindkey -v
 
# Color support. Copied from some place. Used for...
autoload colors zsh/terminfo
if [[ "$terminfo[colors]" -ge 8 ]]; then
	colors
fi
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
	(( count = $count + 1 ))
done
PR_NO_COLOR="%{$terminfo[sgr0]%}"
 
# ... this prompt, which gives me a red branch name if I'm in a git directory.
#export PROMPT='[%n@%m:%~] ${PR_RED}$(git current-branch)${PR_NO_COLOR} %# '

# Jesse's colorful, gitful prompt.
function prompt {
    # Displays the current git branch with a space in front of it.  Displays an
    # empty string if not in a git repository.
    function git_branch {
        ref=$(git symbolic-ref HEAD 2> /dev/null) || return 0
        echo " ${ref#refs/heads/}"
    }

    export PROMPT="${PR_GREEN}%n@%m ${PR_BLUE}%2~${PR_CYAN}\$(git_branch) ${PR_BLUE}%(?.:).:() ${PR_NO_COLOR}"
}
prompt
 
# Aliases. This first one is self-evident.
alias ls="ls --color"
alias ack="ack-grep"
alias please="sudo"
alias beep="aplay --quiet /usr/share/sounds/pop.wav"
alias t="todo.sh -d ~/Dropbox/todo/todo.cfg"

# Instructs shell to use todo.sh completions for the command `t`.
compdef _todo.sh t

# I have so many things in ~/bin 
export PATH=$HOME/local/node/bin:$HOME/.rvm/bin:/home/jesse/.cabal/bin:/home/jesse/bin:~/Dropbox/todo:$PATH
# That's right
export EDITOR=vim
# And again
export VISUAL=$EDITOR
# less settings:
#   -i ignore case in search
#   -n suppress line numbering
#   -R permit ANSI sequences (e.g. color)
#   -F quit immediately and just output data if less than one screen
# This means I can pass colordiff output, etc. to less and get proper coloring, and it works 'right'
# if there's no need to paginate. So I can use the same command for a little tweak or a big set of changes.
#export LESS="-i -n -R -F"

# Configuration for SBT, the Scala Simple Build Tool
export SBT_OPTS="-Dfile.encoding=UTF8 -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=512m"

# Ruby settings: this option automatically loads rubygems so that I don't need
# any explicit require lines.
export RUBYOPT='rubygems'

# Run multiple Ruby versions with RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.
#
# Run multiple Node.js versions with nvm
[[ -s "$HOME/.nvm/nvm.sh" ]] && . "$HOME/.nvm/nvm.sh"  # This loads nvm into a shell session.

# Tells zsh where to look for completion scripts.
fpath=(~/.zsh/functions/Completion $fpath)

# Source ~/.zsh/local for configuration specific to this machine.
[[ -s "$HOME/.zsh/local" ]] && source "$HOME/.zsh/local"

## STOP CARING
 
# The following lines were added by compinstall
 
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' '+' '+m:{a-z}={A-Z} m:{a-zA-Z}={A-Za-z}' '+r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl true
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/mboeh/.zshrc'
 
autoload -Uz compinit
compinit
# End of lines added by compinstall
