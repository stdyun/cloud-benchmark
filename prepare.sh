#!/usr/bin/env bash

install_redhat() {
    yum -y install puppet
}

install_debian() {
    apt-get -y install puppet
}

install_gentoo() {
    emerge puppet
}

case `uname -s` in
  Linux)
    if [ -f /etc/redhat-release ] ; then
      install_redhat
    elif [ -f /etc/debian_version ] ; then
      install_debian
    elif [ -f /etc/gentoo-release ] ; then
      install_gentoo
    else
      echo "Sorry. Your OS is not supported by this installer"
    fi
    ;;
  *)
    echo "Sorry. Your OS is not supported by this installer"
    ;;
esac
