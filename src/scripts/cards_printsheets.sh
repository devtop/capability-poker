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

  echo "Starting $LANGUAGE cards printsheets"

  mkdir -p "$BUILDPATH/$LANGUAGE/print/images/"
  echo -n .
  
  rm "$BUILDPATH/$LANGUAGE/"print/images/cards*.jpg
  echo -n .

  magick montage -page A4 -density 300 -gravity north-west \
   "$BUILDPATH/$LANGUAGE/images/cards/"[0-9][0-9].png \
   "$BUILDPATH/$LANGUAGE/images/cards/i"[0-9].png \
   "$BUILDPATH/$LANGUAGE/images/cards/s"[0-9][0-9].png \
  -tile 2x4 -geometry +2+2 "$BUILDPATH/$LANGUAGE/print/images/cards.jpg"
  echo -n . 
  
  magick montage -page A4 -density 300 -gravity north-west \
  "$BUILDPATH/$LANGUAGE/images/cards/back.png" \
  "$BUILDPATH/$LANGUAGE/images/cards/back.png" \
  "$BUILDPATH/$LANGUAGE/images/cards/back.png" \
  "$BUILDPATH/$LANGUAGE/images/cards/back.png" \
  "$BUILDPATH/$LANGUAGE/images/cards/back.png" \
  "$BUILDPATH/$LANGUAGE/images/cards/back.png" \
  "$BUILDPATH/$LANGUAGE/images/cards/back.png" \
  "$BUILDPATH/$LANGUAGE/images/cards/back.png" \
  -tile 2x4 -geometry +2+2 "$BUILDPATH/$LANGUAGE/print/images/cards_back.jpg"
  echo -n .

  FILES=$(ls "$BUILDPATH/$LANGUAGE/images/cards/"[0-9][0-9].png "$BUILDPATH/$LANGUAGE/images/cards/i"[0-9].png "$BUILDPATH/$LANGUAGE/images/cards/s"[0-9][0-9].png | wc -l)
  (( SHEETS = (FILES+7)/8 ))
  if [ $SHEETS -gt 1 ]; then
    for (( i=0; i<$SHEETS; i++ ))
    do
      cp "$BUILDPATH/$LANGUAGE/print/images/cards_back.jpg" "$BUILDPATH/$LANGUAGE/print/images/cards-$i""b.jpg"
    done
    rm "$BUILDPATH/$LANGUAGE/print/images/cards_back.jpg"
  fi
  echo .
done