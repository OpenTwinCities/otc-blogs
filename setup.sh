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
  if [ -e "local-config.php" ];
  then
    config_file='local-config.php'
  elif [ -e 'production-config.php' ];
  then
    config_file='production-config.php'
  else
    echo 'ERROR: You must create a local-config.php or a production-config.php'
    exit
  fi
  echo "Using $config_file"
  wp --path=public/wp core multisite-install --url=$1 --subdomains --title='Open Twin Cities' --admin_user=admin --admin_email=$2 --admin_password=$3
  git diff public/wp-config.php | patch -p1 -f $config_file --
  git checkout public/wp-config.php

  if [ -e "$config_file.rej" ];
  then
    echo "---Something went wrong. See $config_file.orig and $config_file.rej "
  else
    rm $config_file.*
  fi

  setup_sites
  setup_themes
}

setup_sites(){
  wp --path=public/wp site create --slug=capitol-code --title='Capitol Code'
}

setup_themes(){
  wp --path=public/wp theme enable capitol-code --network
  wp --path=public/wp theme activate capitol-code --url=capitol-code.$1
}

case "$1" in
  'dependencies') 
    get_dependencies
    ;;
  'sites')
    setup_sites
    ;;
  'themes')
    setup_themes $2
    ;;
  'wordpress') 
    setup_wordpress $2 $3 $4 
    ;;
esac