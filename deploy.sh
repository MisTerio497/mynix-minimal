#!/usr/bin/env bash

git add *
git commit -m "build_$(date '+%H-%M_%Y-%m-%d')"
git push
