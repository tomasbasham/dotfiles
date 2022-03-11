#  ---------------------------------------------------------------------------
#
#  Description: This file holds ZSH specific configurations.
#
#  This file is a shell script that ZSH runs whenever it is started
#  interactively.
#
#  For non-login interactive shells (subject to the -norc and -rcfile options):
#    On starting up:
#      If `~/.zshrc' exists, then source it.
#
#  Sections:
#  1.   Shell completion
#  2.   Prompt
#  3.   Output stream
#  4.   Shell options
#  5.   SSH
#  6.   Functions
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

# ------------------------
# --- Google Cloud SDK ---
# ------------------------

if [[ -f "$HOME/.google-cloud-sdk/path.zsh.inc" ]]; then
  source "$HOME/.google-cloud-sdk/path.zsh.inc"
fi

# -------------
# --- mcfly ---
# -------------

if [[ -n "$(command -v mcfly)" ]]; then
  eval "$(mcfly init zsh)"
fi

# --------------
# --- nodenv ---
# --------------

function nodenv_init() {
  if [[ -n "$(command -v nodenv)" ]]; then
    eval "$(nodenv init -)"
  fi
}

lazy_load nodenv_init node npm npx yarn

# -------------
# --- pyenv ---
# -------------

function pyenv_init() {
  if [[ -n "$(command -v pyenv)" ]]; then
    eval "$(pyenv init -)"
  fi
}

lazy_load pyenv_init python pip

# -------------
# --- rbenv ---
# -------------

function rbenv_init() {
  if [[ -n "$(command -v rbenv)" ]]; then
    eval "$(rbenv init -)"
  fi
}

lazy_load rbenv_init ruby

# --------------
# --- Prompt ---
# --------------

git_prompt() {
 ref=$(git symbolic-ref HEAD | cut -d'/' -f3)
 echo $ref
}

setopt prompt_subst
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:*' enable git cvs svn
zstyle ':vcs_info:git:*' formats ' (%b)'

vcs_info
PROMPT='%B%n@%m%b:%~${vcs_info_msg_0_}$ '

# ====================
# === Flow control ===
# ====================

stty -ixon
unsetopt flow_control # Allow commands to be parked with ctrl+q

# ===============
# === History ===
# ===============

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

setopt extended_history       # Record timestamp of command in HISTFILE
setopt hist_expire_dups_first # Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # Ignore duplicated commands history list
setopt hist_ignore_space      # Ignore commands that start with space
setopt hist_find_no_dups      # Ignore duplicated commands when searching
setopt hist_reduce_blanks     # Remove whitespace from commands before adding to history
setopt hist_verify            # Show command with history expansion to user before running it
# setopt share_history          # Share command history data

# Cycle through history with the up and down arrow keys.
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# =================
# === Directory ===
# =================

setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus
setopt auto_cd

# ================
# === Commands ===
# ================

# Allow long commands to be editied with ctrl+x+e
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# this would normally be done by oh-my-zsh but even if was installed, some apps
# still need it again
autoload -Uz compinit && compinit -i

# highlight current completion option
zstyle ':completion:*' menu select

# use the same colors for completion as ls
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Still use emacs-style zsh bindings.
# This is preventing McFly from working inside of tmux
# bindkey -e

# emacs-style zsh bindings
bindkey "^A"    beginning-of-line
bindkey "^E"    end-of-line

# other bindings
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[5~" beginning-of-history
bindkey "^[[6~" end-of-history
bindkey "^[[3~" delete-char
bindkey "e[2~"  quoted-insert
bindkey "e[5C"  forward-word
bindkey "eOc"   emacs-forward-word
bindkey "e[5D"  backward-word
bindkey "eOd"   emacs-backward-word
bindkey "ee[C"  forward-word
bindkey "ee[D"  backward-word
bindkey "^H"    backward-delete-word

# for rxvt
bindkey "e[8~"  end-of-line
bindkey "e[7~"  beginning-of-line

# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "eOH"   beginning-of-line
bindkey "eOF"   end-of-line

# for freebsd console
bindkey "e[H"   beginning-of-line
bindkey "e[F"   end-of-line

# completion in the middle of a line
bindkey '^i'    expand-or-complete-prefix

[[ -f "${HOME}/.zshrc.after" ]] && source ${HOME}/.zshrc.after
