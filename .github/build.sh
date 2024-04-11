#!/bin/bash

set -eax;

if [ "$#" -ne "1" ]; then
  echo "Usage: ./convert_vector.sh <path>";
  exit;
fi;

__dirname=$(dirname "$(readlink -f "$0")");

cd $1;
if [ -f "vector.svg" ]; then
  IMG_INFO="$($__dirname/aspect-ratio.sh vector.svg)"
  echo "$IMG_INFO" > IMAGE_METADATA
  echo -e "Image Metadata:\n$IMG_INFO"
  eval $IMG_INFO
  toIco(){
    convert "${size}.png" "${size}.ico"
    if [ $? -ne "0" ]; then
      rm "${size}.ico"
    fi;
  }
  toFormat() {
    inkscape -w "$width" -h "$height" vector.svg --export-filename $size.$2;
  }
  run() {
    width="$1";
    echo $width \* $IMG_ASPECT_RATIO
    # IMG_ASPECT_RATIO is returned by aspect-ratio.sh
    height=$(echo "scale=0; $width / $IMG_ASPECT_RATIO" | bc)
    size="${width}x${height}"
    toFormat $1 png;
    gm convert $size.png $size.webp;
    # if the width & height are both under or equal to 256
    if (( $(echo "$height <= 256" | bc) && $(echo "$width <= 256" | bc) )); then
      toIco $1;
    fi;
  }
  
  # ^2
  run 8192
  run 4096
  run 2048
  run 1024
  run 512
  run 256
  run 128
  run 64
  run 32
  run 16
  
  # non ^2
  run 3072
  run 1536
  run 384
  run 192
  run 152
  run 144
  run 96
  run 72
fi;
cd ..;
