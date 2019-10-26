#!/usr/bin/env bash

# Setting Up files below:
#
# .bashrc & .bash_config
# .tmux.conf or maybe .tmux/plugins # TODO
# .vimrc + .vim (plugins)
# .vscode extensions # TODO
# .gitconfig
# .ssh config & pub/pri keys
# .util-scripts & binary # TODO
# apt/yum packages # TODO
# python packages # TODO

# TODO: Consider switching Bash to Zsh?
# TODO: Two function 1 pack to a closenet env 2. pack to a opennet env

source $ROOT_PATH/run/handlers/bash_handler.sh
source $ROOT_PATH/run/handlers/tmux_handler.sh
source $ROOT_PATH/run/handlers/git_handler.sh
source $ROOT_PATH/run/handlers/vim_handler.sh
source $ROOT_PATH/run/handlers/ssh_handler.sh

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

  clear_bash $dir_to_clear
  clear_vim $dir_to_clear
  clear_tmux $dir_to_clear
  clear_git $dir_to_clear
  clear_ssh $dir_to_clear
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

  packup_vim $packup_src_dir $packup_dst_dotfile_dir
  packup_tmux $packup_src_dir $packup_dst_dotfile_dir
  packup_bash $packup_src_dir $packup_dst_dotfile_dir
  packup_git $packup_src_dir $packup_dst_dotfile_dir
  packup_ssh $packup_src_dir $packup_dst_dotfile_dir
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

  deploy_bash $dotfile_path $deploy_dst_dir
  deploy_vim $dotfile_path $deploy_dst_dir
  deploy_tmux $dotfile_path $deploy_dst_dir
  deploy_git $dotfile_path $deploy_dst_dir
  deploy_ssh $dotfile_path $deploy_dst_dir
}
