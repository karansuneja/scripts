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

## install localstack
sleep 0.3


echo -e "\n $(tput setaf 1) $(tput bold)Setting up LocalStack...$(tput sgr0) $(tput sgr 0) \n"
sudo chown -R $(whoami):$(whoami) /opt
cd /opt
mkdir localstack && cd localstack
Docker pull localstack/localstack:latest

echo -ne 'Progress ====>                     (33%)\r'
sleep 0.3
cat <<EOF > docker-compose.yml
services:
  localstack:
    container_name: "${LOCALSTACK_DOCKER_NAME:-localstack-main}"
    image: localstack/localstack
    ports:
      - "4566:4566"            # LocalStack Gateway
      - "4510-4559:4510-4559"  # external services port range
    environment:
      - SERVICES=s3,lambda,ec2
      - DEBUG=1
      - AWS_DEFAULT_REGION=us-east-1
      - LAMBDA_EXECUTOR=docker
      - DOCKER_HOST=unix:///var/run/docker.sock
    volumes:
      - "./volume:/var/lib/localstack"
      - "/var/run/docker.sock:/var/run/docker.sock"
    restart: always
EOF

echo "docker-compose.yml created successfully"
docker compose up -d
sleep 0.3


echo -ne 'Progress =============>            (66%)\r'
sleep 0.3
echo -ne "Progress ========================> (100%)\r"
echo -ne '\n'

echo -e "\n $(tput setaf 1) $(tput bold)Localstack Ready !!!$(tput sgr0) $(tput sgr 0) \n"

docker compose ps

sleep 0.3


## install AWS CLI
sleep 0.3
echo -e "\n $(tput setaf 1) $(tput bold)Installing AWS CLI...$(tput sgr0) $(tput sgr 0) \n"
cd /tmp



echo -ne 'Progress ====>                     (33%)\r'
sleep 0.3
sudo apt install zip unzip

unzip awscliv2.zip
echo -ne 'Progress =============>            (66%)\r'
sleep 0.3
sudo ./aws/install
echo -ne "Progress ========================> (100%)\r"
echo -ne '\n'
sleep 0.3

ALIAS_FILE="/etc/profile.d/custom-aliases.sh"

cat <<'EOF' > "$ALIAS_FILE"
# Global aliases for all users

alias aws="AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test aws --endpoint-url=http://localhost:4566"
EOF

chmod 644 "$ALIAS_FILE"


echo -e "\n $(tput setaf 1) $(tput bold)AWS CLI INSTALLED !!!$(tput sgr0) $(tput sgr 0) \n"


## install terraform
sleep 0.3
cd /tmp

echo -e "\n $(tput setaf 1) $(tput bold)Installing Terraform...$(tput sgr0) $(tput sgr 0) \n"

sudo apt-get install -y gnupg software-properties-common

echo -ne 'Progress ====>                     (33%)\r'
sleep 0.3

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \

sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

echo -ne 'Progress =============>            (66%)\r'
sleep 0.3

sudo apt-get install terraform
echo -ne "Progress ========================> (100%)\r"
echo -ne '\n'
sleep 0.3

echo -e "\n $(tput setaf 1) $(tput bold)TERRAFORM INSTALLED !!!$(tput sgr0) $(tput sgr 0) \n"


echo -e "\n $(tput setaf 1) $(tput bold)Initializing Terraform...$(tput sgr0) $(tput sgr 0) \n"
echo -ne 'Progress ====>                     (33%)\r'
sleep 0.3

cd /opt && mkdir terraform && cd terraform

cat <<EOF > provider.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  s3_use_path_style = true

  endpoints {
    apigateway     = "http://localhost:4566"
    apigatewayv2   = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    es             = "http://localhost:4566"
    elasticache    = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    rds            = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    route53        = "http://localhost:4566"
    s3             = "http://localhost:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
}

EOF

echo -ne 'Progress =============>            (66%)\r'
sleep 0.3

terraform init

echo -ne "Progress ========================> (100%)\r"
echo -ne '\n'

echo -e "\n $(tput setaf 1) $(tput bold)TERRAFORM INITIALIZED !!!$(tput sgr0) $(tput sgr 0) \n"


# install minikube

echo -e "\n $(tput setaf 1) $(tput bold)Installing Minikube...$(tput sgr0) $(tput sgr 0) \n"
echo -ne 'Progress ====>                     (33%)\r'
sleep 0.3

curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64

echo -ne 'Progress =============>            (66%)\r'
sleep 0.3


minikube start 


echo -ne "Progress ========================> (100%)\r"
echo -ne '\n'

echo -e "\n $(tput setaf 1) $(tput bold)MINIKUBE READY !!!$(tput sgr0) $(tput sgr 0) \n"


# install kubectl
echo -e "\n $(tput setaf 1) $(tput bold)Installing kubectl...$(tput sgr0) $(tput sgr 0) \n"
echo -ne 'Progress ====>                     (33%)\r'
sleep 0.3

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo -ne 'Progress =============>            (66%)\r'
sleep 0.3



echo -ne "Progress ========================> (100%)\r"
echo -ne '\n'

echo -e "\n $(tput setaf 1) $(tput bold)KUBECTL  INSTALLED !!!$(tput sgr0) $(tput sgr 0) \n"

echo -ne '\n'
echo -ne '\n'
echo -ne '\n'
echo -e "\n $(tput setaf 1) $(tput bold)STACK IS INSTALLED AND READY TO USE !!!$(tput sgr0) $(tput sgr 0) \n"
