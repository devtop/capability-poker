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

  echo "Starting $LANGUAGE box"
  mkdir -p "$BUILDPATH/$LANGUAGE/print/pdf"
  echo -n .

  if [ -f "$ROOTPATH/ext/ISOcoated_v2_300_eci.icc" ]; then
    magick -quality 100 -density 300 \
      "$SRCPATH/box.jpg" \
      -profile "$ROOTPATH/ext/ISOcoated_v2_300_eci.icc" \
      "$BUILDPATH/$LANGUAGE/print/pdf/box.pdf"
  else
    magick -quality 100 -density 300 \
      "$SRCPATH/box.jpg" \
      "$BUILDPATH/$LANGUAGE/print/pdf/box.pdf"
  fi
  echo .

done