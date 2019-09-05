# Recupere la cle DKIM dans le DNS
# Arguments:
# get_dkim_key.sh <selector> <domain>
# 	selector: la valeur s= dans le champ DKIM-Sigature du mail
#	domain: le domaine d'ou vient le mail
# Exemple:
# 	get_dkim_key.sh 20151010 bnpparibas.com 
#
# Ce script n'a été testé qu'avec les arguments ci dessus...

header='-----BEGIN PUBLIC KEY-----'
footer='-----END PUBLIC KEY-----'

selector=$1
domain=$2

filename=${selector}_${domain}.pub

echo "$header" >$filename
# on recupere tout ce qui est apres 'p=', on supprime les " et les espaces 
dig +short ${selector}._domainkey.${domain} txt | sed -e 's/^.*p=//' | tr -d \"\ | fold -w 64 >>$filename
echo "$footer" >>$filename

echo "public key saved in $filename"
openssl rsa -pubin -in $filename -noout -text
