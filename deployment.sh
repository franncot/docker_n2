#!/bin/bash

#Variables de colores
red="\e[0;91m"
green="\e[0;92m"
bold="\e[1m"
reset="\e[0m"
REPO="docker_n2"

#Priviledges not require on the AWS EC2 instance
#if [ "$EUID" -ne 0 ]; then
#    echo -e "${red}${bold}Este script requiere priviledgios de administrador para ser ejecutado. Por favor usa Sudo o Root. ☒ ${reset}"
#    exit 1
#fi

#Check if repo exist
if [ -d "$REPO/.git" ]; then
     echo -e "${green}${bold}El repositorio FullStack topics ya existe, realizando git pull...${reset}"
     cd $REPO
     git pull >/dev/null 2>&1
     echo -e "${green}${bold}Pull completado - Listo ☑ ${reset}"
else
     echo -e "${red}${bold}Clonando el repositorio, por favor espera... ☒ ${reset}"
     git clone https://github.com/franncot/$REPO.git >/dev/null 2>&1
     cd $REPO
     echo -e "${green}${bold}Repo Clonado -  Listo ☑ ${reset}"
fi

#Update
sudo apt update >/dev/null 2>&1

#Installing docker newest version
if dpkg -s docker-ce >/dev/null 2>&1; then
        echo -e "${green}${bold}$component instalado ☑ ${reset}"
        echo
    else
        echo -e "${red}${bold}$component no instalado ☒ instalación en progreso...${reset}"
        echo
        curl -fsSL https://get.docker.com -o install-docker.sh
        chmod +x install-docker.sh
        sh install-docker.sh >/dev/null 2>&1;
        echo -e "${green}${bold}$component instalación completa ☑ ${reset}"
        echo	
fi

#Discord notification
send_discord_notification() {
    DISCORD="https://discord.com/api/webhooks/1154865920741752872/au1jkQ7v9LgQJ131qFnFqP-WWehD40poZJXRGEYUDErXHLQJ_BBszUFtVj8g3pu9bm7h"
    MESSAGE="Tu Ambiente esta listo!. Puedes validar en http://localhost:5000/api/topics"

    curl -X POST -H "Content-Type: application/json" \
         -d '{
           "content": "'"${MESSAGE}"'"
         }' "$DISCORD" 
}


# Function to check if the application is running or Docker-compse need to run
check_application() {
    local response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)
    if [ "$response" -eq 200 ]; then
        echo -e "${green}${bold}Aplicación 295 Full Stack topics ya esta instalada y lista para su uso - Listo  ☑ ${reset}"
        exit 0
    else
        echo -e "${red}${bold}Aplicacion no instalada. Iniciando Docker Compose...☒ Deployment en progreso...${reset}"
        cd  $REPO >/dev/null 2>&1
        docker compose up -d >/dev/null 2>&1
        sleep 5
        echo -e "${green}${bold}Todos los container inicializados puedes probar el ambiente con curl http://localhost:5000/api/topics  - Listo  ☑ ${reset}"
        sleep 5
        send_discord_notification
    fi
}

check_application