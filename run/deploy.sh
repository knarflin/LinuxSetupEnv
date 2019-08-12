#!/usr/bin/env bash

# tmux-config
# vimrc + .vim (plugins)
# bashrc
# gitconfig
# ssh config
# util-scripts & binary

# TODO: Restore: Bash modification
# Switch Bash to Zsh

###############################################################################
# Cleanup files from the backup dir
# Globals:
#   None
# Arguments:
#   dir_to_clear: Usually $HOME
# Returns:
#   None
###############################################################################

function clear_files() {

  if [[ $# -ne 1 ]]; then
    error_log "Invalid arguments."
    exit 1
    return 
  fi

  local dir_to_clear="$1"

  if [[ -e $dir_to_clear/.bash_config ]]; then
    grep -v "^source \$HOME/\.bash_config$" $dir_to_clear/.bashrc \
      > $dir_to_clear/.bashrc.tmp
    mv -f $dir_to_clear/.bashrc.tmp $dir_to_clear/.bashrc
  fi

  if [[ -d "$dir_to_clear/.vim" ]]; then
    rm -rf "$dir_to_clear/.vim"
  fi

  if [[ -e "$dir_to_clear/.vimrc" ]]; then 
    rm -f "$dir_to_clear/.vimrc"
  fi

  if [[ -e "$dir_to_clear/.tmux.conf" ]]; then 
    rm -f "$dir_to_clear/.tmux.conf"
  fi

  if [[ -e "$dir_to_clear/.bash_config" ]]; then 
    rm -f "$dir_to_clear/.bash_config"
  fi

  if [[ -e "$dir_to_clear/.gitconfig" ]]; then
    rm -f "$dir_to_clear/.gitconfig"
  fi

  if [[ -e "$dir_to_clear/.ssh/config" ]]; then
    ssh_identities=($(cat $dir_to_clear/.ssh/config | grep IdentityFile |\
      sed 's/\t/ /g' | tr -s ' ' | sed 's/^ //g' | cut -d' ' -f2))

    for ssh_identity in ${ssh_identities[@]}; do
      ssh_identity_realpath=$(eval realpath ${ssh_identity})
      ssh_identity_dirname=$(dirname ${ssh_identity_realpath})

      if [[ ${ssh_identity_dirname} -ef $HOME/.ssh/ ]]; then
        ssh_identity_basename=$(basename ${ssh_identity_realpath})
        rm -f $dir_to_clear/.ssh/${ssh_identity_basename}
        rm -f $dir_to_clear/.ssh/${ssh_identity_basename}.pub
      fi
    done

    rm -f "$dir_to_clear/.ssh/config"
  fi
}


###############################################################################
# Packup Files to Archive
# Globals:
#   None
# Arguments:
#   packup_src_dir: Temp dir storing the contents to be compressed.
#   packup_dst_dir: Usually $HOME
# Returns:
#   None
###############################################################################

function packup_files() {

  if [[ $# -ne 2 ]]; then
    error_log "Invalid arguments."
    exit 1
    return 
  fi

  local packup_src_dir="$1"
  local packup_dst_dir="$2"

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

  if [[ -e "$packup_src_dir/.ssh/config" ]]; then
    mkdir -p "$packup_dst_dotfile_dir/.ssh"
    rsync "$packup_src_dir/.ssh/config" "$packup_dst_dotfile_dir/.ssh/"
  fi
}

###############################################################################
# Deploy Files to Home
# Globals:
#   None
# Arguments:
#   deploy_src_dir: Usually $HOME
#   deploy_dst_dir: Temp dir storing the contents to be compressed.
# Returns:
#   None
###############################################################################

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

  custom_bashrc_content="source \$HOME/.bash_config"
  grep -q "^${custom_bashrc_content}$" "$deploy_dst_dir/.bashrc" ||\
    echo "$custom_bashrc_content" >> "$deploy_dst_dir/.bashrc"

  # Vim related
  rsync "$dotfile_path/.vimrc" "$deploy_dst_dir"
  rsync -a "$dotfile_path/.vim/" "$deploy_dst_dir/.vim/"

  # Tmux related
  rsync "$dotfile_path/.tmux.conf" "$deploy_dst_dir"

  # Git related
  rsync "$dotfile_path/.gitconfig" "$deploy_dst_dir"

  # SSH related
  mkdir -p "$deploy_dst_dir/.ssh/"
  rsync "$dotfile_path/.ssh/config" "$deploy_dst_dir/.ssh/"

  ssh_identities=($(cat $dotfile_path/.ssh/config | grep IdentityFile |\
    sed 's/\t/ /g' | tr -s ' ' | sed 's/^ //g' | cut -d' ' -f2))

  for ssh_identity in ${ssh_identities[@]}; do
    ssh_identity_realpath=$(eval realpath ${ssh_identity})
    ssh_identity_dirname=$(dirname ${ssh_identity_realpath})
    if [[ ${ssh_identity_dirname} -ef $HOME/.ssh/ ]]; then
      ssh_identity_basename=$(basename ${ssh_identity_realpath})
      ssh-keygen -b 2048 -t rsa -f $deploy_dst_dir/.ssh/$ssh_identity_basename -q -N ""
    fi
  done
}
