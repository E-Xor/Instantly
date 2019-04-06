# Instantly

Calendly demo app

# Process

## OS X

```
docker pull ubuntu
docker images
docker tag 94e814e2efa8 instantly:latest

git clone https://github.com/E-Xor/Instantly

vi ~/.profile
alias instantly-run="docker run -it -p 3000:3000 -v /Users/maksim/other-apps/Instantly:/root/Instantly instantly bash"
source ~/.profile

instantly-run

docker commit -m "Start to Passenger" fcfe9dcffb7b instantly:latest


```

## Docker

```

# Common

apt update
apt install curl less vim git bash-completion -y

vi ~/.bashrc
# Find 'bash_completion' code and uncomment it.

# RVM

\curl -sSL https://get.rvm.io | bash
source /etc/profile.d/rvm.sh # add to ~/.bashrc

cd ~/Instantly
rvm install "ruby-2.6.2"
cd ..
cd Instantly # will generate the gemset

gem install rails -v '6.0.0.beta3' --no-document

rails new .

# comment out 'platform" next to tzinfo gem
bundle update tzinfo

apt install nodejs -y
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt update
apt install --no-install-recommends yarn

rails webpacker:install

rails s -b 0.0.0.0



# No need since can run via rails s
# Apache

apt install apache2 -y

# Passenger

# Found here https://www.phusionpassenger.com/library/install/apache/install/oss/bionic/
apt install -y dirmngr gnupg
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
apt install -y apt-transport-https ca-certificates
echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list
apt install -y libapache2-mod-passenger # Phusion Passenger 5.0.30
a2enmod passenger
service apache2 restart
/usr/sbin/passenger-memory-stats # just to check


# Later

# ln -s ~/shared/ssh .ssh
# add to ~/.bashrc
# eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/id_rsa
# apt install libmysqlclient-dev -y

```

## EC2

```
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

```
