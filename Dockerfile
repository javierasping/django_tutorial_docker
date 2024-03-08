FROM debian
RUN sed -i 's/http:/https:/g' /etc/apt/sources.list.d/debian.sources
RUN echo 'Acquire::https::Verify-Peer "false";' > /etc/apt/apt.conf.d/99ignore-ssl-certificates
RUN apt-get update && apt-get install -y python3-pip libmariadb-dev pkg-config && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /usr/share/app
COPY django_tutorial .
#COPY ./docker-entrypoint.sh /usr/local/

RUN pip3 install --no-cache-dir --break-system-packages -r requirements.txt
#RUN python3 manage.py migrate
EXPOSE 3000

#ENV DJANGO_SUPERUSER_PASSWORD=admin
#ENV DJANGO_SUPERUSER_USERNAME=admin
#ENV DJANGO_SUPERUSER_EMAIL=admin@example.org

#RUN python3 manage.py migrate && python3 manage.py createsuperuser --noinput

#CMD  python3 manage.py runserver 0.0.0.0:3000

#No crea el usuario , se queda reiniciando el contenedor
#ENV PASSWORD admin
#ENV USERNAME admin
#ENV EMAIL admin@gmail.com
#CMD python3 manage.py migrate && python3 manage.py createsuperuser --noinput --username $USERNAME --email $EMAIL && python3 changesuperuserpw.py -n $USERNAME -p $PASSWORD && python3 manage.py runserver 0.0.0.0:3000

CMD /usr/local/docker-entrypoint.sh
