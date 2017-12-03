#!/bin/bash

set -e
set -u

alias apt-get='apt-get -o Acquire::ForceIPv4=true'

function add_vapor_apt() {
    eval "$(cat /etc/lsb-release)"

    if [[ "$DISTRIB_CODENAME" != "xenial" && "$DISTRIB_CODENAME" != "yakkety" && "$DISTRIB_CODENAME" != "trusty" ]];
    then
        echo "Only Ubuntu 14.04, 16.04, and 16.10 are supported."
        echo "You are running $DISTRIB_RELEASE ($DISTRIB_CODENAME) [`uname`]"
        return 1;
    fi

    export DEBIAN_FRONTEND=noninteractive
		export SUDO=sudo

    $SUDO apt-get -q update
    $SUDO apt-get -q install -y wget software-properties-common python-software-properties apt-transport-https
    wget -q https://repo.vapor.codes/apt/keyring.gpg -O- | $SUDO apt-key add -
    echo "deb https://repo.vapor.codes/apt $DISTRIB_CODENAME main" | $SUDO tee /etc/apt/sources.list.d/vapor.list
    $SUDO apt-get -q update

    unset DEBIAN_FRONTEND
    unset SUDO
}

# ***** IN CASE WE NEED TO BUILD FROM SOURCE ********

# RELEASE="swift-4.0.2-RELEASE-ubuntu16.04"

# apt-get -o Acquire::ForceIPv4=true update
# apt-get install -y clang libicu-dev swift

# wget --progress=bar:force https://swift.org/builds/swift-4.0.2-release/ubuntu1604/swift-4.0.2-RELEASE/${RELEASE}.tar.gz
# wget --progress=bar:force https://swift.org/builds/swift-4.0.2-release/ubuntu1604/swift-4.0.2-RELEASE/${RELEASE}.tar.gz.sig

# wget -q -O - https://swift.org/keys/all-keys.asc | gpg --import -
# gpg --keyserver hkp://pool.sks-keyservers.net --refresh-keys Swift
# gpg -q --verify ${RELEASE}.tar.gz.sig

# tar xzf ${RELEASE}.tar.gz

# mv ${RELEASE} swift

# rm ${RELEASE}.tar.gz
# rm ${RELEASE}.tar.gz.sig

# echo "export PATH=$HOME/swift/usr/bin:\"\${PATH}\"" >> ~/.bashrc


curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
add_vapor_apt;

apt-get -y update
apt-get -y install git vapor nodejs 

cd ~panda

sudo -u panda git clone https://github.com/panda-meow/tail.git
sudo -u panda git clone https://github.com/panda-meow/whiskers.git
sudo -u panda git clone https://github.com/panda-meow/content.git
