# pull the nginx Docker image
FROM nginx

# delete default.conf
RUN rm /etc/nginx/conf.d/default.conf

# delete old mime.types
RUN rm /etc/nginx/mime.types

# copy new mime.types into 
COPY mime.types /etc/nginx/

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

# copy own default.conf into docker 
COPY default.conf /etc/nginx/conf.d/default.conf
