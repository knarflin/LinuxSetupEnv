#!/usr/bin/env bash

function stack_trace() {
  local frame=0
  while caller $frame; do
  ((frame++));
  done
  echo "$*"
  exit 1
}

function error_log {
  write_log $@
}

#######################################
# Write Log 
#
# Globals:
#   None
# Arguments:
#   source: source filename, better use ${BASH_SOURCE[0]}
#   lineno: source line number, better use ${BASH_LINENO[0]}
#   msg:    message to print
# Returns:
#   None
#######################################

function write_log {
  if [[ $# -ne 1 ]]; then
    printf "%s:%s: %s\n" "${BASH_SOURCE[0]}" "${BASH_LINENO[0]}" "Not enough arguments."
    stack_trace
    exit 1
  fi

  local msg="$1"
  printf "%s\n" "${msg}"

  stack_trace
}

function write_log_with_time {
  local lineno=$1
  local msg=$2
  local date_time=$(date "+%F %T")
  echo "$date_time $(basename "$0"):$lineno: $msg"
}


# TODO: Remove
# write_log $LINENO "Blah Blah Blah" # $LINENO 就是 Bash scritp 該行的行
