#!/usr/bin/env bash
#
# packup
# deploy
# clear
#
# tmux-config
# vimrc + plugins
# bashrc
# gitconfig
# ssh config
# util-scripts & binary
#
# OS packages
# python packages
#

function print_usage() {
  script_name="$(basename $0)"
  echo "Usage:"
  echo ""
  echo "  $script_name [option]"
  echo ""
  echo " -p [packup.tar]: Packup files"
  echo " -d [deploy.tar]: Deploy files"
  echo " -c             : Clean files"
}

function install_packages() {
  local support_yum=false
  local support_apt=false
  local support_dnf=false

  if [[ -x $(command -v yum) ]]; then
    support_yum=true
  fi

  if [[ -x $(command -v apt) ]]; then
    support_apt=true
  fi

  if [[ -x $(command -v dnf) ]]; then
    support_dnf=true
  fi

  if [[ "$support_yum" = true ]]; then
    echo "Run Yum Install"
  fi

  if [[ "$support_apt" = true ]]; then
    echo "Run Apt Install"
  fi

  if [[ "$support_dnf" = true ]]; then
    echo "Run Dnf Install"
  fi
}

function main() {
  if [[ $# -lt 1 ]]; then
    print_usage
    exit 1
  fi

  case "$1" in
    -p)
      if [[ $# -ne 2 ]]; then
        print_usage
        exit 1
      fi

      local packup_archive="$2"
      local temp_store_dir="${packup_archive}.tmp"

      local packup_src_dir="$HOME"
      local packup_dst_dir="$ROOT_PATH/$temp_store_dir"

      echo packup files to $packup_archive

      mkdir -p $packup_dst_dir
      packup_files $packup_src_dir $packup_dst_dir

      # Compress Files to Archive
      tar -C $(dirname "$packup_dst_dir") -cf "$packup_archive" \
        "$(basename $packup_dst_dir)"
      rm -rf "$packup_dst_dir"
      ;;
    -d)
      if [[ $# -ne 2 ]]; then
        print_usage
        exit 1
      fi

      echo deploy_files
      local deploy_archive=$2

      tar -xf $deploy_archive -C "$ROOT_PATH"

      local deploy_archive_basename=$(basename $deploy_archive)
      local deploy_src_dir="$ROOT_PATH/${deploy_archive_basename}.tmp"
      local deploy_dst_dir="$HOME"
      deploy_files $deploy_src_dir $deploy_dst_dir
      rm -rf "$packup_src_dir"
      ;;
    -i)
      # Call install_packages
      install_packages
      ;;
    -c)
      local dir_to_clear="$HOME"
      clear_files $dir_to_clear
      ;;
    *)
      print_usage
      exit 1
      ;;
  esac
}

# Script Preparation and Starts

ROOT_PATH="$(dirname "$( readlink -f "${BASH_SOURCE[0]}" )")"
echo ROOT_PATH = $ROOT_PATH

#
# Source debug-related functions so all scripts can use it.
#
source $ROOT_PATH/run/debug.sh

#
# Source deploy-related functions
#
source $ROOT_PATH/run/deploy.sh

main $@
