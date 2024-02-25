#/bin/bash

echo -e " $(tput setaf 1) $(tput bold)Removing Old Docker$(tput sgr0) $(tput sgr 0) \n"
sleep 0.3


echo -ne 'Progress ====>                     (33%)\r'
sleep 0.3
echo -ne 'Progress =============>            (66%)\r'
sleep 0.3
echo -ne "Progress ========================> (100%)\r"
echo -ne '\n'

sudo apt-get purge docker-ce docker-ce-cli -y &> /dev/null
echo -e "\n $(tput setaf 1) $(tput bold)Removing Old Docker-Compose$(tput sgr0) $(tput sgr 0)\n"

echo -ne 'Progress ====>                     (33%)\r'
sleep 0.3
echo -ne 'Progress =============>            (66%)\r'
sleep 0.3
echo -ne "Progress ========================> (100%)\r"
echo -ne '\n'

sudo rm -rf $(which docker-compose)

echo -e "\n $(tput setaf 1) $(tput bold)Removing Docker-compse binaries...$(tput sgr0) $(tput sgr 0) \n"
echo -ne 'Progress ====>                     (33%)\r'
sleep 0.3
echo -ne 'Progress =============>            (66%)\r'
sleep 0.3
echo -ne "Progress ========================> (100%)\r"
echo -ne '\n'

echo -ne '\n'
echo -e "\n $(tput setaf 1) $(tput bold)Installing Docker-CE $(tput sgr0) $(tput sgr 0)\n"
sleep 0.3
echo -e "\n $(tput setaf 1) $(tput bold)Updating Linux packages $(tput sgr0) $(tput sgr 0)\n"

echo -ne 'Progress ====>                     (33%)\r'
sleep 0.3
echo -ne 'Progress =============>            (66%)\r'
sleep 0.3
sudo apt-get update -y &> /dev/null
sudo apt-get install  \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y &> /dev/null
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &> /dev/null
sudo add-apt-repository -y \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" &> /dev/null
sudo apt-get update -y &> /dev/null
sudo apt-get install docker-ce docker-ce-cli containerd.io -y &> /dev/null
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

echo -ne "Progress ========================> (100%)\r"
echo -ne '\n'
#sudo su ubuntu
echo -e "\n $(tput setaf 1) $(tput bold)DOCKER-CE INSTALLED !!!$(tput sgr0) $(tput sgr 0) \n"
sleep 0.3
echo -e "\n $(tput setaf 1) $(tput bold)Installing Docker-Compose...$(tput sgr0) $(tput sgr 0)\n "

echo -ne 'Progress ====>                     (33%)\r'
sleep 0.3
echo -ne 'Progress =============>            (66%)\r'
sleep 0.3
echo -ne "Progress ========================> (100%)\r"
echo -ne '\n'
#OLD METHOD
#sudo curl -sL "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
#sudo chmod +x /usr/local/bin/docker-compose &> /dev/null
sudo apt-get install docker-compose-plugin -y &> /dev/null
sleep 0.3
echo -e "\n $(tput setaf 1) $(tput bold)DOCKER & DOCKER-COMPOSE Installed Successfuly!!!$(tput sgr0) $(tput sgr 0)\n"
#sudo su ubuntu
sudo su $(whoami)
sudo docker -v
sudo docker compose version
