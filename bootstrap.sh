#!/usr/bin/env bash

if [ -z $USER_NAME ]; then
  USER_NAME='user'
fi
echo "provisioning for user ($USER_NAME from env):"
sudo -u $USER_NAME whoami
echo ""


# Install system requirements
# target :  base Ubuntu 16.04 - Xenial

# my personal dotfiles and tools
sudo apt-get update
sudo apt-get install -y git vim htop

# Ubunut 16.04 doesn't activate ssh by default... so install it
sudo apt-get install openssh-server -y

sudo -u $USER_NAME cd ~
sudo -u $USER_NAME git clone https://github.com/scottrfrancis/dotfiles.git
sudo -u $USER_NAME cp dotfiles/.bash_profile /home/$USER_NAME/
sudo -u $USER_NAME cp dotfiles/.vimrc /home/$USER_NAME/

# ruby 2.4
sudo apt-add-repository ppa:brightbox/ruby-ng -y
sudo apt-get update
# sudo apt-get install ruby2.2 ruby2.2-dev
sudo apt-get install -y ruby2.4 ruby2.4-dev
echo "ruby version now"
ruby -v

# sudo apt-get update
# sudo apt-get upgrade -y

sudo apt-get install -y make
# sudo apt install ubuntu-make
sudo apt-get install -y g++
sudo apt-get install -y nodejs
# sudo apt-get install -y sqlite3 libsqlite3-dev

# may need to set gem path on PATH
# echo "gem: --user-install"> ~/.gemrc
# echo "export PATH=$PATH:/home/vagrant/.gem/ruby/2.3.0/bin" >>/home/vagrant/.bashrc
sudo -u $USER_NAME echo "export RAILS_ENV='development'" >>/home/$USER_NAME/.bashrc
#
# # . ~/.bashrc
#
sudo chmod -R u+w /var/lib/gems/

# gem update
# sudo chmod -R ago+w /var/lib/gems/

gem install bundler

sudo apt-get install -y zlib1g-dev
# gem install nokogiri

gem install rails #-v '4.2.1'


# gem install sqlite3
# sudo chmod -R ago+w /var/lib/gems/

sudo apt-get install -y postgresql
sudo apt-get install -y libpq-dev

# NB- next line creates a user for the current username which is appropriate for dev.
# production would likely need something else
#   ACHTUNG!  the user is created with superuser powers and NO PASSWORD
sudo -u postgres createuser -s -w $USER_NAME
    # current user should be 'user' for C@C or 'vagrant' for... uhh... vagrant

#
# GNU GSL
#
cd /usr/src
sudo wget ftp://ftp.gnu.org/gnu/gsl/gsl-1.14.tar.gz
sudo tar zxvf gsl-1.14.tar.gz
cd gsl-1.14
sudo ./configure
sudo make
sudo make install
echo "export LD_LIBRARY_PATH=/usr/local/lib" >>/home/$USER_NAME/.bashrc

#
# rgl-pk
#
cd /usr/src
sudo wget http://ftp.gnu.org/gnu/glpk/glpk-4.44.tar.gz
sudo tar zxvf glpk-4.44.tar.gz
cd glpk-4.44
sudo ./configure
sudo make
sudo make check
sudo make install
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

# cd /vagrant
# gem install rglpk
# gem install rglpk -v '0.4.0'
#
# gem install net-ssh
# sudo chmod -R ago+w /var/lib/gems/
