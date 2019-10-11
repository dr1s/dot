#!/bin/bash

#export PATH=/usr/local/bin:$PATH

# skhd saves the current keyboard mode to this file
modefile=/tmp/current_skhd_mode
if [[ -r $modefile ]]; then
  mod="$(cat "$modefile")"
  if [[ -n $mod ]]; then
    skhd_mode="$mod"
    echo -e "$skhd_mode | \
        ansi=true \
        size=12 \
        dropdown=false"
  fi
fi
