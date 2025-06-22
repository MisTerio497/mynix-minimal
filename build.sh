#!/usr/bin/env bash

current_dir=$(pwd)
cd /home/ivan/nix
git add -A
git commit -m "build_$(date '+%H-%M_%Y-%m-%d')"
git push
cd "$current_dir"
