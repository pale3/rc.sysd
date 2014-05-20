# here I will do some systemctl manipulation
inherit systemd-checkers

_systemctl="${SYSTEMCTL:=/usr/bin/systemctl}"

do_service_start(){
	local unit="$1"
	
	$_systemctl start $unit &> /dev/null
	[[ $? -ne 0 ]] && die -m "Failed to start ${W}${unit}${N}. Access denied" || \
	info -n "${W}$unit${N} started (running)" 

}

do_service_stop(){
	local unit="$1"
	
	$_systemctl stop $unit &> /dev/null
	[[ $? -ne 0 ]] && die -m "Failed to stop ${W}${unit}${N}. Access denied" || \
	info -n "${W}$unit${N} stopped (exited)" 

}

do_service_status(){
	local unit="$1"

	_get_state_info_ "$unit"
	write_ad_output "${B}[${N} $onboot ${B}]${N}" "${B}[${N} $state ${B}]${N}" " $unit"
}

do_service_restart(){
	local unit="$1"
	
	$_systemctl restart $unit &> /dev/null
	[[ $? -ne 0 ]] && die -m "Failed to restart ${W}${unit}${N}. Access denied" || \
	info -n "${W}$unit${N} restarted (running)" 
}

do_service_reload(){
	local unit="$1"
	
	$_systemctl reload $unit &> /dev/null
	[[ $? -ne 0 ]] && die -m "Failed to reload ${W}${unit}${N}. Access denied" || \
	info -n "${W}$unit${N} reloaded (running)" 
}

do_service_enable(){
	local unit="$1"
	
	[[ $(is_unit_enabled "$unit") == "True" ]] && die -m "unit $unit already enabled"

	$_systemctl enable $unit &> /dev/null
	[[ $? -ne 0 ]] && die -m "Failed to enable ${W}${unit}${N}. Access denied" || \
	info -n "${W}$unit${N} enabled (onboot)" 

}
do_service_disable(){
	local unit="$1"
	
	[[ $(is_unit_disabled "$unit") == "True" ]] && die -m "unit $unit already disabled"
	
	$_systemctl disable $unit &> /dev/null
	[[ $? -ne 0 ]] && die -m "Failed to disabled ${W}${unit}${N}. Access denied" || \
	info -n "${W}$unit${N} disabled (onboot)" 

}

do_service_list(){
	local ignore

#	if [[ $IGNORE_STATIC_STATE == "yes" ]]; then
#			ignore="static|\\"
#	fi

	if ! [[ -z "${HIDEDAEMONS[@]}" ]]; then
		HIDEDAEMONS="static|\\${HIDEDAEMONS[@]}" 
		ignore=${HIDEDAEMONS// /\|\\}
	else	
		HIDEDAEMONS=(static)
		ignore=$HIDEDAEMONS
	fi	 
	
	(( $VERBOSE )) &&	die -m "There is no --verbose flag in action: ${W}$action${N}"

	(( $FAILED )) && list_failed_units && \
			info -n "${failed}" && exit 0

	while read -r unit onboot; do
		
		# if unit has in name @ ignore it
		[[ $unit =~ @ ]] && continue

		(( $INFO )) && dsc=$(get_unit_description "$unit" )

		[[ $(is_unit_started "$unit") == "True" ]] && \
			state="${G}STARTED${N}" || state="${R}STOPPED${N}"

		[[ $onboot == "disabled" ]] && onboot="    "
		[[ $onboot == "enabled" ]] && onboot="${W}AUTO${N}"
	
		(( $STARTED )) && list_started_units "$state"
		(( $STOPPED )) && list_stopped_units "$state"

		# read var from conf file and determine view behavior
		[[ $IGNORE_UNIT_SUFFIX == "yes" ]] && \
			unit=${unit/.${unit_type:=$UNIT_TYPE_DEFAULT}/}
		
		output_align "$unit"

		write_ad_output "${B}[${N} $onboot ${B}]${N}" "${B}[${N} $state ${B}]${N}" " $unit" "${W}${dsc}${N}"
		
	done < <($_systemctl --no-legend --no-pager -t ${unit_type:=$UNIT_TYPE_DEFAULT} list-unit-files | \
					grep -Ev "${ignore}" )

# if verbose show us some details
#	(( $VERBOSE )) &&
#		 info -i "Hidden services: ${#HIDEDAEMONS[@]}" && \
#		 info -i "Started services: "

}
