#!/usr/bin/env bash

function clear_zsh() {
  if [[ $# -ne 1 ]]; then
    error_log "Invalid arguments."
    exit 1
    return
  fi
  local dir_to_clear="$1"

  if [[ -e "$dir_to_clear/.zshrc" ]]; then
    rm -f "$dir_to_clear/.zshrc"
  fi
}

function packup_zsh() {
  if [[ $# -ne 2 ]]; then
    error_log "Invalid arguments."
    exit 1
    return
  fi

  local packup_src_dir="$1"
  local packup_dst_dir="$2"

  if [[ -e "$packup_src_dir/.zshrc" ]]; then
    rsync "$packup_src_dir/.zshrc" $packup_dst_dotfile_dir
  fi
}

function deploy_zsh() {
  if [[ $# -ne 2 ]]; then
    error_log "Invalid arguments."
    return
  fi

  local deploy_src_dir="$1"
  local deploy_dst_dir="$2"

  # Tmux related
  rsync "$dotfile_path/.zshrc" "$deploy_dst_dir"
}
