#!/usr/bin/env bash

# shellcheck source=/dev/null
source "${HOME}/.bashrc"

ORIGINAL_POD=$(which -a pod | grep -v /opt/bitrise/bin | head -n1)

if [ $# -eq 2 ] && [ "${1}" == 'repo' ] && [ "${2}" == 'update' ] && [ -z "${BITRISE_POD_REPO_UPDATE}" ]
then
  repos=$(find "${HOME}/.cocoapods/repos" -mindepth 1 -maxdepth 1 -type d)
  echo "Repos: ${repos}"
  for repo in $repos
  do
    if [ -d "${repo}/.git" ]
    then
      if echo "${repo}" | grep -q -e 'master';
      then
        # If it is master, use  optimisation
        echo "Using Bitrise.io specific optimalisation for pod repo update on master"
        echo "To skip this optimisation, set envvar BITRISE_POD_REPO_UPDATE to 'off'"
        set -x
        /usr/local/bin/git -C "${repo}" fetch origin --progress
        REF=$(/usr/local/bin/git -C "${repo}" rev-parse --abbrev-ref HEAD)
        echo "${REF}"
        /usr/local/bin/git -C /Users/vagrant/.cocoapods/repos/master reset --keep "origin/${REF}"
        set +x
      else
        # If it is not master, use the original shim
       reponame=$(echo "${repo}" | rev | cut -d "/" -f 1 | rev)
       $ORIGINAL_POD repo update "${reponame}"
      fi
    fi
  done
else
  $ORIGINAL_POD "${@}"
fi
