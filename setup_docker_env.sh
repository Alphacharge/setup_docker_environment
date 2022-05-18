#!/bin/bash
#Version 1 from 18.05.22 rbetz
#Aliase from tjensen
#init_script from aguiot

zshrc="$HOME/.zshrc"

read -p $'\e\033[0;32mPlease install Docker from the Managed Software Center and press any key if Docker is running.\e\033[0m' docker

read -p $'\e\033[0;32mPlease enter an Alias to init your Docker Container a.e. "docker_init":\e\033[0m' ali_ini
if [[ $ali_init == "" ]]
then
	ali_init="docker_init"
fi
docker=$(grep "$ali_init" $zshrc)
if [[ "$docker" != "" ]]
then
	echo "This Alias already exist!!"
else
	echo "Alias is now:$ali_init"
fi

read -p $'\e\033[0;32mPlease enter an Alias to build your Docker Container a.e. "docker_build":\e\033[0m' ali_build
if [[ $ali_build == "" ]]
then
        ali_build="docker_build"
fi
docker=$(grep "$ali_build" $zshrc)
if [[ "$docker" != "" ]]
then
        echo "This Alias already exist!!"
else
	echo "Alias is now:$ali_build"
fi

read -p $'\e\033[0;32mPlease enter an Alias to start your Valgrind Docker Container a.e. "docker_valgrind":\e\033[0m' ali_valgrind
if [[ $ali_valgrind == "" ]]
then
        ali_valgrind="docker_valgrind"
fi
docker=$(grep "$ali_valgrind" $zshrc)
if [[ "$docker" != "" ]]
then
        echo "This Alias already exist!!"
else
        echo "Alias is now:$ali_valgrind"
fi

read -p $'\e\033[0;32mPlease enter a Path to store your Setup a.e. "~/Documents/docker_valgrind_setup":\e\033[0m' path
if [[ "$path" == "" ]]
then
        path="$HOME/Documents/docker_valgrind_setup"
	echo "path is now:$path"
fi

if [ ! -d "$path" ]
then
	mkdir "$path"
	mkdir "$path/root"
else
	echo "Path already exist!"
fi

read -p $'\e\033[0;32mPress Enter to continue or "a" to abort the programm.\e\033[0m' docker
if [[ $docker == "a" ]]
then
	exit 1
fi

echo -e '\033[0;33mCreating Aliase in ZSH.....\033[0m'
echo "alias $ali_init=\"bash $path/init_docker.sh\"" >> $zshrc
echo "alias $ali_build=\"docker build -t valgrind - < $path/valgrind\"" >> $zshrc
echo "alias $ali_valgrind='docker run -ti -v \$PWD:/code -v \"$path/root\":/root valgrind bash'" >> $zshrc
source $zshrc

echo -e '\033[0;33mCreating Scripts.....\033[0m'
cp "$PWD/init_docker.sh" "$path/"
cp "$PWD/valgrind" "$path/"

echo -e '\033[0;33mBuilding your first Container.....\033[0m'
bash "$path/init_docker.sh"
docker build -t valgrind - < "$path/valgrind"

echo "Installation completed. Enjoy Docker :)"
