#!/usr/bin/env bash

function clear_bash() {
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

  if [[ -e "$dir_to_clear/.bash_config" ]]; then
    rm -f "$dir_to_clear/.bash_config"
  fi
}

function packup_bash() {
  if [[ $# -ne 2 ]]; then
    error_log "Invalid arguments."
    exit 1
    return
  fi

  local packup_src_dir="$1"
  local packup_dst_dir="$2"

  if [[ -e "$packup_src_dir/.bash_config" ]]; then
    rsync "$packup_src_dir/.bash_config" $packup_dst_dir
  fi
}

function deploy_bash() {
  if [[ $# -ne 2 ]]; then
    error_log "Invalid arguments."
    return
  fi

  local deploy_src_dir="$1"
  local deploy_dst_dir="$2"

  # Bash related
  rsync "$deploy_src_dir/.bash_config" "$deploy_dst_dir"

  custom_bashrc_content="source \$HOME/.bash_config"
  grep -q "^${custom_bashrc_content}$" "$deploy_dst_dir/.bashrc" ||\
    echo "$custom_bashrc_content" >> "$deploy_dst_dir/.bashrc"
}
