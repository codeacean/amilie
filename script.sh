#!/bin/bash

# colors

RED='\033[0;31m'
GREEN='\033[0;92m'
BLUE='\033[0;94m'
NC='\033[0m'

echo -e "${GREEN}Script running...${NC}"
sleep 1

menu=$(gum choose \
	"Setup" "Install" \
	--header "What would you like to install?")

if [[ $menu == "Setup" ]]; then
	echo "You choose -> $option"
elif [[ $menu == "Install" ]]; then
	option=$(gum choose \ "Manually" "Search package" \ --header "Choose your prefered option")
	if [[ $option == "Manually" ]]; then
		echo -e "${BLUE}Installing packages manually!${NC}"
		echo -e -p "Input one or many packages name:" install_package
	elif [[ $option == "Search package" ]]; then
		install_package=$(gum filter --no-limit \
			"base-devel" "neovim" "jq" "quickshell" "gcc" "vim" "fuse2" "cmake" \
			--header "Select a packages: ")
	fi

	echo -e "${BLUE}You selected $install_package${NC}"
	sudo pacman -S $install_package --needed
fi
