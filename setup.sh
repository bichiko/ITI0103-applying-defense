touch /var/www/username.txt
dmidecode -s bios-release-date >> /var/www/username.txt
#create file to save user flag
touch /var/www/flag.txt
#setup htaccess to make work URL rewrite
#enable rewrite module
a2enmod rewrite
#enable htaccess from config
sed -i -e 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf
#restart apache
systemctl restart apache2
a=`ifconfig | grep -o "192.168.8.254"`

#remove it
rm -f iti0103-web-applying-defense.sh
#vulnerable machine
cp /var/www/html/index.html /var/www/index.html
#cut and move all webserver files to web root directory
rm -rf /var/www/html/*
mv /var/www/index.html /var/www/html/index.html

if [ "$a" != "" ]; then
#this is machine for check
    #this opens in users machine
    echo "Please visit 192.168.8.253" >> /var/www/html/index.html
    echo "<br>I am going to check your work bitch" >> /var/www/html/index.html
	cp -r /root/setup/ITI0103-applying-defense/checker/* /var/www/html/
	#including hidden files
	cp -r /root/setup/ITI0103-applying-defense/checker/.* /var/www/html/
	php /var/www/html/setupdb.php >> /dev/null

else
	#create ssh user ninja:ninja
	#this is web server
	printf 'ninja\nninja\n\n\n\n\n\n\n\n' | adduser --home /var/www/html --shell /bin/bash --no-create-home --ingroup www-data --ingroup ssh ninja
	cp -r /root/setup/ITI0103-applying-defense/webserver/* /var/www/html/
	#including hidden files
	cp -r /root/setup/ITI0103-applying-defense/webserver/.* /var/www/html/
	sudo groupadd defenders
	sudo usermod -a -G defenders ninja
	sudo usermod -a -G defenders www-data
	sudo chgrp -R defenders /var/www/html
	sudo chmod 776 -R /var/www/html

	CONFIG____="
		<?php \n
			 
			define('DEBUG', true);  \n
			define('LOCALHOST', false); \n\n
			/* \n
				Database constants \n
				@DB_HOST - db hostname \n
				@DB_USER - db username \n
				@DB_PASS - db password \n
				@DB_NAME - db name \n
			*/ \n
			define('DB_HOST', 'do'); \n
		 	define('DB_USER', 'it'); \n
		 	define('DB_PASS', 'for'); \n
		 	define('DB_NAME', 'me'); \n
		 	define('DB_PORT', '3306'); \n
	"
	echo -n $CONFIG____ > /var/www/html/config.php
fi

rm -f /var/www/html/setup.sh
#remove it
rm -rf /root/setup/ITI0103-applying-defense/

#remove loading spinner
rm -f /var/www/html/setup.sh
rm -f /var/www/html/setupdb.php
rm -f /var/www/html/index.html
rm -f /var/www/html/README.md