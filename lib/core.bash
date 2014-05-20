# die [-q] "Message" PUBLIC
die(){
	local m="" q=""
	# m = with message
	# q = quite(no message)
	
	[[ ${1} == "-m" ]] && echo "${R}!!! Err:${N}${@/${1}}" && exit 254
	[[ ${1} == "-q" ]] && exit 255;
}

# inherit module PUBLIC
# Sources a given eselect library file
inherit() {
	local x
	for x in "$@"; do
		[[ -e "${RC_LIB_PATH}/${x}.bash" ]] \
			|| die "Couldn't find ${x}.bash"
		source "${RC_LIB_PATH}/${x}.bash" \
			|| die "Couldn't source ${x}.bash"
	done
}

