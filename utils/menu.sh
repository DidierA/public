#!/bin/bash

BASEPATH="samples/"

# file containing capture of  lights on
light_on_file=${BASEPATH}/lights_on.pcap
light_off_file=${BASEPATH}/lights_off.pcap
twinkle_file=${BASEPATH}/lights_on_off.pcap
door_closed_file=${BASEPATH}/door_closed.pcap

# args:
# $1 file
# $2 nr of loops
# $3 delay
replay_file() {
    local file="$1" ; shift 
    local loops="$1" ; shift
    local delay="$1" ; shift

    sudo zwreplay -c FR -v -r "$file" -l "$loops" -w "$delay"
}

light_on() {
    replay_file "$light_on_file" 2 0.5
}

light_off() {
    replay_file "$light_off_file" 2 0.5
}

twinkle() {
    replay_file "$twinkle_file" 10 0.5
}

flood_door_close() {
    replay_file "$door_closed_file" 1000 0.1
}

show_menu() {
    sed -e s'/^ *//' <<END_MENU
    ====
    MENU
    ====
    1. Switch light ON
    2. Switch light OFF
    3. Twinkle, twinkle
    4. Force closed door status
    5. Exit

END_MENU
}

read_options() {
    local choice
    read -p "Enter choice [ 1 - 5 ] " choice
    case "$choice" in
        1) light_on ;;
        2) light_off ;;
        3) twinkle ;;
        4) flood_door_close ;;
        5) exit 0 ;;
        *) echo "Invalid choice" 
    esac
}

while true ; do
    show_menu
    read_options
done
