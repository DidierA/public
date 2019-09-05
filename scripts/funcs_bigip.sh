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

ip2dec () {
    local a b c d ip=$@
    IFS=. read -r a b c d <<< "$ip"
    printf '%d\n' "$((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d))" 
}
