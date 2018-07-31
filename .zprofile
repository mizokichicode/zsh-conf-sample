## .zprofile
#

## path
#
typeset -U path
path=($path /sbin(N-/) /bin(N-/) /usr/sbin(N-/) /usr/bin(N-/) /usr/*/bin(N-/) /usr/local/bin(N-/) /usr/local/*/bin(N-/))

## Environment variable
#
# EDITOR
#
export EDITOR=vim
