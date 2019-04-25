save_cert() {
        dst=$1
        port=${2:-443}
        echo "" | openssl s_client -connect ${dst}:$port | openssl x509 -out ${dst}-${port}.cer
}

# converts ip from and to decimal
dec2ip () {
    local ip delim dec=$@ 
    for e in {3..0}
    do
        ((octet = dec / (256 ** e) ))
        ((dec -= octet * 256 ** e))
        ip+=$delim$octet
        delim=.
    done
    printf '%s\n' "$ip"
}

ip2dec () {
    local a b c d ip=$@
    IFS=. read -r a b c d <<< "$ip"
    printf '%d\n' "$((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d))"
}

# converts bigIP port number (swap its bytes)
bigip_port() {
    local a b port dec=$1
    ((a= dec / 256))
    ((b= dec - a *256))
    ((port= b*256 +a))
    echo $port
}

# bigip string: IP.PORT
# eg 110536896.20480 => 10.241.183.54 port 443
# IP is converted to 32 bit unsigned int with right MSB
# port is 16 bits unsigned int with right MSB
bigip_decode() {
    local ip delim port revip string=$1
    f=(${(ps:.:)string})
    
    port=$(bigip_port $f[2])
    
    revip=$(dec2ip $f[1] )
    
    # reorder IP bytes
    f=(${(ps:.:)revip})
    ip=""
    for i in 4 3 2 1
    do
        ip+=$delim$f[$i]
        delim=.
    done

    echo "BigIP value: $1 gives IP $ip and port $port"

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
