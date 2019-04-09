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

docker commit -m "Instantly" fcfe9dcffb7b instantly:latest


```

## Docker

```

# Common

apt update
apt install curl less vim git bash-completion -y

vi ~/.bashrc
# Find 'bash_completion' code and uncomment it.
alias app='cd /var/www/vhosts/Instantly/current'

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

bundle exec rails s -u webrick -b 0.0.0.0

rails g controller CalendlyFeed

# Capistrano
bundle exec cap install

# SSH Agent Forwarding

# add to ~/.bashrc
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# Bootstrap

yarn add bootstrap-css-only

# RSpec

rails generate rspec:install
rails g rspec:controller calendly_feed

```

## EC2

```

ssh ubuntu@instantly.globalmax.net -i AWS_Key.pem 

# Access

sudo su
adduser deploy # I keep name and other info empty
cd /home/deploy
mkdir .ssh
vi .ssh/authorized_keys # Paste my key in
chown deploy.deploy .ssh
chown deploy.deploy .ssh/authorized_keys
visudo
# ========== add somewhere towards the end
deploy ALL=(ALL:ALL) ALL
deploy ALL=NOPASSWD: ALL
# ==========
exit
exit
ssh deploy@instantly.globalmax.net

# Essentials

sudo apt update
sudo apt upgrade # If it asks about Grub or menu.lst - say to keep existing versions and don't select to install on any devices.
sudo apt install iproute2 iputils-tracepath iputils-ping rsyslog bash-completion curl less vim -y
sudo shutdown -r now # A good time to reboot

# Ruby

\curl -sSL https://get.rvm.io | bash
source /home/deploy/.rvm/scripts/rvm # add to ~/.bashrc
source ~/.bashrc
rvm install ruby-2.6.2

# Capistrano

sudo mkdir -p /var/www/vhosts
sudo chown deploy.deploy /var/www/vhosts
mkdir /var/www/vhosts/Instantly

# Rails 6 dependencies

sudo apt install nodejs -y
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install --no-install-recommends yarn

# Apache and Passenger

sudo apt install apache2 -y

sudo apt install -y dirmngr gnupg
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo apt install -y apt-transport-https ca-certificates
sudo su
echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list
exit
sudo apt install -y libapache2-mod-passenger # 5.0.30
sudo a2enmod passenger
/usr/sbin/passenger-memory-stats # just to check

sudo vi /etc/apache2/apache2.conf
ServerName "instantly.globalmax.net"

sudo vi /etc/apache2/conf-enabled/security.conf 
ServerSignature Off # don't advertise version
ServerTokens Prod # don't advertise version

sudo vi /etc/apache2/mods-enabled/mpm_event.conf

<IfModule mpm_event_module>
  ServerLimit              5
  ThreadsPerChild          20
  MaxRequestWorkers        100 # Server Limit x ThreadsPerChild > PassengerMaxPoolSize * 2
  StartServers             5 # = ServerLimit
  MinSpareThreads          1  # MinSpareThreads and MaxSpareThreads define range for creating and killing Apache processes
  MaxSpareThreads          50 # 50% of MaxRequestWorkers
  ThreadLimit              64 # > ThreadsPerChild
  MaxConnectionsPerChild   10000
</IfModule>

sudo vi /etc/apache2/conf-available/passenger-common.conf

<IfModule mod_passenger.c>
  PassengerMaxPoolSize 13
  # Between number of CPUs and max allowed RAM
  # Max allowed RAM is 75% of total on a dedicated server, less if anything else is running
  # <Max allowed RAM> * 1024 / <App RAM consumtion>
  PassengerMinInstances 13 # = PassengerMaxPoolSize
  PassengerPoolIdleTime 0
  # Never kill a process
  # PassengerConcurrencyModel thread # Not tested yet, Rails should also be configured appropriately
  # PassengerThreadCount 25 # If previous option is enabled
</IfModule>

sudo a2enconf passenger-common
apache2ctl configtest 
sudo service apache2 reload

sudo vi /etc/environment
export RAILS_ENV=production

rvm use ruby-2.6.2
rvm gemset create instantly

sudo vi /etc/apache2/sites-available/instantly.conf

<VirtualHost *:80>
  ServerName instantly.globalmax.net

  <IfModule mod_passenger.c>
    PassengerRuby /home/deploy/.rvm/gems/ruby-2.6.2@instantly/wrappers/ruby
    PassengerMaxRequestQueueSize 1000
    PassengerHighPerformance on
    PassengerMaxRequests 1000
  </IfModule>

  RailsEnv production

  DocumentRoot /var/www/vhosts/Instantly/current/public
  <Directory /var/www/vhosts/Instantly/current/public>
    AllowOverride all
    Options -MultiViews
  </Directory>
</VirtualHost>

sudo a2ensite instantly
sudo a2dissite 000-default
sudo service apache2 reload
sudo chmod 755 /var/log/apache2/
sudo chmod 644 /var/log/apache2/*

# Ran into issue with Rails secrets file, it was looking for secrets.yml instead of credentials.yml.enc in production


```

# Webhook creation

```
header = {
  "X-TOKEN" => SETTINGS[:calendly_api_key],
}

post_body    = {
  url:    "http://instantly.globalmax.net/webhook_catch",
  events: ['invitee.canceled', 'invitee.created'],
}.stringify_keys!

response = RestClient.post("#{SETTINGS[:calendly_api_url]}/hooks", post_body, header)
JSON.parse response  # id 376311
response = RestClient.get("#{SETTINGS[:calendly_api_url]}/hooks/376311", headers=header)
response = RestClient.delete("#{SETTINGS[:calendly_api_url]}/hooks/376311", header)
```
