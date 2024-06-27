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

  echo "Starting $LANGUAGE cards"
  mkdir -p "$BUILDPATH/$LANGUAGE/images/cards/"

  CATEGORY="$(cat "$SRCPATH/cards/$LANGUAGE/back.md")"
  CATEGORY="${CATEGORY^^}"

  magick "$SRCPATH/cards/back.png" \
  -pointsize 160 -fill white -font "ext/static/OpenSans-SemiBold.ttf" -draw "text 190,300 '$CATEGORY'" \
  "$BUILDPATH/$LANGUAGE/images/cards/back.png"

  TITLE="$(cat "$SRCPATH/cards/$LANGUAGE/title.md")"
  TITLE="${TITLE^^}"

  cardcount=0

  for file in src/cards/$LANGUAGE/[0-9][0-9].md; do
    filename=$(basename -- "$file")
    extension="${filename##*.}"
    cardnumber="${filename%\.md}"
    TEXT="$(cat "$SRCPATH/cards/$LANGUAGE/$cardnumber.md")"
    FONTSIZE=36

    SIZE=$(magick -size 930x440 -background white -font "ext/static/OpenSans-Regular.ttf" \
     label:"$TEXT" -format "%[label:pointsize]\n" info:)
    
    if [ "$SIZE" -gt "164" ] ; then
      magick "$SRCPATH/cards/front.png" \
      -pointsize 50 -fill white -font "ext/static/OpenSans-SemiBold.ttf" -draw "text 130,180 '$TITLE'" \
      -pointsize 30 -font "ext/static/OpenSans-Regular.ttf" -draw "text 1040,190 '$cardnumber'" \
      -pointsize 164 -gravity west -fill black -size 930x440 label:"$TEXT" -geometry +120+55\
      -composite "$BUILDPATH/$LANGUAGE/images/cards/$cardnumber.png"
    else
      magick "$SRCPATH/cards/front.png" \
      -pointsize 50 -fill white -font "ext/static/OpenSans-SemiBold.ttf" -draw "text 130,180 '$TITLE'" \
      -pointsize 30 -font "ext/static/OpenSans-Regular.ttf" -draw "text 1040,190 '$cardnumber'" \
      +pointsize -gravity west -fill black -size 930x440 label:"$TEXT" -geometry +120+55\
      -composite "$BUILDPATH/$LANGUAGE/images/cards/$cardnumber.png"
    fi
    let cardcount++
    echo -n .
  done

  rm "$BUILDPATH/$LANGUAGE/"images/cards/i[0-9].png
  echo -n .

  INDIVIDUELL="$(cat "$SRCPATH/cards/$LANGUAGE/individual.md")"
  ADDITIONALCARDS=$(($cardcount % 8))
  ADDITIONALCARDS=$((8 - $ADDITIONALCARDS))

  if [ "$ADDITIONALCARDS" -eq 0 ]; then
    ADDITIONALCARDS=8
  fi
  
  for i in $(seq 1 $ADDITIONALCARDS); do
    magick "$SRCPATH/cards/front.png" \
    -pointsize 50 -fill white -font "ext/static/OpenSans-SemiBold.ttf" -draw "text 130,180 '$TITLE'" \
    -pointsize 20 -gravity northeast -font "ext/static/OpenSans-Regular.ttf" -draw "text 230,170 '$INDIVIDUELL'" \
    "$BUILDPATH/$LANGUAGE/images/cards/i$i.png"
    echo -n .
  done
  echo " "
done