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
#  5.   SSH
#  6.   Functions
#  7.   Handles
#
#  ---------------------------------------------------------------------------

[[ -f "/etc/bash_completion" ]] && source /etc/bash_completion
[[ -f "/usr/local/etc/bash_completion" ]] && source /usr/local/etc/bash_completion
[[ -f "/usr/local/etc/profile.d/bash_completion.sh" ]] && source /usr/local/etc/profile.d/bash_completion.sh

# --------------
# --- Prompt ---
# --------------

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

# ---------------------
# --- Output Stream ---
# ---------------------

# Prevent CTRL-S from suspending the output stream
stty stop '' -ixoff

# Prevent CTRL-Q from waking up the output stream
stty start '' -ixon

# ---------------------
# --- Shell Options ---
#----------------------

# Append commands to the bash command history file (~./bash_history)
# instead of overriding it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context
# will match all files and zero or more directories and
# subdirectories.
if [[ ! "${OSTYPE}" =~ "darwin" ]]; then
  shopt -s globstar
fi

# Enable detection of inverse, like !(b*)
shopt -s extglob

# Only complete directories for 'cd`, http://unix.stackexchange.com/a/186425
complete -d cd

# -----------------
# --- Functions ---
# -----------------

# Place the local host's public key in the remote host's authorized keys
infect() {
  ssh "$@" "mkdir -p ~/.ssh; echo '$(cat ~/.ssh/id_rsa.pub)' >> ~/.ssh/authorized_keys";
}

# List programs running on a port
pslisten() {
  lsof -Pn -i:$1
}

# curl with authorization header set
curl_secure() {
  if [[ $# -ne 2 ]]; then
    echo "host and token are required"
    exit 1
  fi
  curl $1 -H "Authorization: Bearer $2"
}

# Connect to a remote docker instance
dock() {
  eval $(docker-machine env $1)
}

# Disconnect from a remote docker instance
undock() {
  eval $(docker-machine env -u)
}

# Shrink Docker.qcow2
shrink() {
  docker run --rm -it --privileged --pid=host walkerlee/nsenter -t 1 -m -u -i -n fstrim /var/lib/docker
}

# Convert a gif to mp4
gif2mp4() {
  ffmpeg -i $1 -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" $2
}

# Convert a vid to webm
vid2webm() {
  ffmpeg -i $1 -vcodec libvpx -acodec libvorbis -isync -copyts -aq 80 -threads 3 -qmax 30 -y $2 $1.webm
}

# ---------------
# --- Handles ---
# ---------------

#  ---------------------------------------------------------------------------
#
#  In environments where it may be more suitable to control how much memory
#  is given to specific applications, use Docker. I use this file to
#  magincally invoke a Docker container when the specified command cannot be
#  found on the system, but where there is an image name which statisfies the
#  command name.
#
#  Requires Bash 4+ to use this handle.
#
#  ---------------------------------------------------------------------------

command_not_found_handle() {
  # Check if there is a container image with that name
  if ! docker inspect --format '{{ .Author }}' "$1" >&/dev/null; then
    echo "$0: $1: command not found"
    return
  fi

  # Check that it's really the name of the image, not a prefix
  if docker inspect --format '{{ .Id }}' "$1" | grep -q "^$1" ;then
    echo "$0: $1: command not found"
    return
  fi

  # Add a bunch of (optional) devices
  # (Don't add them unconditionally: if they don't exist, it
  # would prevent the container from starting)
  DEVICES=
  for DEV in /dev/kvm /dev/ttyUSB* /dev/dri/* /dev/snd/*; do
    if [ -b "$DEV" -o -c "$DEV" ]; then
      DEVICES="$DEVICES --device $DEV:$DEV"
    fi
  done

  # And a few (optional) files
  # (Here again, they don't always exist everywhere)
  VOLUMES=
  for VOL in /tmp/.X11-unix /run/user; do
    if [ -e "$VOL" ]; then
      VOLUMES="$VOLUMES --volume $VOL:$VOL"
    fi
  done

  # Map the users home folder as a volume. If using
  # linux the home folder is found under /home,
  # otherwise look in the./Users folder on OS X
  if [ -e "/Users" ]; then
    VOLUMES="$VOLUMES --volume /Users:/home"
  else
    VOLUMES="$VOLUMES --volume /home:/home"
  fi

  # Check if we are on a tty to decide whether to allocate one
  DASHT=
  tty -s && DASHT=-t

  # docker run --rm $DASHT -i -u $(whoami) -w "$HOME" \
  #   $(env | cut -d= -f1 | awk '{print "-e", $1}') \
  #   $DOCKERFILES_RUN_FLAGS $DEVICES $VOLUMES \
  #   -v /etc/passwd:/etc/passwd:ro \
  #   -v /etc/group:/etc/group:ro \
  #   -v /etc/localtime:/etc/localtime:ro \
  #   "$@"

  docker run --rm "$@"
}

[[ -f "${HOME}/.bashrc.after" ]] && source ${HOME}/.bashrc.after
[[ -f "${HOME}/.bash_aliases" ]] && source ${HOME}/.bash_aliases
