# usage: ./multiply <nr> <pcap_file>
# adds pcap_file at the end of itself <n> times
nb="$1"
filename="$2"
file_out="result.pcapng"
file_in="$filename"
file_tmp="tmp.pcapng"

# start time ne changera pas
start_time=$(capinfos -aeS "$file_in" | grep '^First' | tr -dc '[0-9,]' | cut -d, -f1 )
i=0
while [ $i -lt "$nb" ] ; do
	output=$(capinfos -aeS "$file_in")
	# start_time=$(echo "$output" | grep '^First' | tr -dc '[0-9,]' | cut -d, -f1)
	end_time=$(echo "$output" | grep '^Last' | tr -dc '[0-9,]' | cut -d, -f1)

	# echo "start: $start_time"
	# echo "end: $end_time"


	# marche pour 1 
	offset=$(expr $end_time + 1 - $start_time)

	editcap -t "$offset"  "$filename" -  | mergecap "$file_in" - -w "$file_out"

	cp "$file_out" "$file_tmp"
	file_in="$file_tmp"
	i=$(expr $i + 1)
done

rm "$file_tmp"
echo "result in $file_out"
	
