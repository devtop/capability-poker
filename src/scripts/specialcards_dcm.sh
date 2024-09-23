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

  echo "Starting $LANGUAGE specialcards"
  mkdir -p "$BUILDPATH/$LANGUAGE/images/cards/"
  echo -n .

  CATEGORY="$(cat "$SRCPATH/cards/$LANGUAGE/back.md")"
  CATEGORY="${CATEGORY^^}"

  magick "$SRCPATH/cards/backs_dcm.png" \
  -pointsize 160 -fill white -font "ext/static/OpenSans-SemiBold.ttf" -draw "text 282,395 '$CATEGORY'" \
  "$BUILDPATH/$LANGUAGE/images/cards/backs.png"
  echo -n .

  magick "$SRCPATH/cards/back_FOKUSTeam_dcm.png" \
  -pointsize 160 -fill white -font "ext/static/OpenSans-SemiBold.ttf" -draw "text 282,395 '$CATEGORY'" \
  "$BUILDPATH/$LANGUAGE/images/cards/back_FOKUSTeam.png"
  echo -n .

  rm "$BUILDPATH/$LANGUAGE/"images/cards/s[0-9][0-9].png
  echo -n .

  TITLE="$(cat "$SRCPATH/cards/$LANGUAGE/specialtitle.md")"
  TITLE="${TITLE^^}"

  TEXT="$(cat "$SRCPATH/cards/$LANGUAGE/moreinfo.md")"

  magick "$SRCPATH/cards/front_blue_dcm.png" \
  -pointsize 50 -fill white -font "ext/static/OpenSans-SemiBold.ttf" -draw "text 222,275 '$TITLE'" \
  +pointsize -gravity west -font "ext/static/OpenSans-Regular.ttf" -fill black -size 610x440 label:"$TEXT" -geometry +212+55\
  -composite -gravity east "$SRCPATH/github_qr.png" -geometry +192+50 \
  -composite "$BUILDPATH/$LANGUAGE/images/cards/s01.png"
  echo -n .


  TITLE="$(cat "$SRCPATH/cards/$LANGUAGE/rules_title.md")"
  TITLE="${TITLE^^}"

  TEXT="$(cat "$SRCPATH/cards/$LANGUAGE/rules_front.md")"

  magick "$SRCPATH/cards/front_green_dcm.png" \
  -pointsize 50 -fill white -font "ext/static/OpenSans-SemiBold.ttf" -draw "text 222,275 '$TITLE'" \
  +pointsize -gravity northwest -font "ext/static/OpenSans-Regular.ttf" -fill black -size 940x440 label:"$TEXT" -geometry +212+315\
  -composite "$BUILDPATH/$LANGUAGE/images/cards/rules_front.png"
  echo -n .

  TEXT="$(cat "$SRCPATH/cards/$LANGUAGE/rules_back.md")"
  magick "$SRCPATH/cards/front_green_dcm.png" \
  +pointsize -gravity northwest -font "ext/static/OpenSans-Regular.ttf" -fill black -size 940x440 label:"$TEXT" -geometry +212+315\
  -composite -gravity east "$SRCPATH/qr_github_rules.png" -geometry +292+150 \
  -composite "$BUILDPATH/$LANGUAGE/images/cards/rules_back.png"
  echo -n .

  cp "$BUILDPATH/$LANGUAGE/images/cards/s01.png" "$BUILDPATH/$LANGUAGE/images/cards/s02.png"
  echo -n .
  
  cp "$BUILDPATH/$LANGUAGE/images/cards/s01.png" "$BUILDPATH/$LANGUAGE/images/cards/s03.png"
  echo -n .

  cp "$BUILDPATH/$LANGUAGE/images/cards/s01.png" "$BUILDPATH/$LANGUAGE/images/cards/s04.png"
  echo -n .


  TITLE="$(cat "$SRCPATH/cards/$LANGUAGE/limit_title.md")"
  TITLE="${TITLE^^}"

  magick "$SRCPATH/cards/limit_dcm.png" \
  -pointsize 50 -fill white -font "ext/static/OpenSans-SemiBold.ttf" -draw "text 212,275 '$TITLE'" \
  -fill black -font "ext/static/OpenSans-Bold.ttf" -pointsize 420 \
  -draw "text 542,695 '1'" \
  "$BUILDPATH/$LANGUAGE/images/cards/limit1.png"
  echo -n .

  magick "$SRCPATH/cards/limit_dcm.png" \
  -pointsize 50 -fill white -font "ext/static/OpenSans-SemiBold.ttf" -draw "text 212,275 '$TITLE'" \
  -fill black -font "ext/static/OpenSans-Bold.ttf" -pointsize 420 \
  -draw "text 542,695 '2'" \
  "$BUILDPATH/$LANGUAGE/images/cards/limit2.png"
  echo -n .

  magick "$SRCPATH/cards/limit_dcm.png" \
  -pointsize 50 -fill white -font "ext/static/OpenSans-SemiBold.ttf" -draw "text 212,275 '$TITLE'" \
  -fill black -font "ext/static/OpenSans-Bold.ttf" -pointsize 420 \
  -draw "text 542,695 '3'" \
  "$BUILDPATH/$LANGUAGE/images/cards/limit3.png"
  echo -n .

  magick "$SRCPATH/cards/limit_dcm.png" \
  -pointsize 50 -fill white -font "ext/static/OpenSans-SemiBold.ttf" -draw "text 212,275 '$TITLE'" \
  -fill black -font "ext/static/OpenSans-Bold.ttf" -pointsize 420 \
  -draw "text 542,695 '4'" \
  "$BUILDPATH/$LANGUAGE/images/cards/limit4.png"
  echo -n .

  TITLE="$(cat "$SRCPATH/cards/$LANGUAGE/podcast_title.md")"
  TITLE="${TITLE^^}"
  TEXT="$(cat "$SRCPATH/cards/$LANGUAGE/podcast_info.md")"
  LINK="$(cat "$SRCPATH/cards/$LANGUAGE/podcast_link.md")"

  magick "$SRCPATH/cards/front_FOKUSTeam_dcm.png" \
  -pointsize 50 -fill white -font "ext/static/OpenSans-SemiBold.ttf" -draw "text 212,275 '$TITLE'" \
  -fill black -font "ext/static/OpenSans-Regular.ttf" +pointsize -size 520x380 \
  caption:"$TEXT" -geometry +212+315 -composite \
  -size 900x40 \
  caption:"$LINK" -geometry +212+740 -composite \
  "$BUILDPATH/$LANGUAGE/images/cards/s07.png"
  echo -n .

  TITLE="$(cat "$SRCPATH/cards/$LANGUAGE/credits.md")"
  TITLE="${TITLE^^}"
  TEXT="$(cat "$SRCPATH/cards/$LANGUAGE/credits_titles.md")"
  PERSONS="$(cat "$SRCPATH/cards/$LANGUAGE/credits_persons.md")"

  magick "$SRCPATH/cards/front_blue_dcm.png" \
  -pointsize 50 -fill white -font "ext/static/OpenSans-SemiBold.ttf" -draw "text 212,275 '$TITLE'" \
  -fill black -pointsize 40 -gravity Northwest -font "ext/static/OpenSans-Regular.ttf" -size 450x \
  caption:"$TEXT" -geometry +692+315 -composite \
  -gravity Northeast -font "ext/static/OpenSans-Semibold.ttf" -size 450x \
  caption:"$PERSONS" -geometry +692+315 -composite \
  "$BUILDPATH/$LANGUAGE/images/cards/s08.png"
  echo .


done