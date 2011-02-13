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
# Type the name of a directory to cd into it. The laziest option ever.
setopt autocd
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
# Used to get a colorized, pageable diff of the pending deploy.
alias capdiff="cap deploy:pending:diff | ruby -e 'readline; print \$stdin.read' | colordiff | less"
# twyt is a twitter commandline client. These are shorthand for viewing updates or making a tweet.
alias twit="twyt friendstl"
alias twoot="twyt tweet"
# I have so many things in ~/bin 
export PATH=$PATH:/home/jesse/bin:/opt/ruby/bin:/var/lib/gems/1.8/bin
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

# Ruby settings: this option automatically loads rubygems so that I don't need
# any explicit require lines.
export RUBYOPT='rubygems'
 
# I keep my projects under ~/projects; this allows me to type `cdp foo' and end up in ~/projects/foobar.
function cdp {
  cd $(find ~/projects -maxdepth 2 -type d -iname "$1*" -and -not -iname '*.*' | head -n 1)
}
 
# Transferred machines recently. I'm moving over projects if and when I need to work on them.
function revivify {
  for proj in $@; do
    rsync -rP mboeh@oldorz:projects/$proj/ ~/projects/$proj/
  done
}

# Run multiple Ruby versions with RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

# Tells zsh where to look for completion scripts.
fpath=(~/.zsh/Completion $fpath)

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
