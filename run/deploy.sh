#!/usr/bin/env bash

#######################################
# Cleanup files from the backup dir
# Globals:
#   None
# Arguments:
#   dir_to_clear: Usually $HOME
# Returns:
#   None
#######################################

function clear_files() {

  if [[ $# -ne 1 ]]; then
    error_log "Invalid arguments."
    exit 1
    return 
  fi

  local dir_to_clear="$1"

  if [[ -e $dir_to_clear/.bash_config ]]; then
    grep -v "^source \.bash_config$" $dir_to_clear/.bashrc > $dir_to_clear/.bashrc.tmp
    mv -f $dir_to_clear/.bashrc.tmp $dir_to_clear/.bashrc
  fi

  if [[ -d "$dir_to_clear/.vim" ]]; then
    rm -rf "$dir_to_clear/.vim"
  fi

  if [[ -e "$dir_to_clear/.vimrc" ]]; then 
    rm "$dir_to_clear/.vimrc"
  fi

  if [[ -e "$dir_to_clear/.tmux.conf" ]]; then 
    rm "$dir_to_clear/.tmux.conf"
  fi

  if [[ -e "$dir_to_clear/.bash_config" ]]; then 
    rm "$dir_to_clear/.bash_config"
  fi

  if [[ -e "$dir_to_clear/.gitconfig" ]]; then
    rm "$dir_to_clear/.gitconfig"
  fi
}


#######################################
# Packup Files to Archive
# Globals:
#   None
# Arguments:
#   packup_src_dir: Temp dir storing the contents to be compressed.
#   packup_dst_dir: Usually $HOME
# Returns:
#   None
#######################################

function packup_files() {

  if [[ $# -ne 2 ]]; then
    error_log "Invalid arguments."
    exit 1
    return 
  fi

  local packup_src_dir="$1"
  local packup_dst_dir="$2"

  echo packup_src_dir = "$packup_src_dir"
  echo packup_dst_dir = "$packup_dst_dir"

  local packup_dst_dotfile_dir="$packup_dst_dir/dotfile"
  mkdir -p $packup_dst_dotfile_dir

  # TODO: Make this a for-in loop

  if [[ -d "$packup_src_dir/.vim" ]]; then
    rsync -a --exclude='*/.git*' "$packup_src_dir/.vim" $packup_dst_dotfile_dir
  fi

  if [[ -e "$packup_src_dir/.vimrc" ]]; then 
    rsync "$packup_src_dir/.vimrc" $packup_dst_dotfile_dir
  fi

  if [[ -e "$packup_src_dir/.tmux.conf" ]]; then 
    rsync "$packup_src_dir/.tmux.conf" $packup_dst_dotfile_dir
  fi

  if [[ -e "$packup_src_dir/.bash_config" ]]; then 
    rsync "$packup_src_dir/.bash_config" $packup_dst_dotfile_dir
  fi

  if [[ -e "$packup_src_dir/.gitconfig" ]]; then
    rsync "$packup_src_dir/.gitconfig" $packup_dst_dotfile_dir
  fi
}

#######################################
# Deploy Files to Home
# Globals:
#   None
# Arguments:
#   deploy_src_dir: Usually $HOME
#   deploy_dst_dir: Temp dir storing the contents to be compressed.
# Returns:
#   None
#######################################

function deploy_files() {

  if [[ $# -ne 2 ]]; then
    error_log "Invalid arguments."
    return 
  fi

  local deploy_src_dir="$1"
  local deploy_dst_dir="$2"

  local utils_path="$deploy_src_dir/utils"
  local dotfile_path="$deploy_src_dir/dotfile"

  # Bash related
  rsync "$dotfile_path/.bash_config" "$deploy_dst_dir"

  custom_bashrc_content="source .bash_config"
  grep -q "^${custom_bashrc_content}$" "$deploy_dst_dir/.bashrc" || \
    echo "$custom_bashrc_content" >> "$deploy_dst_dir/.bashrc"

  # Vim related
  rsync "$dotfile_path/.vimrc" "$deploy_dst_dir"
  rsync -a "$dotfile_path/.vim/" "$deploy_dst_dir/.vim/"

  # Tmux related
  rsync "$dotfile_path/.tmux.conf" "$deploy_dst_dir"

  # Git related
  rsync "$dotfile_path/.gitconfig" "$deploy_dst_dir"

  # TODO: Remove
  echo "$deploy_src_dir"
  echo "$deploy_dst_dir"
  echo "$dotfile_path"
  echo "$utils_path"
}

# tmux-config
# vimrc + .vim (plugins)
# bashrc
# gitconfig
# ssh config
# util-scripts & binary

# TODO: Restore: Bash modification
# Switch Bash to Zsh
