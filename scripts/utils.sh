backup_and_symlink() {
  # Remove trailing slashes.
  local target_path="$(echo "${1%/}")"
  local dest_path="$(echo "${2%/}")"

  local base_dir="$(dirname "$dest_path")"
  local timestamp="$(date -u +"%Y%m%dT%H%M%SZ")"

  # If the destination exists and it's not a symlink, make a backup first.
  if [[ -e "${dest_path}" && ! -L "${dest_path}" ]]; then
    printf "backup: "
    mv -v "${dest_path}" "${dest_path}.${timestamp}.bkp"
  fi

  # If the destination dir does not exist, create it.
  if [[ ! -d "${base_dir}" ]]; then
    printf "create dir: "
    mkdir -vp "${base_dir}"
  fi

  printf "symlink: "
  ln -sfnv "${target_path}" "${dest_path}"
}

download() {
  __download_src=$1
  __download_dst=$2

  if which curl >/dev/null; then
    curl -sSL -f "$__download_src" > "$__download_dst"
  elif which wget >/dev/null; then
    wget s -O - "$__download_src" > "$__download_dst"
  else
    echo "either curl or wget must be installed to download files." >&2
    return 1
  fi
}
