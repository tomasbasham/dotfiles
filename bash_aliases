# vim: set ft=sh:

#  ---------------------------------------------------------------------------
#
#  Description: This file holds all my BASH specific aliases
#
#  Sections:
#  1.   Logging
#  2.   Network
#  3.   Disk usage
#  4.   File and directory management
#  5.   System and administration
#
#  ---------------------------------------------------------------------------

# I will forget everything in this file (likely this too)
alias aliases='cat $HOME/.bash_aliases'

# Monitor logs
alias syslog='sudo tail -100f /var/log/syslog'
alias messages='sudo tail -100f /var/log/messages'

# Network
alias findpi='arp -na | grep -i b8:27:eb'
alias gateway='route get default | grep gateway | cut -d ":" -f2 | xargs echo'
alias google='dig +short www.google.com'
alias en0='ifconfig en0 | grep inet | cut -d " " -f2'
alias mac='ifconfig en0 | grep ether | cut -d " " -f2'
alias ping='ping -c 4'
alias quartz='socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" & >/dev/null 2>&1'
alias wget='wget -c'
alias whatsmyip='dig +short myip.opendns.com @resolver1.opendns.com'

# Disk usage in human terms
alias df='df -h'
alias du='du -hcs'

# Alter the ls command
alias ll='ls -l'
alias la='ls -la'
alias lm='ls -la | more'
alias lsd='ls -d */'

# Directory creation
alias mkdir='mkdir -pv'

# Directory jumping
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'
alias .......='cd ../../../../../../'
alias cd..='cd ../' # The number of times I have done this!!!!

# Directory stack manipulation
alias flipd='pushd'
alias rotd='pushd +1'
alias printd='dirs'

# Save current directory for lastd on exit if not $HOME
alias saved='[[ "$(pwd)" != "${HOME}" ]] && echo $(pwd) > ~/.lastdir'

# Project Folder
alias cwd='printf "%q\n" "${PWD##*/}"'

# System
alias add-ssh='ssh-add `grep -RnlE1 "BEGIN.+PRIVATE KEY" $HOME/.ssh`'
alias agent-extra-socket='gpgconf --list-dirs agent-extra-socket'
alias cls="clear && printf '\e[3J'"
alias escape='sed '"'"'s/ /\\ /g'"'"'' # find . -path ./Library -prune -o -print | grep ".DS_Store" | escape | xargs rm -vr
alias path='tr ":" "\n" <<< "$PATH"'
alias rmrf='rm -rf'
alias utcnow='date -u +%FT%TZ'

# Become system administrator
alias god='sudo -Ei'
alias root='god'

# Because less is more and more is less
alias more='less'

# CMake
alias uninstall='cat install_manifest.txt | sudo xargs rm'

# https://xkcd.com/149/
alias make_me_a_sandwich='echo "What? Make it yourself"'
alias sudo_make_me_a_sandwich='echo "ok"'

# http://xkcd.com/1168/
alias archive='tar -cvzf'
alias extract='tar -xvzf'

# Haskell
alias haskell='ghci'

# macOS specific aliases
if [[ "${OSTYPE}" =~ "darwin" ]]; then
  alias empty-trash='rmrf ~/.Trash/*'
  alias flushdns='dscacheutil -flushcache'

  # Clear Google Chrome autofill data ONLY. The Chrome process must not be
  # running.
  alias clear-autofill='sqlite3 ~/Library/Application\ Support/Google/Chrome/Default/Web\ Data "DELETE FROM autofill;"'

  # Can also use Cmd-Ctrl-q
  alias lockscreen='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'
fi
