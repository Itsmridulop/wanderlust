#!/bin/bash

set -e  # Exit on any error

# 🔵 Color helpers
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}--- Jenkins Installation Script ---${NC}"

# 🔧 Confirm Java Installation
read -p "Do you want to install OpenJDK 11? (y/n): " install_java
if [[ "$install_java" == "y" ]]; then
  echo -e "${GREEN}Installing OpenJDK 11...${NC}"
  sudo apt update || { echo -e "${RED}Failed to update packages.${NC}"; exit 1; }
  sudo apt install -y openjdk-11-jdk || { echo -e "${RED}Failed to install OpenJDK.${NC}"; exit 1; }
else
  echo -e "${RED}Skipping Java installation. Make sure it's already installed!${NC}"
fi

# 🔧 Add Jenkins Key and Repo
echo -e "${GREEN}Adding Jenkins GPG key and repository...${NC}"
if curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null; then
  echo -e "${GREEN}Key added.${NC}"
else
  echo -e "${RED}Failed to add Jenkins key.${NC}"
  exit 1
fi

if echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null; then
  echo -e "${GREEN}Repository added.${NC}"
else
  echo -e "${RED}Failed to add Jenkins repository.${NC}"
  exit 1
fi

# 🔄 Update and Install Jenkins
echo -e "${GREEN}Updating package list...${NC}"
sudo apt update

read -p "Do you want to install Jenkins now? (y/n): " install_jenkins
if [[ "$install_jenkins" == "y" ]]; then
  echo -e "${GREEN}Installing Jenkins...${NC}"
  sudo apt install -y jenkins || { echo -e "${RED}Failed to install Jenkins.${NC}"; exit 1; }

  # 🔁 Start and Enable Jenkins
  echo -e "${GREEN}Starting and enabling Jenkins service...${NC}"
  sudo systemctl start jenkins || { echo -e "${RED}Failed to start Jenkins.${NC}"; exit 1; }
  sudo systemctl enable jenkins || { echo -e "${RED}Failed to enable Jenkins.${NC}"; exit 1; }
  echo -e "${GREEN}Jenkins Installed Successfully:${NC}"
  echo -e "Passkey: $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)"


else
  echo -e "${RED}Jenkins installation skipped.${NC}"
fi
