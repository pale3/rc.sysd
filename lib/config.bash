#which_user(){
#
#if [ -n "$SUDO_USER" -a -z "$SUDO_OK" ]; then
#	echo sudo on
#else 
#	echo no sudo
#	#eval sudo -E $0 "${@}"
#fi
#
#}

source_config(){
# user config allways has pretendan over system wide
#[[ -f $RC_CONFIG_HOME ]] && source $RC_CONFIG_HOME && return 0
	[[ -f $RC_CONFIG_WIDE ]] && source $RC_CONFIG_WIDE && return 0 || \
		die -m  "There is no config ${W}$RC_CONFIG_WIDE${N}"
}


