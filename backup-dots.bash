#!/bin/bash

## All locations of my config files, you can also reference directories
# NOTE: This structure can only be relevant for RHEL (or Fedora) systems. 
declare -a configLocations=(
	"$HOME/.config/nvim/init.lua" 	# Neovim Configuration
)

## The index in the locations list will match with the repo storeLocation
declare -a repoLocationMapping=(
	"./dotfiles/neovim/"		# Neovim Configuration
)

file_location_handler () {
	echo "$(dirname $1)"
}

run_backup() {
	if [ ! -d "./dotfiles" ]
	then
		echo "Directory \"dotfiles\" does not exist, creating blank directory"
		mkdir dotfiles
	fi

	for ((i=0; i < ${#configLocations[@]}; i++))
	do
		cfg_location=${configLocations[$i]}
		repo_location=${repoLocationMapping[$i]}
	
		target_copy_loocation="$repo_location""$(basename "$cfg_location")"
	
		echo 
		echo "COPYING CONFIG FOR: " $(basename $(dirname $cfg_location)) " TO: " $target_copy_loocation
		cp $cfg_location $target_copy_loocation
	done

}




# Main script

# Run the backup if no arguemnts are passed
if [$# -eq 0]; then
	echo -e "Copying all configs located on this machine. \nIf you want to upload a NEW config location, enter the command:"
	echo -e "\n./backup-dots.bash --new <file_location> <repo_directory_location>\n"

	run_backup

	exit 1
fi

# 
backup_new_file=false

while [[ $# -gt 0 ]]; do
	case $1 in
		-n|--new)
			backup_new_file=true
			shift
			;;
		*)
			if [ -z $file_location" ]; then
			elif

			else
			fi
			shift;;
	esac
done


