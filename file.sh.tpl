#!/bin/bash

: <<'END'
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
END
echo "db_password=${db_password}" > /usr/share/phpmyadmin/cred.txt
echo "db_username=${db_username}" >> /usr/share/phpmyadmin/cred.txt
echo "db_address=${db_address}" >> /usr/share/phpmyadmin/cred.txt

db_password=`sed -n 's/^db_password=\(.*\)/\1/p' < /usr/share/phpmyadmin/cred.txt`
db_username=`sed -n 's/^db_username=\(.*\)/\1/p' < /usr/share/phpmyadmin/cred.txt`
db_address=`sed -n 's/^db_address=\(.*\)/\1/p' < /usr/share/phpmyadmin/cred.txt`

echo "$db_password"
echo "$db_username"
echo "$db_address"

sudo cat > /usr/share/phpmyadmin/testingpurpose.txt << 'EOL'

<?php
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

search="\$cfg['Servers'][$i]['host'] = '$host';"; 
replace="\$cfg['Servers'][$i]['host'] = '$db_address';";
sed -i "s/\$cfg\[.Servers.\]\[$i\]\[.host.\]\s*=.*/$replace/" /usr/share/phpmyadmin/testingpurpose.txt

search2="\$cfg['Servers'][$i]['user'] = '$host';";
replace2="\$cfg['Servers'][$i]['user'] = '$db_username';";
sed -i "s/\$cfg\[.Servers.\]\[$i\]\[.host.\]\s*=.*/$replace2/" /usr/share/phpmyadmin/testingpurpose.txt

search3="\$cfg['Servers'][$i]['password'] = '$password';";
replace3="\$cfg['Servers'][$i]['password'] = '$db_password';";
sed -i "s/\$cfg\[.Servers.\]\[$i\]\[.host.\]\s*=.*/$replace3/" /usr/share/phpmyadmin/testingpurpose.txt

sudo a2enconf phpmyadmin
sudo systemctl restart apache2

