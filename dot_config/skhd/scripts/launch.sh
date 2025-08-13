#!/bin/bash

# This script launches an application defined in the user's actions.conf file.
# It sources the configuration, then evaluates and executes the command
# stored in the variable whose name is passed as the first argument ($1).

CONFIG_FILE="$HOME/.config/skhd/actions.conf"

if [[ -f "$CONFIG_FILE" ]]; then
  source "$CONFIG_FILE"
  
  # Check if the variable name passed as an argument exists in the config
  if [[ -n "${!1}" ]]; then
    # ${!1} is an indirect expansion: it gets the value of the variable
    # whose name is stored in $1. We use `eval` to correctly handle
    # commands that contain spaces or quotes.
    eval "${!1}"
  fi
fi