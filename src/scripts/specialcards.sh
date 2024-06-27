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

  echo "Starting $LANGUAGE specialcards"
  mkdir -p "$BUILDPATH/$LANGUAGE/images/cards/"
  echo -n .

  CATEGORY="$(cat "$SRCPATH/cards/$LANGUAGE/back.md")"
  CATEGORY="${CATEGORY^^}"

  magick "$SRCPATH/cards/backs.png" \
  -pointsize 160 -fill white -font "ext/static/OpenSans-SemiBold.ttf" -draw "text 190,300 '$CATEGORY'" \
  "$BUILDPATH/$LANGUAGE/images/cards/backs.png"
  echo -n .



  rm "$BUILDPATH/$LANGUAGE/"images/cards/s[0-9][0-9].png
  echo -n .

  TITLE="$(cat "$SRCPATH/cards/$LANGUAGE/specialtitle.md")"
  TITLE="${TITLE^^}"

  TEXT="$(cat "$SRCPATH/cards/$LANGUAGE/moreinfo.md")"

  magick "$SRCPATH/cards/front.png" \
  -pointsize 50 -fill white -font "ext/static/OpenSans-SemiBold.ttf" -draw "text 130,180 '$TITLE'" \
  +pointsize -gravity west -font "ext/static/OpenSans-Regular.ttf" -fill black -size 610x440 label:"$TEXT" -geometry +120+55\
  -composite -gravity east "$SRCPATH/github_qr.png" -geometry +100+50 \
  -composite "$BUILDPATH/$LANGUAGE/images/cards/s01.png"
  echo -n .
  
  cp "$BUILDPATH/$LANGUAGE/images/cards/s01.png" "$BUILDPATH/$LANGUAGE/images/cards/s02.png"
  echo -n .

  cp "$BUILDPATH/$LANGUAGE/images/cards/s01.png" "$BUILDPATH/$LANGUAGE/images/cards/s03.png"
  echo -n .

  cp "$BUILDPATH/$LANGUAGE/images/cards/s01.png" "$BUILDPATH/$LANGUAGE/images/cards/s04.png"
  echo -n .

  cp "$BUILDPATH/$LANGUAGE/images/cards/s01.png" "$BUILDPATH/$LANGUAGE/images/cards/s05.png"
  echo -n .

  cp "$BUILDPATH/$LANGUAGE/images/cards/s01.png" "$BUILDPATH/$LANGUAGE/images/cards/s06.png"
  echo -n .

  cp "$BUILDPATH/$LANGUAGE/images/cards/s01.png" "$BUILDPATH/$LANGUAGE/images/cards/s07.png"
  echo -n .


  TITLE="$(cat "$SRCPATH/cards/$LANGUAGE/credits.md")"
  TITLE="${TITLE^^}"
  TEXT="$(cat "$SRCPATH/cards/$LANGUAGE/credits_titles.md")"
  PERSONS="$(cat "$SRCPATH/cards/$LANGUAGE/credits_persons.md")"

  magick "$SRCPATH/cards/front.png" \
  -pointsize 50 -fill white -font "ext/static/OpenSans-SemiBold.ttf" -draw "text 130,180 '$TITLE'" \
  -fill black -pointsize 40 -gravity Northwest -font "ext/static/OpenSans-Regular.ttf" -size 450x \
  caption:"$TEXT" -geometry +600+220 -composite \
  -gravity Northeast -font "ext/static/OpenSans-Semibold.ttf" -size 450x \
  caption:"$PERSONS" -geometry +600+220 -composite \
  "$BUILDPATH/$LANGUAGE/images/cards/s08.png"
  echo .


done