#!/bin/bash

dir=`dirname $0`
host=$1
login="root@$host"
user="${2:-`whoami`}"

function create_user {
  echo
  echo "* Creating the user '$user' on $host *"
  echo

  # The host key might change when we instantiate a new VM, so
  # we remove (-R) the old host key from known_hosts
  ssh-keygen -R "${login#*@}" 2> /dev/null

  ssh -oStrictHostKeyChecking=no "$login" "
    useradd --create-home $user;
    cd /home/$user &&
    echo \"%$user ALL=NOPASSWD: ALL\" > /etc/sudoers.d/$user &&

    mkdir -p .ssh &&
    echo \"`cat ~/.ssh/id_rsa.pub`\" > .ssh/authorized_keys &&

    chown $user /home/$user &&
    chown $user /home/$user/.ssh &&
    chown $user /home/$user/.ssh/authorized_keys &&

    chmod 700 /home/$user/.ssh &&
    chmod 600 /home/$user/.ssh/authorized_keys &&

    sudo apt-get update &&
    sudo apt-get install -y zsh &&
    sudo chsh -s \`which zsh\` $user
    "
}

function install_dotfiles {
  ssh "$user@$host" "
    sudo apt-get install -y git &&
    git clone https://github.com/lasseebert/dotfiles.git &&
    cd dotfiles &&
    ./install --simple
  "
}

create_user

while true
do
  read -p "Do you wish to install dotfiles from lasseebert/dotfiles? (yn) " yn
  case $yn in
    [Yy]* ) install_dotfiles; break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
  esac
done

echo "Bootstrap done. You can now login to $user@$host"
