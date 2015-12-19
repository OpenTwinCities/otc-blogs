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

empty_sites(){
  wp --path=public/wp site empty --yes --url=capitol-code.$1
  wp --path=public/wp site empty --yes --url=citycampmn.$1
  wp --path=public/wp site empty --yes --url=openminnesota.$1
}

setup_plugins(){
  wp --path=public/wp plugin activate akismet --network
  wp --path=public/wp plugin activate googleanalytics --network
  wp --path=public/wp plugin activate google-sitemap-generator --network
  wp --path=public/wp plugin activate mailchimp-for-wp --network
  wp --path=public/wp plugin activate table-of-contents-plus --network
  wp --path=public/wp plugin activate wonderm00ns-simple-facebook-open-graph-tags --network
  wp --path=public/wp plugin activate ninja-forms --network
  wp --path=public/wp plugin activate wp-open-graph --network
  wp --path=public/wp plugin activate wp-markdown --network
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

  setup_sites $1
  empty_sites $1
  setup_plugins $1
  setup_themes $1
}

setup_sites(){
  wp --path=public/wp site create --slug=capitol-code --title='Capitol Code'
  wp --path=public/wp option update blogdescription "" --url=capitol-code.$1
  wp --path=public/wp site create --slug=citycampmn --title='CityCamp Minnesota'
  wp --path=public/wp option update blogdescription "" --url=citycampmn.$1
  wp --path=public/wp site create --slug=openminnesota --title='Open Minnesota'
  wp --path=public/wp option update blogdescription "" --url=openminnesota.$1
}

setup_themes(){
  wp --path=public/wp theme enable capitol-code --network
  wp --path=public/wp theme enable twentyfifteen --network
  wp --path=public/wp theme enable ward --network
  wp --path=public/wp theme activate capitol-code --url=capitol-code.$1
  wp --path=public/wp theme activate twentyfifteen --url=citycampmn.$1
  wp --path=public/wp theme activate ward --url=openminnesota.$1
}

case "$1" in
  'dependencies') 
    get_dependencies
    ;;
  'empty') 
    empty_sites $2
    ;;
  'plugins')
    setup_plugins $2
    ;;
  'sites')
    setup_sites $2
    ;;
  'themes')
    setup_themes $2
    ;;
  'wordpress') 
    setup_wordpress $2 $3 $4 
    ;;
esac
