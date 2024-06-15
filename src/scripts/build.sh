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

# Merge text
"$SCRIPT_PATH/mergeText.sh"

# Build Cards
"$SCRIPT_PATH/cards.sh"

# Build Specialcards
"$SCRIPT_PATH/specialcards.sh"

# Build images of print sheet 
"$SCRIPT_PATH/cards_printsheets.sh"

# Build pdf print sheets
"$SCRIPT_PATH/printsheets.sh"

# Build packages
"$SCRIPT_PATH/packages.sh"
