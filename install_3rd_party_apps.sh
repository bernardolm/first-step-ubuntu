#!/bin/bash

source $BASE_PATH/msg.sh

msg_init '3rd party apps'

# [x] balena etcher  https://github.com/balena-io/etcher#debian-and-ubuntu-based-package-repository-gnulinux-x86x64
# [x] bleachbit      https://www.bleachbit.org/download/linux
# [x] docker         https://docs.docker.com/engine/install/ubuntu/
# [x] fzf            https://github.com/junegunn/fzf
# [x] golang         https://golang.org/doc/install
# [x] guake          https://github.com/Guake/guake
# [x] stacer         https://github.com/oguzhaninan/Stacer
# [x] stremio        https://www.stremio.com/downloads#linux
# [x] tixati         https://www.tixati.com/download/linux.html
# [x] todo.sh        https://github.com/todotxt/todo.txt-cli
# [x] winehq-staging https://wiki.winehq.org/Ubuntu - https://plus.diolinux.com.br/t/sketchup-no-linux/10347/6 - To use Sketchup 2017
# [x] zinit          https://github.com/zdharma/zinit

if [[ "$(command -v /opt/balenaEtcher/balena-etcher-electron)" == "" ]]; then
   echo -e "\n💾 installing balena etcher electron..."
   sudo apt-get install --yes balena-etcher-electron
fi

if [[ "$(command -v bleachbit)" == "" ]]; then
   echo -e "\n💾 installing bleachbit..."
   curl https://download.bleachbit.org/bleachbit_4.0.0_all_ubuntu1904.deb -o ~/tmp/bleachbit.deb && sudo dpkg -i ~/tmp/bleachbit.deb
fi

if [[ "$(command -v docker)" == "" ]]; then
   echo -e "\n💾 installing docker..."
   sudo apt install --yes docker-ce docker-ce-cli containerd.io
   [ `cat /etc/group | grep docker | wc -l | bc` -eq 0 ] && sudo groupadd docker
   sudo usermod -aG docker $USER
   ## newgrp docker # FIXME: exiting from current shell
fi

if [[ "$(command -v fzf)" == "" ]]; then
   echo -e "\n💾 installing fzf..."
   if [ ! -d "~/.fzf" ]; then
      echo "cloning fzf..."
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
   fi
   ~/.fzf/install
fi

if [[ "$(command -v go)" == "" ]]; then
   echo -e "\n💾 installing go..."
   wget --quiet https://golang.org/dl/go1.15.2.linux-amd64.tar.gz -O ~/tmp/go.tar.gz
   sudo /bin/rm -rf $GOPATH/pkg
   sudo tar -C /usr/local -xzf ~/tmp/go.tar.gz
fi

if [[ "$(command -v guake)" == "" ]]; then
   echo -e "\n💾 installing guake..."
   curl -L -o ~/tmp/guake.zip https://github.com/Guake/guake/archive/master.zip
   unzip -oq ~/tmp/guake.zip -d ~/tmp/guake
   cd ~/tmp/guake/guake-master
   ./scripts/bootstrap-dev-debian.sh run make
   make
   sudo make install
   cd -
fi

if [[ "$(command -v stremio)" == "" ]]; then
   echo -e "\n💾 installing stremio..."
   curl https://dl.strem.io/shell-linux/v4.4.116/stremio_4.4.116-1_amd64.deb -o ~/tmp/stremio.deb && sudo dpkg -i ~/tmp/stremio.deb
fi

if [[ "$(command -v tixati)" == "" ]]; then
   echo -e "\n💾 installing tixati..."
   curl https://download2.tixati.com/download/tixati_2.75-1_amd64.deb -o ~/tmp/tixati.deb && sudo dpkg -i ~/tmp/tixati.deb
fi

if [[ "$(command -v todo.sh)" == "" ]]; then
   echo -e "\n💾 installing todo.sh..."
   version="2.12.0"
   curl -s -L https://github.com/todotxt/todo.txt-cli/releases/download/v$version/todo.txt_cli-$version.zip -o ~/tmp/todo.zip
   unzip ~/tmp/todo.zip -d ~/tmp/todo
   yes | mv ~/tmp/todo/todo.txt_cli-$version.dirty/todo.sh $SYNC_PATH/bin
   yes | mv ~/tmp/todo/todo.txt_cli-$version.dirty/todo_completion $SYNC_PATH/todo_txt
fi

if [[ "$(command -v zinit)" == "off" ]]; then
   echo -e "\n💾 installing zinit..."
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
fi

sudo apt install -f

msg_end '3rd party apps'
