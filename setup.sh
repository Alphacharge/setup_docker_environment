#!/bin/bash
#Version 2 from 07.10.23 rbetz
#Aliase from tjensen
#init_script from aguiot

zshrc="$HOME/.zshrc"
bashrc="$HOME/.bashrc"

red="\x01\033[1;31m\x02"
yellow="\x01\033[1;33m\x02"
dgreen="\x01\033[1;32m\x02"
blue="\x01\033[1;34m\x02"
white="\x01\033[0m\x02"
magenta="\x01\033[1;38;2;255;0;255m\x02"
orange="\x01\033[1;38;2;255;165;0m\x02"
cyan="\x01\033[1;38;2;0;255;255m\x02"
purple="\x01\033[1;38;2;128;0;128m\x02"
lgreen="\x01\033[1;38;2;0;255;0m\x02"

# functions
check_configs() {
	echo -en "${yellow}Do you want a backup? [y/N]:${white}"
	read -r backup
	if [ ! -f "$zshrc" ]; then
		touch "$zshrc"
	fi
	if [ ! -f "$bashrc" ]; then
		touch "$bashrc"
	fi
	if [[ "$backup" == "y" ]]
	then
		if [ -f "$zshrc.bck" ]; then
			rm "$zshrc.bck"
		fi
		if [ -f "$bashrc.bck" ]; then
			rm "$bashrc.bck"
		fi
		cp "$zshrc" "$zshrc.bck"
		cp "$bashrc" "$bashrc.bck"
	fi
}
print_end() {
	echo -e "$lgreen"
	echo -en "Installation completed. Enjoy Docker :)"
	echo -e "$white"
	echo -e "Init your Docker now with >${orange}$ali_init${white}<."
	echo -e "Make sure your Docker is running and build your container with >${orange}$ali_build${white}<."
	echo -e "Start the container in your project folder with >${orange}$ali_valgrind${white}<."
}
check_alias() {
	sh="$1"
	rc=$(grep "alias $ali=" "$sh")
	if [[ "$rc" != "" ]]
	then
		echo -e "${red}The alias '$ali' already exists in $sh! You want to overwrite it? [y/N]:${white}"
		read -r overwrite
		if [[ "$overwrite" == "y" ]]
		then
			sed -i "/alias $ali=/d" "$sh"
		fi
	fi
}
create_alias() {
	ali="$1"
	if [[ "$ali" == "" ]]
	then
		ali="$2"
	fi
	check_alias "$zshrc"
	check_alias "$bashrc"
}
insert_alias() {
	sh="$1"
	echo -e "${dgreen}Creating aliases in $sh .....${white}"
	echo "alias $ali_init=\"bash $path/init_docker.sh\"" >> "$sh"
	echo "alias $ali_build=\"docker build -t valgrind - < $path/valgrind\"" >> "$sh"
	echo "alias $ali_valgrind='docker run -ti -v \$PWD:/code -v \"$path/root\":/root valgrind bash'" >> "$sh"
}

check_configs

echo -en "${orange}Please install Docker from the Managed Software Center and press any key if Docker is installed.${white}"
read -r ok

echo -en "${blue}Please enter an alias to init your dockercontainer [di]:${white}"
read -r ali_init
create_alias "$ali_init" "di"
ali_init="$ali"

echo -en "${blue}Please enter an alias to build your dockercontainer [db]:${white}"
read -r ali_build
create_alias "$ali_build" "db"
ali_build="$ali"

echo -en "${blue}Please enter an alias to start your dockercontainer [dv]:${white}"
read -r ali_valgrind
create_alias "$ali_valgrind" "dv"
ali_valgrind="$ali"

echo -en "${magenta}Please enter an absolut path to store your setup [~/.docker_valgrind_setup]:${white}"
read -r path
if [[ "$path" == "" ]]
then
	path="$HOME/.docker_valgrind_setup"
fi

if [ ! -d "$path" ]
then
	mkdir -p "$path"
	mkdir -p "$path/root"
fi

insert_alias "$zshrc"
insert_alias "$bashrc"

echo -en "${cyan}Creating Scripts.....${white}"
cp "./init_docker.sh" "$path/"
cp "./valgrind" "$path/"
cp "./bashrc" "$path/root/.bashrc"

print_end