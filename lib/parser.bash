# represent op paraser here
# mislim da mi ovo tu e treba jer 
# prosljedujem samo #1 argument [start,stop...]

for opt in ${args[@]:1}; do
	case ${opt} in
		--verbose ) VERBOSE=1 ;;
		--failed  ) FAILED=1 ;;
		--started ) STARTED=1 ;;
		--stopped ) STOPPED=1 ;;
		--nocolor ) NOCOLOR=1 ;;
		--info    ) INFO=1 ;;
		--masked  ) MASKED=1 ;;
	  --all     ) ALL=1; unit_type="service,mount,device,socket,target,path,timer" ;;
	service|mount|device|socket|target|path|timer) unit_type="${opt}" ;;
					--* ) die -m "no such flag ${R}$opt${N}" ;;
	esac
	shift
done

# dont allow mixing some flags
(( ( $STARTED || $STOPPED ) && $FAILED )) && die -m "Not possible to mix $B(${N} ${Y}--started, --stopped, --failed $B)${N} flag"
