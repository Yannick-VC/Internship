#!/bin/bash

sudo apt update -y
sudo apt install apache2 wget unzip -y
sudo apt install mysql-server -y
sudo apt install php php-zip php-json php-mbstring php-mysql -y
sudo systemctl enable mysql
sudo systemctl start mysql
sudo systemctl enable apache2
sudo systemctl start apache2
sudo wget https://files.phpmyadmin.net/phpMyAdmin/5.0.3/phpMyAdmin-5.0.3-all-languages.zip
sudo unzip phpMyAdmin-5.0.3-all-languages.zip
sudo mv phpMyAdmin-5.0.3-all-languages /usr/share/phpmyadmin
sudo mkdir /usr/share/phpmyadmin/tmp
sudo chown -R www-data:www-data /usr/share/phpmyadmin
sudo chmod 777 /usr/share/phpmyadmin/tmp
sudo cat << EOF >> /etc/apache2/conf-available/phpmyadmin.conf
Alias /phpmyadmin /usr/share/phpmyadmin
Alias /phpMyAdmin /usr/share/phpmyadmin 
<Directory /usr/share/phpmyadmin/>
   AddDefaultCharset UTF-8
   <IfModule mod_authz_core.c>
      <RequireAny>
      Require all granted
     </RequireAny>
   </IfModule>
</Directory>
<Directory /usr/share/phpmyadmin/setup/>
   <IfModule mod_authz_core.c>
     <RequireAny>
       Require all granted
     </RequireAny>
   </IfModule>
</Directory>
EOF

echo "<?php" > /usr/share/phpmyadmin/testing.php
echo "host = ${db_address}" >> /usr/share/phpmyadmin/testing.php
echo "username = ${db_username}" >> /usr/share/phpmyadmin/testing.php
echo "password = ${db_password}" >> /usr/share/phpmyadmin/testing.php


sudo cat > /usr/share/phpmyadmin/testingpurpose.txt << 'EOL'

<?php
include 'testing.php'
declare(strict_types=1);
$cfg['blowfish_secret'] = '';
$i = 0;
$i++;
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['host'] = 'localhost';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['AllowNoPassword'] = true
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';
$i++;
$cfg['Servers'][$i]['host'] = '$host';
$cfg['Servers'][$i]['user'] = '$username';
$cfg['Servers'][$i]['password'] = '$password';
$cfg['Servers'][$i]['auth_type'] = 'config';
EOL

search="\$cfg['blowfish_secret'] = '';"; 
replace="\$cfg['blowfish_secret'] = '1234';";
sed -i "s/\$cfg\[.blowfish_secret.\]\s*=.*/$replace/" /usr/share/phpmyadmin/testingpurpose.txt

sudo a2enconf phpmyadmin
sudo systemctl restart apache2
