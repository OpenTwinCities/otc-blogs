Open Twin Cities Blogs
======================

## Install

1. Install Composer
  ```
  curl -sS https://getcomposer.org/installer | php
  sudo mv composer.phar /usr/local/bin/composer
  ```
2. Install MySQL
  ```
  sudo apt-get install mysql-server
  ```
3. Get this repo
  ```
  git clone <url>
  ```
4. Install PHP dependencies
  ```
  cd otc-blogs
  composer install
  ```
5. Copy and edit config file
  ```
  cp local-config.php.sample local-config.php
  nano local-config.php
  ```
