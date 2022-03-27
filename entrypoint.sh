#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0

if [ -f "$CONFIG_FILE" ]; then
    echo -e "Using configuration file: $CONFIG_FILE"
    fd -e md -x /usr/app/link-check-action --config "$CONFIG_FILE" {} \; 2> errors.txt
else 
    echo -e "Checking without any configuration file."
    fd -e md -x /usr/app/link-check-action {} \; 2> errors.txt
fi

exit_code=0

if [ -s errors.txt ] ; then
  echo -e "At least one broken link was found."
  exit_code=1
else
  echo -e "No broken links found."
  if [ -e errors.txt ] ; then
    rm errors.txt
  fi
fi

echo ::set-output name=exit_code::$exit_code
