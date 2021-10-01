#!/usr/bin/env bash
#
# This can be called from anywhere, but is intended to be called from 
#    the top-level MD_Utils directory.  That is, the intended method
#    of use looks like:
#
#    scripts/make-versions-file.bash
# 
echo """
MD_UTILS_GIT_BRANCH=\"$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')\"
MD_UTILS_GIT_COMMIT_HASH=\"$(git rev-parse HEAD)\"
""" > VERSIONS.sh

