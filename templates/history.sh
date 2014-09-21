function h () {
	re='^[0-9]+$'
	if [[  $1 =~ $re ]]; then
		echo "History (last $1):"
	 	history $1 | grep -v "h $1"
	 elif [[ -z "$1" ]]; then
		echo "History (all):"
	 	history 
	 else
	 	echo "History (filtered by '$1')"
	 	history | grep -v "h " | grep $1
	fi
}