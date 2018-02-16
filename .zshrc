## .zshrc
#

## Completion
#
autoload -U compinit
compinit

## Emvironment variable
#
# LANG
#
export LANG=C

case "${OSTYPE}" in
linux*|darwin*)
    LANG=ja_JP.UTF-8
    ;;
esac

case ${UID} in
0)
    LANG=C
    ;;
esac


## Default shell configuration
#
# set prompt
#
case ${UID} in
0)
    PROMPT=$'[%m]%/#> '
    PROMPT2=$'[%m]%_#> '
    SPROMPT=$'[%m]%r is correct ? [n,y,a,e]: '
    ;;
*)
    PROMPT=$'[%m]%/%%> '
    PROMPT2=$'[%m]%_%%> '
    SPROMPT=$'[%m]%r is correct ? [n,y,a,e]: '
    ;;
esac

## Option shell configuration
#
setopt auto_cd              # auto change directory
setopt auto_pushd           # auto directory pushd that you can get dirs list by cd -[tab]
setopt correct              # command correct edition before each completion attempt
setopt list_packed          # compacked complete list display
setopt noautoremoveslash    # no remove postfix slash of command line
setopt nolistbeep           # no beep sound when complete list displayed

## Predict configuration
#
#autoload predict-on
#predict-on

## Keybind configuration
#
# vi like keybind.
#
bindkey -v

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

## Command history configuration
#
HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

## Alias configuration
#
# expand alias before completing
#
setopt complete_aliases     # aliased Ls needs if file/dir completions work

alias j="jobs -l"

case "${OSTYPE}" in
freebsd*|drawin*)
    alias ls="ls -G -w"
    ;;
linux*)
    alias ls="ls --color"
    ;;
esac

alias la="ls -a"
alias lf="ls -F"
alias ll="ls -lAF"
alias vi="${EDITOR}"

## load user .zshrc configuration file
#
[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine
