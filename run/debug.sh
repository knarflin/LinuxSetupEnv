#!/usr/bin/env bash

function stack_trace() {
  local frame=0
  while caller $frame; do
    ((frame++))
  done
}

###############################################################################
# Exit before stack trace
#
# Globals:
#   None
# Arguments:
#   msg:    message to print
# Returns:
#   None
###############################################################################

function error_exit() {
  local msg=$1
  printf "Exit. Error Msg: %s\n" "$msg"
  stack_trace
  exit 1
}

###############################################################################
# Write Error Log
#
# Globals:
#   None
# Arguments:
#   msg:    message to print
# Returns:
#   None
###############################################################################

function error_log {
  if [[ $# -ne 1 ]]; then
    error_exit "Invalid arguments."
  fi

  local msg="$1"
  printf "%s:%s: %s\n" "${BASH_SOURCE[1]}" "${BASH_LINENO[0]}" "$msg"
}


###############################################################################
# Write Log 
#
# Globals:
#   None
# Arguments:
#   msg:    message to print
# Returns:
#   None
###############################################################################

function write_log {
  if [[ $# -ne 1 ]]; then
    error_exit "Invalid arguments."
  fi

  local msg="$1"
  printf "%s:%s: %s\n" "${BASH_SOURCE[1]}" "${BASH_LINENO[0]}" "$msg"
}

###############################################################################
# Write log with time
#
# Globals:
#   None
# Arguments:
#   msg:    message to print
# Returns:
#   None
###############################################################################

function write_log_with_time {
  if [[ $# -ne 1 ]]; then
    error_exit "Invalid arguments."
  fi

  local msg="$1"
  local date_time=$(date "+%F %T")
  printf "%s %s:%s: %s\n" "$date_time" "${BASH_SOURCE[1]}" "${BASH_LINENO[0]}" "$msg"
}
