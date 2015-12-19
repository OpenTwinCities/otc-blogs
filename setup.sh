#! /bin/bash

get_dependencies()
{
  sudo apt-get install mysql-server apache2 php5-common libapache2-mod-php5 php5-cli php5-mysql
  if [ ! -e "/usr/local/bin/composer" ];
  then
    echo "---Installing Composer---"
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
  fi

  if [ ! -e "/usr/local/bin/wp" ];
  then
    echo "--Installing WP-CLI---"
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    sudo mv wp-cli.phar /usr/local/bin/wp
  fi
}

setup_wordpress(){
  cd public
  wp core multisite-install --url=$1 --subdomains --title='Open Twin Cities' --admin_user=admin --admin_email=$2 --admin_password=$3
}

case "$1" in
  'dependencies') 
    get_dependencies
    ;;
  'wordpress') 
    setup_wordpress $2 $3 $4 
    ;;
esac
