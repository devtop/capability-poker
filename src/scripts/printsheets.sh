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

  echo "Starting $LANGUAGE printsheet pdf"

  mkdir -p "$BUILDPATH/$LANGUAGE/print/pdf"
  echo -n .
  
  magick -quality 94 -density 300 "$BUILDPATH/$LANGUAGE/print/images/"*.jpg -page A4 "$BUILDPATH/$LANGUAGE/print/pdf/cards.pdf"
  echo -n .

  magick -quality 50 -density 77 "$BUILDPATH/$LANGUAGE/print/images/"*.jpg -page A4 "$BUILDPATH/$LANGUAGE/print/pdf/cards_compact.pdf"
  echo -n .
done