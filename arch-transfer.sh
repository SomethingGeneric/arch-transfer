#!/usr/bin/env bash

check() {
	sudo pacman -Q | awk '{print $1}' | grep ${1}
	return $?
}


if [[ "$1" == "save" ]]; then
	if ! [ -x "$(command -v nc)" ]; then
		echo "Installing netcat"
		sudo pacman -S --noconfirm openbsd-netcat
	fi
	if ! [ -x "$(command -v awk)" ]; then
		echo "Installing awk"
		sudo pacman -S --noconfirm awk
	fi
	sudo pacman -Q | awk '{print $1}' | nc termbin.com 9999
	echo "Make sure to save the above URL for the other machine"
	exit 0
elif [[ "$1" == "restore" ]]; then
	if ! [ -x "$(command -v curl)" ]; then
		echo "Installing curl"
		sudo pacman -S --noconfirm curl
	fi
	printf "Termbin url: "
	read URL
	for pkg in $(curl $URL); do
		check "${pkg}"
		if [[ "$?" == "1" ]]; then
			echo "Don't have ${pkg}"
			ame --noconfirm ins $pkg
		fi
	done
else
	echo "Usage: ./arch-transfer.sh <mode> [args]"
	echo "Mode 'save' takes no args"
	echo "Mode 'restore' takes a url to the termbin dump from a 'save'"
fi
