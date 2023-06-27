#!/bin/bash

cd $1;
if [ -f "vector.svg" ]; then
  inkscape -w 8192 -h 8192 vector.svg --export-filename 8192x8192.png;
fi;
../.github/convert.sh;
cd ..;
