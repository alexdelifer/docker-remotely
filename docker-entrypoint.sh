#!/usr/bin/env bash
#set -e

FILE=/config/appsettings.json
DEFAULT=/var/www/remotely/appsettings.json

APPPATH=/var/www/remotely
CONFIGPATH=/config

if [ -f "$FILE" ]; then
	# Config Exists
	echo "$FILE exists."
	rm "$DEFAULT"
	ln -s "$FILE" "$DEFAULT"
else
	# Fix Permissions
	echo "Fixing Permissions"
	setfacl -R -m u:www-data:rwx "$APPPATH"
	chown -R www-data:www-data "$APPPATH"

	setfacl -R -m u:www-data:rwx "$CONFIGPATH"
	chown -R www-data:www-data "$CONFIGPATH"
	
	# No Config - First Setup
	echo "$FILE does not exist, copying default config."
	# Copy config file for first use, and symlink to good location
	cp "$DEFAULT" "$FILE"
	rm "$DEFAULT"
	ln -s "$FILE" "$DEFAULT"

	# Modify default config for docker compat
	echo "Modifying $FILE for docker compat..."
	sed -i "s/\"SQLite\":.*/\"SQLite\"\: \"DataSource=\/config\/Remotely.db\",/" "$FILE"
	sed -i "s/\"Theme.*/\"Theme\": \"Dark\",/" "$FILE"
	sed -i 's/
//g' "$FILE"

fi

# Fix Permissions

echo "Fixing Permissions"
sed -i "s/www-data:x:33:33:www-data:\/var\/www:\/usr\/sbin\/nologin/www-data:x:33:33:www-data:\/config:\/bin\/bash/g" /etc/passwd 

#setfacl -R -m u:www-data:rwx "$APPPATH"
#chown -R www-data:www-data "$APPPATH"

setfacl -R -m u:www-data:rwx "$CONFIGPATH"
chown -R www-data:www-data "$CONFIGPATH"

# Go!
echo "Starting Remotely!"
#cd "$CONFIGPATH"
cd "$APPPATH"
exec su -c "/usr/bin/dotnet /var/www/remotely/Remotely_Server.dll" www-data
echo "Good Bye!"
