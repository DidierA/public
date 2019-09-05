#!/bin/sh
#set -x
#exec >/tmp/toto 2>&1
#echo err >&2
#echo glu

DISPLAY=${DISPLAY:-:0}
export DISPLAY

/usr/bin/xclip -selection clipboard -target image/png -i "$1"
