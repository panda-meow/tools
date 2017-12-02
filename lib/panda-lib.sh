green() {
    echo -en "\033[0;32m$*\033[0m"
}

yellow() {
    echo -en "\033[0;33m$*\033[0m"
}

red() {
    echo -en "\033[0;31m$*\033[0m"
}

blue() {
    echo -en "\033[0;34m$*\033[0m"
}

bold() {
    echo -en "\033[0;1m$*\033[0m"
}

status() {
    echo -e "$(blue '==>') $(bold $*...)"
}

error() {
    echo -e "$(red 'Error:') $*"
}

server-init() {
  SERVER_IP=$(cat $PANDA_HOME/tools/.server 2> /dev/null) || { error "Server Not Configured"; false; }
}

# server-update <IP>
server-update() {
  echo $1 > $PANDA_HOME/tools/.server  
}

server-setup() {
  status "Installing Public SSH Key"

  ssh root@$SERVER_IP "mkdir -p .ssh; cat - > id_rsa.pub; cat id_rsa.pub >> .ssh/authorized_keys" < ~/.ssh/id_rsa.pub
	ssh root@$SERVER_IP "bash -s" << END

  id panda &> /dev/null || sudo useradd panda -m -s /bin/bash
  sudo -u panda mkdir -p /home/panda/.ssh 
	sudo -u panda touch /home/panda/.ssh/authorized_keys
  cat id_rsa.pub >> /home/panda/.ssh/authorized_keys
	rm id_rsa.pub

END
}
