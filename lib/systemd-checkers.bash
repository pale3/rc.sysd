# some checkers whcih i need to perform before start,stop,status ....

# retrive if unit exist in system
does_unit_exist(){
	
	$_systemctl --no-legend -t ${unit_type:=$UNIT_TYPE_DEFAULT} --no-pager \
		list-unit-files | grep -v static | $(grep ${unit} &> /dev/null ) && \
		echo True || \
		echo False
}

# depends on $(does_unit_exist)
check_service(){
	local unit="$1"
	
	# check if $unit is null
	[[ -z $unit ]] && die -m "Please specify unit name"
	
	#info -a "UNIT: $unit"
	
	# check if specified unit exist
	[[ $(does_unit_exist "$unit") != "True" ]] && \
		die -m "unit $unit does not exist" || \
		return
}

# is_unit_started 
# Return True or False
is_unit_started(){
	local unit="$1"
	
	[[ $( $_systemctl is-active "${unit}" ) == "active" ]] && \
			echo True || echo False
}

# get unit info based on $(is_unit_started)
# get var state=STOPPED|STARTED
# get var onboot=AUTO|""
_get_state_info_(){
	local unit="$1"
	
	[[ $(is_unit_started "$unit") == "True" ]] && \
	state="${G}STARTED${N}" || state="${R}STOPPED${N}"
	
	[[ $(is_unit_enabled "$unit") == "True" ]] && \
	onboot="${W}AUTO${N}" || onboot="    "
}

# get if unit is-enabled 
is_unit_enabled(){
	local unit="$1"
	[[ $($_systemctl is-enabled "$unit") == "enabled" ]] && \
		echo True || echo False
}

# get if unit is-disable
# this function doesn't exist in systemct, I can use is-enabled to 
# determine enabled/disabled but I crete special function for consistency
is_unit_disabled(){
	local unit="$1"
	[[ $($_systemctl is-enabled "$unit") == "disabled" ]] && \
		echo True || echo False
}

# those bellow function are only when list is <action>
# use for listing units
list_started_units(){ 
	local state="$1"
	[[ $state == "${G}STARTED${N}" ]] && return || continue 
}

list_stopped_units(){
	local state="$1"
	[[ $state == "${R}STOPPED${N}" ]] && return || continue 
}

list_failed_units(){
	local	failed=$($_systemctl --failed --no-legend --no-pager -t service | awk '{$2=$3=$4="    "; print $0}')
	
	if ! [[ -z $failed ]]; then
		info -f "Listing ${R}<failed>${N} services:"
		return
	else
		info -n "There is no ${R}<failed>${N} service" && exit 0
	fi
}

get_unit_description(){
	local unit="$1"
	$_systemctl status "$unit" | head -n1 | awk '{$1=$2=$3=""; print $0}'
}
