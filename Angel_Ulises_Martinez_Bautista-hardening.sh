#!/usr/bin/sh
# Scenario:
# 1. Script should be able to indentify if the OS is Ubuntu or CentOS

# 2. It should install clamav antivirus. If the antivirus is already installed
# or running the script should stop and uninstall the software before installing a new one

# 3. Script should install EPEL repositories only for CentOS servers.

# 4. The script sould be capable to update all the packages having and avaible update in
# the repositories

# Resources:
# clamav: https://www.clamav.net/downloads
# EPEL: https://docs.fedoraproject.org/en-US/epel/

# Primero asignar permisos de ejecución en el archivo y luego ejecutarlo tal cual.
# ejetucar chmod +x Angel_Ulises_Martinez_Bautista-hardening.sh
# ./Angel_Ulises_Martinez_Bautista-hardening.sh


if grep debian /etc/os-release 1>/dev/null ; then
	echo "OS = Ubuntu"
	if apt-get list --installed 2>/dev/null | grep clamav 2>/dev/null 1>&2 ; then
		echo "\e[1;36;1m [-] Desinstalando clamav... \e[0m"
		yes '' | sudo apt-get autoremove clamav clamav-daemon 2>/dev/null 1>&2
		clear && echo "\e[1;36;1m [X] Clamav desinstalado. \e[0m"
	fi
	echo "\e[1;36;1m [-] Instalando clamav... \e[0m"
	yes '' | sudo apt-get install clamav clamav-daemon 2>/dev/null 1>&2
	clear && echo "\e[1;36;1m [X] Clamav instalado. \e[0m"

	echo "\e[1;36;1m [-] Actualizando los paquetes... \e[0m"
	yes '' | sudo apt-get update 2>/dev/null 1>&2 && yes '' | sudo apt-get upgrade 2>/dev/null 1>&2
	echo "\e[1;36;1m [X] Paquetes actualizados. \e[0m"

	echo "\e[1;36;1m [X] Operacion terminada. \e[0m"

else
	echo "OS = CentOS"
	if ! yum list installed | grep epel-release 1>/dev/null ; then
		echo -e "\e[1;36;1m [-] Instalando epel-release...\n \e[0m"
		sudo yum -y install epel-release && sudo yum clean all 1>/dev/null
		clear && echo "\e[1;36;1m [X] epel-release instalado. \e[0m"
	fi

	if yum list installed | grep clamav 1>/dev/null ; then
		echo -e "\e[1;36;1m [-] Desinstalando clamav... \e[0m"
		sudo yum -y remove clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd 2>/dev/null 1>&2
		clear && echo -e "\e[1;36;1m [X] Clamav desinstalado. \e[0m"
	fi
	echo -e "\e[1;36;1m [-] Instalando clamav... \e[0m"
	sudo yum -y install clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd 2>/dev/null 1>&2
	clear && echo -e "\e[1;36;1m [X] Clamav instalado. \e[0m"

	echo -e "\e[1;36;1m [-] Actualizando los paquetes... \e[0m"
	sudo yum -y update 1>/dev/null
	echo -e "\e[1;36;1m [X] Paquetes actualizados. \e[0m"
	echo -e "\e[1;36;1m [X] Operacion Terminada. \e[0m"
fi
