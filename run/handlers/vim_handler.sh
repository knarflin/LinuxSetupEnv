#!/usr/bin/env bash

function clear_vim() {
  if [[ $# -ne 1 ]]; then
    error_log "Invalid arguments."
    exit 1
    return
  fi
  local dir_to_clear="$1"

  if [[ -d "$dir_to_clear/.vim" ]]; then
    rm -rf "$dir_to_clear/.vim"
  fi

  if [[ -e "$dir_to_clear/.vimrc" ]]; then
    rm -f "$dir_to_clear/.vimrc"
  fi

}

function packup_vim() {
  if [[ $# -ne 2 ]]; then
    error_log "Invalid arguments."
    exit 1
    return
  fi

  local packup_src_dir="$1"
  local packup_dst_dir="$2"

  if [[ -d "$packup_src_dir/.vim" ]]; then
    rsync -a --exclude='*/.git*' "$packup_src_dir/.vim" $packup_dst_dotfile_dir
  fi

  if [[ -e "$packup_src_dir/.vimrc" ]]; then
    rsync "$packup_src_dir/.vimrc" $packup_dst_dotfile_dir
  fi
}

function deploy_vim() {
  if [[ $# -ne 2 ]]; then
    error_log "Invalid arguments."
    return
  fi

  local deploy_src_dir="$1"
  local deploy_dst_dir="$2"

  rsync "$dotfile_path/.vimrc" "$deploy_dst_dir"
  rsync -a "$dotfile_path/.vim/" "$deploy_dst_dir/.vim/"
}
