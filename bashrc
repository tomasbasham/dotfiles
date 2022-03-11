#  ---------------------------------------------------------------------------
#
#  Description: This file holds Bash specific configurations.
#
#  This file is a shell script that Bash runs whenever it is started
#  interactively.
#
#  For non-login interactive shells (subject to the -norc and -rcfile options):
#    On starting up:
#      If `~/.bashrc' exists, then source it.
#
#  Sections:
#  1.   Bash completion
#  2.   Prompt
#  3.   Output stream
#  4.   Shell options
#
#  ---------------------------------------------------------------------------

[[ -f "/etc/bash_completion" ]] && source /etc/bash_completion
[[ -f "/usr/local/etc/bash_completion" ]] && source /usr/local/etc/bash_completion
[[ -f "/usr/local/etc/profile.d/bash_completion.sh" ]] && source /usr/local/etc/profile.d/bash_completion.sh

# ==============
# === Prompt ===
# ==============

# http://stackoverflow.com/a/5947802
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

# Set the PS1 prompt (with colours)
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " (%s)")\$ '

parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

parse_git_tracking() {
  echo ""
}

# =====================
# === Output Stream ===
# =====================

# Prevent CTRL-S from suspending the output stream
stty stop '' -ixoff

# Prevent CTRL-Q from waking up the output stream
stty start '' -ixon

# =====================
# === Shell Options ===
# =====================

shopt -s histappend   # Append commands to the bash command history file (~./bash_history) instead of overriding it
shopt -s cdspell      # Autocorrect typos in path names when using `cd`
shopt -s checkwinsize # Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s extglob      # Enable detection of inverse, like !(b*)

# If set, the pattern "**" used in a pathname expansion context will match all
# files and zero or more directories and subdirectories.
if [[ ! "${OSTYPE}" =~ "darwin" ]]; then
  shopt -s globstar
fi

# Only complete directories for 'cd`, http://unix.stackexchange.com/a/186425
complete -d cd

[[ -f "${HOME}/.bashrc.after" ]] && source ${HOME}/.bashrc.after
