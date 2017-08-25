FROM nginx:latest

ADD ./config/nginx/rails_proxy_headers    /etc/nginx/conf.d
ADD ./config/nginx/.htpasswd              /etc/nginx/.htpasswd
ADD ./config/nginx/coplannery-rails.conf  /etc/nginx/conf.d
