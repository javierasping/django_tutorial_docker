#!/bin/bash
while ! mysql -u ${DB_USER} -p${DB_PASS} -h ${DB_HOST}  -e ";" ; do
	sleep 1
done

#mysql -u ${DB_USER} -p${DB_PASS} -h ${DB_HOST} ${DB_NAME} < /var/www/html/biblioteca.sql

cd /usr/share/app
#python3 manage.py migrate
#python3 manage.py migrate && python3 manage.py createsuperuser --noinput

if [ "$PRODUCCION" != "true" ]; then
    python3 manage.py migrate && python3 manage.py createsuperuser --noinput
fi


