# define colors 
# end colors

if [[ $USE_COLORS == "no" ]] || (( $NOCOLOR )); then
R="$(tput sgr0)"
G="$(tput sgr0)"
B="$(tput sgr0)"
W="$(tput sgr0)"
Y="$(tput sgr0)"
y="$(tput sgr0)"
g="$(tput sgr0)"
N="$(tput sgr0)"
else
R="$(tput bold)$(tput setaf 1)"
G="$(tput bold)$(tput setaf 2)"
B="$(tput bold)$(tput setaf 4)"
W="$(tput bold)$(tput setaf 7)"
Y="$(tput bold)$(tput setaf 3)"
y="$(tput setaf 3)"
g="$(tput setaf 2)"
N="$(tput sgr0)"
fi
