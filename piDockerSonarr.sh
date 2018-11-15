#!/bin/bash

echo - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
echo - - - - - - - - - Deploying Sonarr + Deluge + Jackett - - - - - - - - - -
echo - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

SONAR_CONFIG="/home/sonarr/config/"
SONAR_DOWNLOADS="/home/sonarr/downloads/"

IFS=""

function create_directory(){
if [ ! -d "$1" ]; then
        mkdir "$1"
        chown -R sonarr:sonarr "$1"
        if [ -d "$1" ]; then
                echo "-> $1 has been created"
        else
                echo "-> $1 has not been created"
        fi
else
        echo "-> $1 already exist"
fi
}

function verify_sonarr_in_docker_group(){
if groups "sonarr" | grep &>/dev/null '\bdocker\b'; then
    echo "-> User sonarr is correctly in the docker group"
    return 0
else
    echo "-> User sonarr is not in the docker group"
    return 1
fi
}


user=$(cut -d: -f1 /etc/passwd | grep "sonarr")
echo "$user"
if [ "$user" = "sonarr" ];then
	echo "-> User exist"
else
	echo "-> User sonarr don't exist"
	echo "-> Creating user sonarr"
	useradd -m sonarr
	passwd sonarr
fi

if verify_sonarr_in_docker_group;then
    usermod -a -G docker sonarr
    verify_sonarr_in_docker_group

fi

create_directory $SONAR_CONFIG
create_directory $SONAR_DOWNLOADS

read -r -p "is \"$(timedatectl | grep 'Time zone' | cut -d: -f2 | cut -d"(" -f1)\" your timezone ? (y/n) : " tz

if [ "$tz" = "y" ];then
	echo "-> Timezone correctly configured"
else
	echo "nok"
fi

# Check if docker is installed
# Install docker image of "Deluge"
# Install docker image of "Jackett"
# Install docker image of "Sonarr"
