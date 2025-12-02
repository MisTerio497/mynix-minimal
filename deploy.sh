#!/usr/bin/env bash

git add -A
git commit -m "build_$(date '+%H-%M_%Y-%m-%d')"
git push
