to_windows_unicode() {
	iconv -t UNICODELITTLE "$@"
}

powershell_encode() {
to_windows_unicode | base64 -w 0
}

gen_pse() {
load=$(echo "$@" | powershell_encode)
echo "powershell -encodedCommand $load"
}


save_cert() {
	dst=$1
	port=${2:-443}
	echo "" | openssl s_client -connect ${dst}:$port | openssl x509 -out ${dst}-${port}.cer	
}

sniff_luna() {
	filter="$*"
	ssh luna "sudo /usr/sbin/tcpdump -U -i eno1 -w - '$filter'" | wireshark -i - -k
}

# starts a pseudo Checkpoint session agent
session_agent() {
    konsole -e sh -c 'while : ; do /usr/bin/sudo nc -l -p 261 -v -v; done'
}

function dupstderr {
# redirects stderr to stderr AND file.
# Arguments: <file> <cmd> <args...>
# example : 
#   dupstderr error_file cp toto tata
# will execute "cp toto tata", displaying errors while loging them also to error_file
    errfile=$1 ; shift
    { "$@" 2>&1 >&3 | tee "$errfile" ; } 3>&2
}

function webserver {
    local port=8000
    if [ -n "$1" ] ; then
        port="$1" ;
    fi
    python -m SimpleHTTPServer "$port"
}

function sniffdeuterium {
    if [ -z "$1" ] ; then 
        echo "please provide a filter"
        exit 1
    fi
    ssh root@deuterium "/opt/sbin/tcpdump -s0 -w - $@" | wireshark -k -i -
}

function bin2hex {
    xxd -p $@
}

function hex2bin {
    xxd -r -p $@
}

function hexdump {
    xxd -a $@
}

function mountU {
	sudo mount -t cifs -odomain=FRA,user=197178 '//pardmp22hd/197178$' /mnt/network/U
}

hashes_api_key=$(cat ~/.config/hashes_api_key)
function hash_crack {
        hash="$1"
        curl 'https://hashes.org/api.php?key='$hashes_api_key'&query='$hash | js-beautify
}

# functions to compress / decompress 'raw' zlib data
zlib-decompress() {
        cat "$@" | python -c 'import sys,zlib; sys.stdout.write(zlib.decompress(sys.stdin.read()))'
}

zlib-compress() {
        cat "$@" | python -c 'import sys,zlib; sys.stdout.write(zlib.compress(sys.stdin.read()))'
}

# replace searchsploit with a friendly menu -- requires fzf,jq,xdg-open and wl-copy for wayland
searchsploit-ui() {
    searchsploit "$@" -j | \
    jq -r '[ .RESULTS_EXPLOIT[],.RESULTS_SHELLCODE[],.RESULTS_PAPER[] | {title:.Title, id:."EDB-ID"}] | unique | .[] | "\(.title)\t\u001b[90m\(.id)\u001b[0m" ' | \
    fzf -0 --layout=reverse --ansi \
    --bind "enter:execute(LESS='-RMQXSW --use-color' LESSOPEN='|pygmentize -f terminal %s' searchsploit -x {-1})" \
    --bind "ctrl-c:execute-silent(searchsploit -p {-1} |  grep Path: | cut -d: -f2 | tr -d ' ' | wl-copy)" \
    --bind 'ctrl-d:execute(searchsploit -m {-1})' \
    --bind "ctrl-o:execute-silent(searchsploit -p {-1} |  grep Path: | cut -d: -f2 | tr -d ' ' | xargs xdg-open)" \
    --bind "ctrl-w:execute-silent(searchsploit -p {-1} |  grep URL: | cut -d: -f2- | tr -d ' ' | xargs xdg-open)" \
    --header="[ESC]Quit [Enter]View [Ctrl-C]Copy path [Ctrl-D]Copy file [Ctrl-O]Open [Ctrl-W]Web" --header-first \
    --ellipsis=… --preview "searchsploit -p {-1}" --preview-window=down,6
}

. ~/scripts/funcs_bigip.sh
. ~/scripts/funcs_docker.sh
