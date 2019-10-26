#!/usr/bin/env bash

function clear_ssh() {
  if [[ $# -ne 1 ]]; then
    error_log "Invalid arguments."
    exit 1
    return
  fi
  local dir_to_clear="$1"

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

function packup_ssh() {
  if [[ $# -ne 2 ]]; then
    error_log "Invalid arguments."
    exit 1
    return
  fi

  local packup_src_dir="$1"
  local packup_dst_dir="$2"

  if [[ -e "$packup_src_dir/.ssh/config" ]]; then
    mkdir -p "$packup_dst_dotfile_dir/.ssh"
    rsync "$packup_src_dir/.ssh/config" "$packup_dst_dotfile_dir/.ssh/"
  fi
}

function deploy_ssh() {
  if [[ $# -ne 2 ]]; then
    error_log "Invalid arguments."
    return
  fi

  local deploy_src_dir="$1"
  local deploy_dst_dir="$2"

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
