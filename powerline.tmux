#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

powerline_left="#($CURRENT_DIR/powerline.tmux left)"
powerline_right="#($CURRENT_DIR/powerline.tmux right)"
powerline_mute_left="#($CURRENT_DIR/mute_powerline.tmux left)"
powerline_mute_right="#($CURRENT_DIR/mute_powerline.tmux right)"

source "${CURRENT_DIR}/scripts/shared.sh"

export TMUX_POWERLINE_DIR_HOME="$(dirname $0)"

source "${TMUX_POWERLINE_DIR_HOME}/config/helpers.sh"
source "${TMUX_POWERLINE_DIR_HOME}/config/paths.sh"
source "${TMUX_POWERLINE_DIR_HOME}/config/shell.sh"
source "${TMUX_POWERLINE_DIR_HOME}/config/defaults.sh"

source "${TMUX_POWERLINE_DIR_LIB}/arg_processing.sh"
source "${TMUX_POWERLINE_DIR_LIB}/formatting.sh"
source "${TMUX_POWERLINE_DIR_LIB}/muting.sh"
source "${TMUX_POWERLINE_DIR_LIB}/powerline.sh"
source "${TMUX_POWERLINE_DIR_LIB}/rcfile.sh"

do_interpolation() {
	local string="$1"
	local interpolated="${string/$online_status_interpolation_string/$online_status_icon}"
	echo "$interpolated"
}

update_tmux_option() {
	local option="$1"
	local option_value="$(get_tmux_option "$option")"
	local new_option_value="$(do_interpolation "$option_value")"
	set_tmux_option "$option" "$new_option_value"
}

main() {
	if [[ -n "$1" ]]; then
		if ! powerline_muted "$1"; then
			process_settings
			check_arg_side "$1"
			print_powerline "$1"
		fi
	else
		update_tmux_option "status-right"
		update_tmux_option "status-left"
	fi
}
main "$1"
