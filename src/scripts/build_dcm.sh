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
BUILDPATH="$ROOTPATH/build/dcm"

cd "$ROOTPATH"

# Build cards
"$SCRIPT_PATH/cards_dcm.sh"

# Build specialcards
"$SCRIPT_PATH/specialcards_dcm.sh"

# Build images of print sheet 
"$SCRIPT_PATH/cards_printsheets.sh"

# Build pdf print sheets
"$SCRIPT_PATH/printsheets.sh"

# Build print card pdfs
"$SCRIPT_PATH/printcards.sh"

# Build print box
"$SCRIPT_PATH/box.sh"

# Build rules
"$SCRIPT_PATH/rules.sh"

# Build packages
"$SCRIPT_PATH/packages.sh"
