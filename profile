#  ---------------------------------------------------------------------------
#
#  Description: This file holds all my shell agnostic configurations,
#
#  These configurations should work across every shell implementation and
#  are thus reusable.
#
#  Make sure to source this file within specific shell configurations. For
#  example to include within a BASH environment place the following within
#  the .bash_profile file:
#
#  [[ -e "${HOME}/.profile" ]] && source ${HOME}/.profile
#
#  Sections:
#  1.   Exports
#  2.   Tmux
#  3.   local
#  4.   Go
#  5.   NVM
#  6.   pyenv
#  7.   rbenv
#  8.   swiftenv
#  9.   virtualenv
#  10.  load last saved directory
#
#  ---------------------------------------------------------------------------

# Tell my terminal to be colourful
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Set the default editor to vim
export EDITOR=vim

# Tell grep to highlight matches
export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;33'

# Tell gpg to use the terminal to prompt for password
export GPG_TTY=$(tty)

# If using X11 forwarding this acts as the DISPLAY to use
export XHOST=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
export XDISPLAY=${XHOST}:0

# Minikube
export MINIKUBE_HOME=$HOME
export CHANGE_MINIKUBE_NONE_USER=true

# libssl on macOS is a pain in the ass. When compiling Ruby use this directory
# to locate the SSL library files if present on the system.
if [ -d "/usr/local/ssl" ]; then
  RUBY_CONFIGURE_OPTS=-with-openssl-dir=/usr/local/ssl
fi

# ------------
# --- Tmux ---
# ------------

# Ensures the correct TERM value inside tmux.
# Requires to also set the following in tmux.conf:
#
#   # ~/.tmux.conf
#   set -g default-terminal "screen-256color"
#
if [ -n "$TMUX" ]; then
  export TERM=screen-256color
else
  export TERM=xterm-256color
fi

# -----------
# --- GPG ---
# -----------

export GPG_TTY=$(tty)

# This create-socketdir command is only required if a non default home
# directory is used and the /run based sockets shall be used. For the default
# home directory GnUPG creates a directory on the fly.
if [[ ! -d $HOME/.gnupg && ( -d /run/user || -d /var/run/user ) ]]; then
  gpgconf --create-socketdir
fi

# -------------
# --- local ---
# -------------

if [ -d "$HOME/.local/bin" ]; then
  export PATH="$PATH:$HOME/.local/bin"
fi

# ----------
# --- Go ---
# ----------

if [ -d "$HOME/go" ]; then
  export GOPATH="$HOME/go"
  export PATH="/usr/local/go/bin:$PATH:$GOPATH/bin"
fi

# -----------
# --- nvm ---
# -----------

# Add NVM to PATH for scripting
if [ -d "$HOME/.nvm" ]; then
  export PATH="$PATH:$HOME/.nvm/"
fi

# -------------
# --- pyenv ---
# -------------

# Add pyenv to PATH for scripting
if [ -d "$HOME/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
fi

# -------------
# --- rbenv ---
# -------------

# Add rbenv to PATH for scripting
if [ -d "$HOME/.rbenv" ]; then
  export PATH="$PATH:$HOME/.rbenv/bin"
fi

# ------------
# --- Rust ---
# ------------

if [ -d "$HOME/.cargo/bin" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# -----------------
# --- Directory ---
# -----------------

if [ -f "${HOME}/.lastdir" ]; then
  cd $(head -n 1 ${HOME}/.lastdir)
  rm ${HOME}/.lastdir
fi

# When using tmux, a nested interactive subshell is spawned. That means that
# .bashrc gets sourced again, and the same paths get added to the already
# prepared PATH. This is super annoying. The below removed duplicates from the
# PATH.
PATH=$(printf "%s" "$PATH" | awk -v RS=':' '!a[$1]++ { if (NR > 1) printf RS; printf $1 }')

[ -f "${HOME}/.profile.after" ] && source ${HOME}/.profile.after
