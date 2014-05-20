info(){
	local i="$1"
	case $i in
		-n ) printf "%s\n" " ::: $2" ;;
		-i ) printf "%s\n" "  ${G}*${N}  $2" 	;; 
		-f ) printf "%s\n" "  ${R}*${N}  $2" 	;; 
		-a ) printf "%s\n" " >>> $2" ;; 
	esac
}
# ovo je ako ne budem koristion --info i odlucim se da ga maknem
# onda moram i outpu_align maknut i (( INFO ))
#write_ad_output(){ 
#	local action=${1} onboot=${2} state=${3}
#	#printf "%s%-${indent}s%s%s\n" "  ${action}" "" "${onboot}" "${state}"
#	printf "%s%s%s\n" " ${action}" "${onboot}" "${state}"
#	return 0
#}

output_align(){
	local action="${#1}" space=10 lcolumn=25
	indent=$( expr $lcolumn - $action + $space )
}

write_ad_output(){ 
	local action=${1} onboot=${2} state=${3} dsc=${4}
	printf "%s%s%s%-${indent}s%s\n" " ${action}" "${onboot}" "${state}" "" "$dsc"
	return 0
}

