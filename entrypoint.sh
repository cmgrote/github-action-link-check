#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0

if [ -f "$CONFIG_FILE" ]; then
    echo -e "Using configuration file: $CONFIG_FILE"
    fd -e md -x /link-check-action --config "$CONFIG_FILE" {} \; 2> errors.txt
else 
    echo -e "Checking without any configuration file."
    fd -e md -x /link-check-action {} \; 2> errors.txt
fi

if [ -e errors.txt ] ; then
  exit 113
else
  echo -e "No broken links found."
fi
