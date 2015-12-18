Open Twin Cities Blogs
======================

## Install

1. Install System Dependencies
  ```
  sudo apt-get install mysql-server apache2 php5-common libapache2-mod-php5 php5-cli php5-mysql
  curl -sS https://getcomposer.org/installer | php
  sudo mv composer.phar /usr/local/bin/composer
  ```
2. Get this repo
  ```
  git clone <url>
  ```
3. Configure Apache
  A sample VirtualHost config is in the `apache` folder. Copy that into
  /etc/apache2/sites-avaiable, then edit it as needed. In particular, make sure
  the `DocumentRoot` is set to the `public` folder of this repo, and make sure
  the `<Directory>` block at the bottom points to this repo.

  Now, enable the otc-blogs site: `sudo a2ensite otc-blogs`
  Enable the rewrite mod: `sudo a2enmod rewrite`

  Restart apache: `sudo service apache2 restart`

  You will also need to change the group owner and permissions of this repo's
  `public` folder to be Apache's group:
  ```
  sudo chgrp -R www-data public
  sudo chmod -R 755 public
  ```
4. Install PHP dependencies
  ```
  cd otc-blogs
  composer install
  ```
5. Setup the Database. See [Wordpress's Using the MySQL Client Instructions](http://codex.wordpress.org/Installing_WordPress#Using_the_MySQL_Client)
6. Copy and edit config file
  ```
  cp local-config.php.sample local-config.php
  nano local-config.php
  ```

  If you're hosting on something besides localhost, be sure to set `DOMAIN_CURRENT_SITE`
  to your actual domain name.
7. Go through the WordPress install. If you are hosting locally, visit `http://lvh.me`.
8. Set the site's address to not include the wp/ subdirectory. Go to the admin screen,
   then Settings and edit Site Address to not have any directoires after the domain name.
9. Setup MultiSite. Go to Tools -> Network Setup. Choose sub-domains, then click `Install`.
   WordPress will output somethings to put into wp-config.php and .htaccess. No
   need to edit htaccess (those settings are include), put will need to put the
   output for wp-config.php into your local-config.php (or production-config.php).
