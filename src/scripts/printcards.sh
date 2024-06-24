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
  
  CARDS=$(ls "$BUILDPATH/$LANGUAGE/images/cards/"[0-9][0-9].png "$BUILDPATH/$LANGUAGE/images/cards/i"[0-9].png "$BUILDPATH/$LANGUAGE/images/cards/s"08.png | wc -l)

  FILL=$(( 55 - $CARDS ))

  if [ -f "$ROOTPATH/ext/ISOcoated_v2_300_eci.icc" ]; then
    magick -quality 100 -density 305 \
      "$BUILDPATH/$LANGUAGE/images/cards/"[0-9][0-9].png \
      "$BUILDPATH/$LANGUAGE/images/cards/i"[0-9].png \
      "$BUILDPATH/$LANGUAGE/images/cards/s"08.png \
      "$BUILDPATH/$LANGUAGE/images/cards/s"0[1-$FILL].png -rotate 270 \
      -profile "$ROOTPATH/ext/ISOcoated_v2_300_eci.icc" \
      "$BUILDPATH/$LANGUAGE/print/pdf/cards_front.pdf"
  else
    magick -quality 100 -density 305 \
      "$BUILDPATH/$LANGUAGE/images/cards/"[0-9][0-9].png \
      "$BUILDPATH/$LANGUAGE/images/cards/i"[0-9].png \
      "$BUILDPATH/$LANGUAGE/images/cards/s"08.png \
      "$BUILDPATH/$LANGUAGE/images/cards/s"0[1-$FILL].png -rotate 270 \
      "$BUILDPATH/$LANGUAGE/print/pdf/cards_front.pdf"
  fi
  echo -n .

  rm "$BUILDPATH/$LANGUAGE/images/cards/back"[0-9][0-9].png
  for (( i=0; i<$CARDS; i++ ))
  do
      cp "$BUILDPATH/$LANGUAGE/images/cards/back.png" "$BUILDPATH/$LANGUAGE/images/cards/back"$(printf "%02d" $i)".png"
  done

  for (( i=$CARDS; i<55; i++ ))
  do
      cp "$BUILDPATH/$LANGUAGE/images/cards/backs.png" "$BUILDPATH/$LANGUAGE/images/cards/back"$(printf "%02d" $i)".png"
  done

  echo "$BACKS"
  if [ -f "$ROOTPATH/ext/ISOcoated_v2_300_eci.icc" ]; then
    magick -quality 100 -density 305 \
      "$BUILDPATH/$LANGUAGE/images/cards/back"[0-9][0-9].png -rotate 90 \
      -profile "$ROOTPATH/ext/ISOcoated_v2_300_eci.icc" \
      "$BUILDPATH/$LANGUAGE/print/pdf/cards_back.pdf"
  else
    magick -quality 100 -density 305 \
      "$BUILDPATH/$LANGUAGE/images/cards/back"[0-9][0-9].png -rotate 90 \
      "$BUILDPATH/$LANGUAGE/print/pdf/cards_back.pdf"
  fi
  echo -n .
done
