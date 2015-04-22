# About this Repo

This is a fork of the the official Docker image for [nginx](https://registry.hub.docker.com/_/nginx/).

It contains the nginx-full version plus the
[nginx-http-shibboleth](https://github.com/nginx-shib/nginx-http-shibboleth)
which allows authorization based on the result of a subrequest to
Shibboleth.

# Current Version

Current nginx version is *1.8.0 stable*.
Current ngnix-http-shibboleth module is based on commit *e985431accbcb39fa9147cf34a5596c0ef195b5e.*

# Docker Image

The docker images is available through the docker hub at
https://registry.hub.docker.com/u/criluc/docker-nginx-http-shibboleth/.

For example:

```
docker pull criluc/docker-nginx-http-shibboleth
```


# Apt repository

You could also use this project as an apt repository containings the
debian wheezy and the ubuntu utopic packaged version.

## Ubuntu utopic (ver. 14.10) repository

On Ubuntu utopic you can use this nginx version adding using this source list

```
echo '# Nginx with nginx-http-shibboleth module
deb https://github.com/criluc/docker-nginx-http-shibboleth/raw/master/ubuntu/ ./' | 
sudo tee -a /etc/apt/sources.list.d/nginx-http-shibboleth.list
```

## Debian wheezy (ver. 7) repository

On debian wheezy you can use this nginx version adding using this source list

```
echo '# Nginx with nginx-http-shibboleth module
deb https://github.com/criluc/docker-nginx-http-shibboleth/raw/master/debian/ ./' | 
sudo tee -a /etc/apt/sources.list.d/nginx-http-shibboleth.list
```
