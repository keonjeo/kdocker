#!/bin/bash

set -e

# Default settings
ZSH=${ZSH:-~/.oh-my-zsh}

# Other options
CHSH=${CHSH:-yes}
RUNZSH=${RUNZSH:-yes}


command_exists() {
	command -v "$@" >/dev/null 2>&1
}

error() {
	echo ${RED}"Error: $@"${RESET} >&2
}

setup_color() {
	# Only use colors if connected to a terminal
	if [ -t 1 ]; then
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		YELLOW=$(printf '\033[33m')
		BLUE=$(printf '\033[34m')
		BOLD=$(printf '\033[1m')
		RESET=$(printf '\033[m')
	else
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		BOLD=""
		RESET=""
	fi
}

setup_shell() {
	# Skip setup if the user wants or stdin is closed (not running interactively).
	if [ $CHSH = no ]; then
		return
	fi

	# If this user's login shell is already "zsh", do not attempt to switch.
	if [ "$(basename "$SHELL")" = "zsh" ]; then
		return
	fi

	# If this platform doesn't provide a "chsh" command, bail out.
	if ! command_exists chsh; then
		cat <<-EOF
			I can't change your shell automatically because this system does not have chsh.
			${BLUE}Please manually change your default shell to zsh${RESET}
		EOF
		return
	fi

	echo "${BLUE}Time to change your default shell to zsh:${RESET}"

	# Check if we're running on Termux
	case "$PREFIX" in
		*com.termux*) termux=true; zsh=zsh ;;
		*) termux=false ;;
	esac

	if [ "$termux" != true ]; then
		# Test for the right location of the "shells" file
		if [ -f /etc/shells ]; then
			shells_file=/etc/shells
		elif [ -f /usr/share/defaults/etc/shells ]; then # Solus OS
			shells_file=/usr/share/defaults/etc/shells
		else
			error "could not find /etc/shells file. Change your default shell manually."
			return
		fi

		# Get the path to the right zsh binary
		# 1. Use the most preceding one based on $PATH, then check that it's in the shells file
		# 2. If that fails, get a zsh path from the shells file, then check it actually exists
		if ! zsh=$(which zsh) || ! grep -qx "$zsh" "$shells_file"; then
			if ! zsh=$(grep '^/.*/zsh$' "$shells_file" | tail -1) || [ ! -f "$zsh" ]; then
				error "no zsh binary found or not present in '$shells_file'"
				error "change your default shell manually."
				return
			fi
		fi
	fi

	# We're going to change the default shell, so back up the current one
	if [ -n "$SHELL" ]; then
		echo $SHELL > ~/.shell.pre-oh-my-zsh
	else
		grep "^$USER:" /etc/passwd | awk -F: '{print $7}' > ~/.shell.pre-oh-my-zsh
	fi

	# Actually change the default shell to zsh
	if ! chsh -s "$zsh"; then
		error "chsh command unsuccessful. Change your default shell manually."
	else
		export SHELL="$zsh"
		echo "${GREEN}Shell successfully changed to '$zsh'.${RESET}"
	fi

	echo
}

main() {
	setup_color

	if ! command_exists zsh; then
		echo "${YELLOW}Zsh is not installed.${RESET} Please install zsh first."
		exit 1
	fi

	setup_shell

	printf "$GREEN"
	cat <<-'EOF'
		         __                                     __
		  ____  / /_     ____ ___  __  __   ____  _____/ /_
		 / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \
		/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / /
		\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/
		                        /____/                       ....is now installed!
		Please look over the ~/.zshrc file to select plugins, themes, and options.
		p.s. Follow us on https://twitter.com/ohmyzsh
		p.p.s. Get stickers, shirts, and coffee mugs at https://shop.planetargon.com/collections/oh-my-zsh
	EOF
	printf "$RESET"

	if [ $RUNZSH = no ]; then
		echo "${YELLOW}Run zsh to try it out.${RESET}"
		exit
	fi

	echo "export ZSH_DISABLE_COMPFIX=true" >> ~/.zshrc
	exec zsh -l
}

main "$@"