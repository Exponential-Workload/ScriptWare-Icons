#!/bin/bash

set -ea;

if [ $# -ne 1 ]; then
  echo "Usage: $0 <svg_file>" >&2
  exit 1
fi

input="$1"
tmpfile="/tmp/$(date).$(basename "$input")"

if which svgo > /dev/null 2>&1; then
  echo "export default {
    plugins: [
      'preset-default',
      'prefixIds',
      'removeViewBox',
    ],
  };" > /tmp/svgo.config.mjs
  svgo --config /tmp/svgo.config.mjs -o "$tmpfile" -i "$input" > /dev/null;
  rm /tmp/svgo.config.mjs
else
  cp "$input" "$tmpfile";
fi

if [ ! -s "$tmpfile" ]; then
  echo "Fatal: no SVG file" >&2
  exit 1
fi

VIEWBOX=$(sed -n 's/.* viewBox="\?\([^"]*\)"\?.*/\1/p' "$tmpfile")
WIDTH=$(sed -n 's/.* width="\?\([^ "]*\)"\?.*/\1/p' "$tmpfile")
if [[ "$WIDTH" == "" ]] && [[ "$VIEWBOX" != "" ]]; then
  WIDTH=$(echo $VIEWBOX | awk '{print $3}')
fi;
if [[ "$WIDTH" == "" ]]; then
  echo "Fatal: unable to get width" >&2
  exit 1
fi;

HEIGHT=$(sed -n 's/.* height="\?\([^ "]*\)"\?.*/\1/p' "$tmpfile")
if [[ "$HEIGHT" == "" ]] && [[ "$VIEWBOX" != "" ]]; then
  HEIGHT=$(echo $VIEWBOX | awk '{print $4}')
fi;
if [[ "$HEIGHT" == "" ]]; then
  echo "Fatal: unable to get height" >&2
  exit 1
fi;

ASPECT_RATIO=$(echo "scale=6; $WIDTH / $HEIGHT" | bc)

if [ $? -ne 0 ]; then
  echo "Fatal: unable to calculate aspect ratio" >&2
  exit 1
fi;

if [[ "$VIEWBOX" != "" ]]; then
  echo "IMG_VIEWBOX='${VIEWBOX}'"
fi;
echo "IMG_WIDTH='${WIDTH}'"
echo "IMG_HEIGHT='${HEIGHT}'"
echo "IMG_ASPECT_RATIO='${ASPECT_RATIO}'"

rm -f "$tmpfile"
