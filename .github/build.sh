#!/bin/bash

set -x;

cd $1;
if [ -f "vector.svg" ]; then
  toIco(){
    gm convert $1x$1.png $1x$1.ico
    if [ $? -ne "0" ]; then
      rm $1x$1.ico
    fi;
  }
  toFormat() {
    inkscape -w $1 -h $1 vector.svg --export-filename $1x$1.$2;
  }
  run() {
    toFormat $1 png;
    gm convert $1x$1.png $1x$1.webp;
    toIco $1;
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
