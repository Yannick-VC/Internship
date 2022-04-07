#!/bin/bash

#INSTALL APACHE2, MYSQL, PHP, PHPMYADMIN (LAMP STACK)
sudo apt update -y
sudo apt install apache2 wget mysql-server php php-zip php-json php-mbstring php-mysql unzip -y
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

#SETUP PHPMYADMIN
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

#PASTE TERRAFORM DATABASE CREDENTIALS AND LOAD THEM INTO BASH
cd /usr/share/phpmyadmin/

echo "db_password=${db_password}" > ./cred.txt
echo "db_username=${db_username}" >> ./cred.txt
echo "db_address=${db_address}" >> ./cred.txt

db_password=`sed -n 's/^db_password=\(.*\)/\1/p' < ./cred.txt`
db_username=`sed -n 's/^db_username=\(.*\)/\1/p' < ./cred.txt`
db_address=`sed -n 's/^db_address=\(.*\)/\1/p' < ./cred.txt`


#CONFIG FILE
sudo cat > ./config.inc.php << 'EOL'
<?php
declare(strict_types=1);
$cfg['blowfish_secret'] = '';
$i = 0;
$i++;
$cfg['Servers'][$i]['auth_type'] = 'cookie';
$cfg['Servers'][$i]['host'] = 'localhost';
$cfg['Servers'][$i]['compress'] = false;
$cfg['Servers'][$i]['AllowNoPassword'] = true;
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';
$i++;
$cfg['Servers'][$i]['host']= '$host';
$cfg['Servers'][$i]['user'] = '$username';
$cfg['Servers'][$i]['password'] = '$password';
$cfg['Servers'][$i]['auth_type'] = 'config';
EOL

#REPLACE HOST/USERNAME/PASSWORD FROM CONFIG FILE
search="\$cfg['Servers'][\$i]['host'] = '\$host';"; 
replace="\$cfg['Servers'][\$i]['host'] = '$db_address';";
sed -i "s/\$cfg\[.Servers.\]\[\$i\]\[.host.\]=.*/$replace/" ./config.inc.php

search2="\$cfg['Servers'][\$i]['user'] = '\$username';";
replace2="\$cfg['Servers'][\$i]['user'] = '$db_username';";
sed -i "s/\$cfg\[.Servers.\]\[\$i\]\[.user.\]\s*=.*/$replace2/" ./config.inc.php

search3="\$cfg['Servers'][\$i]['password'] = '\$password';";
replace3="\$cfg['Servers'][\$i]['password'] = '$db_password';";
sed -i "s/\$cfg\[.Servers.\]\[\$i\]\[.password.\]\s*=.*/$replace3/" ./config.inc.php

#REMOVE TEMP CRED FILE & RESTART APACHE2
rm ./cred.txt

sudo a2enconf phpmyadmin
sudo systemctl restart apache2

