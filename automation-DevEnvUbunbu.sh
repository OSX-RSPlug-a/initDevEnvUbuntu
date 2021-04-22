#!/bin/bash

if [[ "${UID}" -ne 0 ]]
then
 echo 'Must execute with sudo or root' >&2
 exit 1
fi

# update
sudo apt-get update -y 

# Upgrade
sudo apt-get upgrade -y

# Install ur packs essentials
sudo apt-get install openssh-server netdata zip p7zip-full net-tools speedtest-cli build-essential autoconf m4 libncurses5-dev libwxgtk3.0-gtk3-dev libgl1-mesa-dev libglu1-mesa-dev libpng-dev libssh-dev unixodbc-dev xsltproc fop libxml2-utils libncurses-dev openjdk-11-jdk checkinstall libssl-dev python3-pip golang gnome-disk-utility neofetch -y


# Enable Firewall
sudo ufw enable 

# configure the firewall 
sudo ufw allow OpenSSH
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow OpenSSH
sudo ufw allow ssh
sudo ufw allow 22/tcp


# Disabling root login 
echo "PermitRootLogin no" >> /etc/ssh/sshd_config 
echo "PermitEmptyPasswords no" /etc/ssh/sshd_config


# Fail2Ban install 
sudo apt-get install -y fail2ban
sudo systemctl start fail2ban
sudo systemctl enable fail2ban

echo "
[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 4
" >> /etc/fail2ban/jail.local


# Install nodejs v14XXX
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt update -y
sudo apt install node -y

# Install npm pack
sudo apt install npm -y

# Install nvm pack
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

# Install Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update -y
sudo apt install --no-install-recommends yarn -y
  
# Install clojure pack
sudo apt install clojure -y

# Install sdkman pack - sdkman its java tooling
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"  

# Install elixir
sudo apt install install esl-erlang erlang-debugger erlang-dev elixir -y

# Install VCode
sudo snap install code --classic -y

# Install Insomnia
sudo snap install insomnia -y


# Docker optionional install 
echo "
######################################################################################################
Do you want to install docker? If so type y / If you dont want to install enter n
######################################################################################################
"
read $docker

if [[ $docker -eq "y" ]] || [[ $docker -eq "yes" ]]; then
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    sudo apt-get update -y
    apt-cache policy docker-ce
    sudo apt install docker-ce -y
    sudo apt-get install docker-compose -y 

   
    echo "
#####################################################################################################    
                            Congrats Docker has been installed
######################################################################################################
"
    docker -v

else 
    echo "Docker was not installed"
 
fi

# add user to docker group to use
sudo usermod -aG docker $USER

# Cleanup
sudo apt autoremove
sudo apt clean 

sudo reboot

exit 0
