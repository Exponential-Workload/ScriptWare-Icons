#!/bin/bash
# Funny script for converting shit
getconvcmd(){
  echo "magick convert $1x$1.png -resize ${2}x${2}^ $2x$2.$3"
}
getcmds(){
  getconvcmd $1 $2 png;
  getconvcmd $2 $2 webp;
  getconvcmd $2 $2 ico;
}
run(){
  getcmds $@
  getcmds $@ | bash
  if [ $? -ne "0" ]; then
    echo "not 0"
    rm $2x$2.ico
  fi;
}

# ^2
run 8192 4096
run 4096 2048
run 2048 1024
run 1024 512
run 512 256
run 256 128
run 1024 64
run 64 32
run 32 16

# non ^2
run 8192 3072
run 4096 1536
run 2048 384
run 2048 192
run 2048 152
run 2048 144
run 2048 96
run 2048 72