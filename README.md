# ingress-nginx-openidc

This is a demonstration of ingress-nginx's plugin system and its extensibility in general.
Vanilla ingress-nginx does not have a support for OpenID Connect. However we can extend it and add
OpenID Connect support using https://github.com/zmartzone/lua-resty-openidc.

We achieve this by creating an ingress-nginx plugin called `openidc` and installing it to /etc/nginx/lua/plugins/
directory in the image.


In order to build the image use following command:

```
docker build -t ingress-nginx-openidc rootfs/
```

For further understanding of the plugin you can inspect `rootfs/etc/nginx/lua/plugins/openidc/main.lua` file.

You will see that the plugin requires `OPENIDC_CLIENT_ID` and `OPENIDC_CLIENT_SECRET` environment variables
to be set. You can store these variables in a K8s secret and then configure that in the deployment manifest
so that the environment variables are available within ingress-nginx containers.

Finally we need to make changes to `/etc/nginx/template/nginx.tmpl` and configure the `openidc` plugin:

```
plugins.init({ "openidc" })
```

https://github.com/zmartzone/lua-resty-openidc also requires us to define following Nginx directives:

```
lua_ssl_trusted_certificate /etc/ssl/certs/ca-certificates.crt;
lua_ssl_verify_depth 5;

# cache for discovery metadata documents
lua_shared_dict discovery 1m;
# cache for JWKs
lua_shared_dict jwks 1m;
```

This has last been tested with ingress-nginx 0.26.1.
