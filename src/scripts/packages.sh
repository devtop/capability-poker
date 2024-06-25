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

  echo "Starting $LANGUAGE packages"

  rm "$BUILDPATH/print_diy.$LANGUAGE.zip"
  zip -j "$BUILDPATH/print_diy.$LANGUAGE.zip" \
    "$BUILDPATH/$LANGUAGE/print/pdf/cards.pdf" \
    "$BUILDPATH/$LANGUAGE/rules.pdf" \
    "$ROOTPATH/LICENSE"
  echo -n .

  rm "$BUILDPATH/print_professional.$LANGUAGE.zip"
  zip -j "$BUILDPATH/print_professional.$LANGUAGE.zip" \
    "$BUILDPATH/$LANGUAGE/print/pdf/cards_front.pdf" \
    "$BUILDPATH/$LANGUAGE/print/pdf/cards_back.pdf" \
    "$SRCPATH/box.jpg" \
    "$ROOTPATH/LICENSE"
  echo -n .

  rm "$BUILDPATH/print_mail.$LANGUAGE.zip"
  zip -j "$BUILDPATH/print_mail.$LANGUAGE.zip" \
    "$BUILDPATH/$LANGUAGE/print/pdf/cards_compact.pdf" \
    "$BUILDPATH/$LANGUAGE/rules.pdf" \
    "$ROOTPATH/LICENSE" 
  echo -n .

  cp "$ROOTPATH/LICENSE" "build/$LANGUAGE"
  rm "$BUILDPATH/all.$LANGUAGE.zip"
  zip -r "$BUILDPATH/all.$LANGUAGE.zip" \
    "build/$LANGUAGE"
  echo .
done