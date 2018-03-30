## .zshrc
#

## Completion
#
autoload -U compinit
compinit

autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload -Uz is-at-least
autoload -Uz colors
colors

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
PROMPT=$'[%m]%/%#> '
PROMPT2=$'[%m]%_%#> '
SPROMPT=$'[%m}%r is correct ? [n,y,a,e]: '
RPROMPT=""

## Option shell configuration
#
setopt auto_cd              # auto change directory
setopt auto_pushd           # auto directory pushd that you can get dirs list by cd -[tab]
setopt correct              # command correct edition before each completion attempt
setopt list_packed          # compacked complete list display
setopt noautoremoveslash    # no remove postfix slash of command line
setopt nolistbeep           # no beep sound when complete list displayed
setopt prompt_subst

## Default vcs_info configuration
#
zstyle ':vcs_info:*' max-exports 3
zstyle ':vcs_info:*' enable git

zstyle ':vcs_info:*' formats '[%b]'
zstyle ':vcs_info:*' actionformats '[%b]' '%m' '<!%a>'

## zsh ver 4.3.10
#

if is-at-least 4.3.10; then
    zstyle ':vcs_info:git:*' formats '[%b]' '%c%u %m'
    zstyle ':vcs_info:git:*' actionformats '[%b]' '%c%u %m' '<!%a>'
    zstyle ':vcs_info:git:*' check-for-changes true
    zstyle ':vcs_info:git:*' stagedstr "%F{green}+%f%F{yellow}"
    zstyle ':vcs_info:git:*' unstagedstr "%F{red}-%f%F{yellow}"
fi

## zsh ver 4.3.11
#

if is-at-least 4.3.11; then
    zstyle ':vcs_info:git+set-message:*' hooks git-hook-begin git-untracked git-push-status git-nomerge-branch git-nomerge-master git-stash-count

    function +vi-git-hook-begin() {
        if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
            return 1
        fi

        return 0
    }

    function +vi-git-untracked() {
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        if command git status --porcelain 2> /dev/null | awk '{print $1}' | command grep -F '??' > /dev/null 2>&1 ; then
            hook_com[unstaged]+='?'
        fi
    }

    function +vi-git-push-status() {
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        local ahead
        ahead=$(command git rev-list origin/${hook_com[branch]}..${hook_com[branch]} 2> /dev/null | wc -l | tr -d ' ')

        if [[ "$ahead" -gt 0 ]]; then
            hook_com[misc]+="(p${ahead})"
        fi
    }

    function +vi-git-nomerge-branch() {
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        if [[ "${hook_com[branch]}" == "master" ]]; then
            return 0
        fi

        local nomerged
        nomerged=$(command git rev-list master..${hook_com[branch]} 2> /dev/null | wc -l | tr -d ' ')

        if [[ "$nomerged" -gt 0 ]]; then
            hook_com[misc]+="(m${nomerged})"
        fi
    }

    function +vi-git-nomerge-master() {
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        if [[ "${hook_com[branch]}" == "master" ]]; then
            return 0
        fi

        if command git branch --no-merged 2> /dev/null | command grep 'master' > /dev/null 2>&1 ; then
            hook_com[misc]+="(R)"
        fi
    }

    function +vi-git-stash-count() {
        if [[ "$1" != "1" ]]; then
            return 0
        fi

        local stash
        stash=$(command git stash list 2> /dev/null | wc -l | tr -d ' ')

        if [[ "${stash}" -gt 0 ]]; then
            hook_com[misc]+=":S${stash}"
        fi
    }
fi

function _update_vcs_info_msg() {
    local -a messages
    local prompt

    vcs_info

    if [[ -z ${vcs_info_msg_0_} ]]; then
        prompt=""
    else
        [[ -n "$vcs_info_msg_0_" ]] && messages+=( "%F{cyan}${vcs_info_msg_0_}%f" )
        [[ -n "$vcs_info_msg_1_" ]] && messages+=( "%F{yellow}${vcs_info_msg_1_}%f" )
        [[ -n "$vcs_info_msg_2_" ]] && messages+=( "%F{red}${vcs_info_msg_2_}%f" )

        prompt="${(j: :)messages}"
    fi

    RPROMPT="$prompt"
}

add-zsh-hook precmd _update_vcs_info_msg


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
