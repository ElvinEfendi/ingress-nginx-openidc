#FROM quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.26.1
FROM k8s.gcr.io/ingress-nginx/controller:v0.43.0

USER root

RUN apk add --upgrade unzip curl luarocks5.1

#RUN luarocks install lua-resty-openidc
RUN luarocks-5.1 install lua-resty-jwt 0.2.0-0
RUN luarocks-5.1 install lua-resty-http 0.15-0
RUN luarocks-5.1 install lua-resty-session 3.8-1
RUN luarocks-5.1 install lua-resty-openidc 1.7.4-1

# for safety concern, remove luarocks after installation
RUN apk del --quiet unzip curl luarocks5.1

USER www-data

# recommend to enable the plugin on demand via Helm values controller.config.plugins=openidc
# COPY etc/nginx/template/nginx.tmpl /etc/nginx/template
COPY etc/nginx/lua/plugins/openidc /etc/nginx/lua/plugins/openidc
