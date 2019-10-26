#!/usr/bin/env bash

function clear_git() {
  if [[ $# -ne 1 ]]; then
    error_log "Invalid arguments."
    exit 1
    return
  fi
  local dir_to_clear="$1"

  if [[ -e "$dir_to_clear/.gitconfig" ]]; then
    rm -f "$dir_to_clear/.gitconfig"
  fi
}

function packup_git() {
  if [[ $# -ne 2 ]]; then
    error_log "Invalid arguments."
    exit 1
    return
  fi

  local packup_src_dir="$1"
  local packup_dst_dir="$2"

  if [[ -e "$packup_src_dir/.gitconfig" ]]; then
    rsync "$packup_src_dir/.gitconfig" $packup_dst_dotfile_dir
  fi
}

function deploy_git() {
  if [[ $# -ne 2 ]]; then
    error_log "Invalid arguments."
    return
  fi

  local deploy_src_dir="$1"
  local deploy_dst_dir="$2"

  rsync "$dotfile_path/.gitconfig" "$deploy_dst_dir"
}
