Open Twin Cities Blogs
======================

## Install

1. Get this repo

  `git clone https://github.com/OpenTwinCities/otc-blogs.git`

2. Install Dependencies

  `./setup.sh dependencies`

3. Configure Apache

  A sample VirtualHost config is in the `apache` folder. Copy that into
  /etc/apache2/sites-avaiable, then edit it as needed. In particular, make sure
  the `DocumentRoot` is set to the `public` folder of this repo, and make sure
  the `<Directory>` block at the bottom points to this repo.

  Now, enable the otc-blogs site, and the rewrite mod, and restart Apache: 

  ```
  sudo a2ensite otc-blogs
  sudo a2enmod rewrite
  sudo service apache2 restart
  ```
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

7. Install Wordpress with Multisite.

  `./setup wordpress <domain_name> <admin_email> <admin_password>`
