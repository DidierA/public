# see https://blog.ropnop.com/docker-for-pentesters/
alias dockershell="docker run --rm -i -t --entrypoint=/bin/bash"  
alias dockershellsh="docker run --rm -i -t --entrypoint=/bin/sh"

function phpserverhere() {
	dirname=${PWD##*/}
	docker run --rm -it -p 80:80 --name my-apache-php-app -v "$PWD":/var/www/html php:7.2-apache
}

function dockershellhere() {  
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/bash -v "${PWD}:/${dirname}" -w "/${dirname}" "$@"
}
function dockershellshhere() {  
    dirname=${PWD##*/}
    docker run --rm -it --entrypoint=/bin/sh -v "${PWD}:/${dirname}" -w "/${dirname}" "$@"
}

alias impacket="docker run --rm -it rflathers/impacket"  

function smbservehere() {  
    local sharename
    [[ -z $1 ]] && sharename="SHARE" || sharename=$1
    docker run --rm -it -p 445:445 -v "${PWD}:/tmp/serve" rflathers/impacket smbserver.py -smb2support $sharename /tmp/serve
}

alias webdavhere='echo "Acces via \\\\IP@8000\share\ in Windows explorer"; docker run --rm -it -p 8000:80 -v "${PWD}:/srv/data/share" rflathers/webdav'

