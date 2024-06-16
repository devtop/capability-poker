#!/bin/bash

SCRIPT_PATH="$(dirname -- "${BASH_SOURCE[0]}")"            # relative
SCRIPT_PATH="$(cd -- "$SCRIPT_PATH" && pwd)"    # absolutized and normalized
if [[ -z "$SCRIPT_PATH" ]] ; then
  # error; for some reason, the path is not accessible
  # to the script (e.g. permissions re-evaled after suid)
  exit 1  # fail
fi

ROOTPATH="$(cd -- "$SCRIPT_PATH/../../" && pwd)"
SRCPATH="$ROOTPATH/src"
BUILDPATH="$ROOTPATH/build"

cd "$ROOTPATH"

for LANGUAGE in "de" ; do

  echo "Starting $LANGUAGE rules"
  
  cd "$SRCPATH/rules/"
#  pandoc -s -f gfm -t pdf -o "$BUILDPATH/$LANGUAGE/rules.pdf" "rules.$LANGUAGE.md"
  mdpdf "rules.$LANGUAGE.md" "$BUILDPATH/$LANGUAGE/rules.pdf"
  echo .
done