#!/bin/bash

brew bundle --file ./conventional-commits.Brewfile

npm install -g\
  conventional-changelog-cli\
  @commitlint/cli\
  @commitlint/config-conventional

pre-commit install
pre-commit install --hook-type commit-msg
