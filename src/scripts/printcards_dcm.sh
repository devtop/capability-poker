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

for LANGUAGE in "de" ; do

  echo "Starting $LANGUAGE printsheet pdf"

  mkdir -p "$BUILDPATH/$LANGUAGE/print/pdf"
  echo -n .
  
  CARDS=$(ls "$BUILDPATH/$LANGUAGE/images/cards/"[0-9][0-9].png\
  "$BUILDPATH/$LANGUAGE/images/cards/i"[0-9].png\
  "$BUILDPATH/$LANGUAGE/images/cards/limit1.png"\
  "$BUILDPATH/$LANGUAGE/images/cards/limit3.png"\
  "$BUILDPATH/$LANGUAGE/images/cards/rules_front.png"\
  "$BUILDPATH/$LANGUAGE/images/cards/s07.png"\
  "$BUILDPATH/$LANGUAGE/images/cards/s08.png" | wc -l)

  FILL=$(( 55 - $CARDS ))

  if [ -f "$ROOTPATH/ext/ISOcoated_v2_300_eci.icc" ]; then
    magick -quality 100 -density 300 \
      "$BUILDPATH/$LANGUAGE/images/cards/"[0-9][0-9].png \
      "$BUILDPATH/$LANGUAGE/images/cards/i"[0-9].png \
      "$BUILDPATH/$LANGUAGE/images/cards/limit1.png" \
      "$BUILDPATH/$LANGUAGE/images/cards/limit3.png" \
      "$BUILDPATH/$LANGUAGE/images/cards/rules_front.png" \
      "$BUILDPATH/$LANGUAGE/images/cards/s"0[1-$FILL].png \
      "$BUILDPATH/$LANGUAGE/images/cards/s"07.png \
      "$BUILDPATH/$LANGUAGE/images/cards/s"08.png \
      -profile "$ROOTPATH/ext/ISOcoated_v2_300_eci.icc" \
      "$BUILDPATH/$LANGUAGE/print/pdf/cards_front.pdf"
  else
    magick -quality 100 -density 300 \
      "$BUILDPATH/$LANGUAGE/images/cards/"[0-9][0-9].png \
      "$BUILDPATH/$LANGUAGE/images/cards/i"[0-9].png \
      "$BUILDPATH/$LANGUAGE/images/cards/limit1.png" \
      "$BUILDPATH/$LANGUAGE/images/cards/limit3.png" \
      "$BUILDPATH/$LANGUAGE/images/cards/rules_front.png" \
      "$BUILDPATH/$LANGUAGE/images/cards/s"0[1-$FILL].png \
      "$BUILDPATH/$LANGUAGE/images/cards/s"07.png \
      "$BUILDPATH/$LANGUAGE/images/cards/s"08.png \
      "$BUILDPATH/$LANGUAGE/print/pdf/cards_front.pdf"
  fi
  echo -n .

  CARDS=$(ls "$BUILDPATH/$LANGUAGE/images/cards/"[0-9][0-9].png "$BUILDPATH/$LANGUAGE/images/cards/i"[0-9].png | wc -l )

  rm "$BUILDPATH/$LANGUAGE/images/cards/back"[0-9][0-9].png
  for (( i=0; i<$CARDS; i++ ))
  do
      cp "$BUILDPATH/$LANGUAGE/images/cards/back.png" "$BUILDPATH/$LANGUAGE/images/cards/back"$(printf "%02d" $i)".png"
  done

  cp "$BUILDPATH/$LANGUAGE/images/cards/limit2.png" "$BUILDPATH/$LANGUAGE/images/cards/back"$(printf "%02d" $CARDS)".png"
  CARDS=$(( $CARDS + 1 ))
  cp "$BUILDPATH/$LANGUAGE/images/cards/limit4.png" "$BUILDPATH/$LANGUAGE/images/cards/back"$(printf "%02d" $CARDS)".png"
  CARDS=$(( $CARDS + 1 ))

  cp "$BUILDPATH/$LANGUAGE/images/cards/rules_back.png" "$BUILDPATH/$LANGUAGE/images/cards/back"$(printf "%02d" $CARDS)".png"
  CARDS=$(( $CARDS + 1 ))

  for (( i=$CARDS; i<55; i++ ))
  do
      cp "$BUILDPATH/$LANGUAGE/images/cards/backs.png" "$BUILDPATH/$LANGUAGE/images/cards/back"$(printf "%02d" $i)".png"
  done
  cp "$BUILDPATH/$LANGUAGE/images/cards/back_FOKUSTeam.png" "$BUILDPATH/$LANGUAGE/images/cards/back53.png"

  echo "$BACKS"
  if [ -f "$ROOTPATH/ext/ISOcoated_v2_300_eci.icc" ]; then
    magick -quality 100 -density 300 \
      "$BUILDPATH/$LANGUAGE/images/cards/back"[0-9][0-9].png \
      -profile "$ROOTPATH/ext/ISOcoated_v2_300_eci.icc" \
      "$BUILDPATH/$LANGUAGE/print/pdf/cards_back.pdf"
  else
    magick -quality 100 -density 300 \
      "$BUILDPATH/$LANGUAGE/images/cards/back"[0-9][0-9].png \
      "$BUILDPATH/$LANGUAGE/print/pdf/cards_back.pdf"
  fi
  echo -n .
done
