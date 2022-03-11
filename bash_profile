#  ---------------------------------------------------------------------------
#
#  Description: This file holds Bash specific configurations.
#
#  This file is a shell script that Bash runs upon login. For
#  complete compatibility this file also includes the .profile
#  script to set non Bash specfic variables.
#
#  A full list of Bash specific variables can be found at:
#  https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html
#
#  For Login shells (subject to the -noprofile option):
#
#  On logging in:
#    If `/etc/profile' exists, then source it.
#
#    If `~/.bash_profile' exists, then source it,
#      else if `~/.bash_login' exists, then source it,
#        else if `~/.profile' exists, then source it.
#
#  On logging out:
#    If `~/.bash_logout' exists, source it.
#
#  This file also imports the .basrc file, if it exists, which
#  further sets Bash specific options for interactive shell sessions.
#
#  Sections:
#  1.   SSH escape sequences
#  2.   History
#  3.   Google Cloud SDK
#  4.   nodenv
#  5.   pyenv
#  6.   rbenv
#
#  ---------------------------------------------------------------------------

[[ -f "${HOME}/.profile" ]] && source ${HOME}/.profile

# Supported escape sequences for SSH sessions:
#  ~.   - terminate connection (and any multiplexed sessions)
#  ~B   - send a BREAK to the remote system
#  ~C   - open a command line
#  ~R   - request rekey (SSH protocol 2 only)
#  ~V/v - decrease/increase verbosity (LogLevel)
#  ~^Z  - suspend ssh
#  ~#   - list forwarded connections
#  ~&   - background ssh (when waiting for connections to terminate)
#  ~?   - help (this) message
#  ~~   - send the escape character by typing it twice
# (Note that escapes are only recognized immediately after newline.)

# ---------------
# --- History ---
# ---------------

# Stop bash from caching duplicate lines or lines starting with space
# HISTCONTROL=ignoredups:ignorespace
export HISTCONTROL=ignoreboth

# Extend the maximum number of commands to remember on the history list to 1000
export HISTSIZE=1000

# ------------------------
# --- Google Cloud SDK ---
# ------------------------

if [[ -f "$HOME/.google-cloud-sdk/path.bash.inc" ]]; then
 source "$HOME/.google-cloud-sdk/path.bash.inc"
fi

# -------------
# --- mcfly ---
# -------------

if [[ -n "$(command -v mcfly)" ]]; then
  eval "$(mcfly init bash)"
fi

# --------------
# --- nodenv ---
# --------------

if [[ -n "$(command -v nodenv)" ]]; then
  eval "$(nodenv init -)"
fi

# -------------
# --- pyenv ---
# -------------

if [[ -n "$(command -v pyenv)" ]]; then
  eval "$(pyenv init -)"
fi

# -------------
# --- rbenv ---
# -------------

if [[ -n "$(command -v rbenv)" ]]; then
  eval "$(rbenv init -)"
fi

# Load the bash_profile.after file if it is present.
[[ -f "${HOME}/.bash_profile.after" ]] && source ${HOME}/.bash_profile.after
[[ -f "${HOME}/.bashrc" ]] && source ${HOME}/.bashrc
