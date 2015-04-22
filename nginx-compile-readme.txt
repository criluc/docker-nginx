# Compile and packaging instructions

## In order to compile nginx and build its deb packages

The following instructions has been followed:

- https://serversforhackers.com/compiling-third-party-modules-into-nginx

In particular a docker container using debian wheezy has been 
and using it I build the .deb package.

The nginx sources are available through apt

*For debian*

```
deb-src http://nginx.org/packages/debian/ codename nginx
```

*For ubuntu*
```
deb-src http://nginx.org/packages/ubuntu/ codename nginx
```

*Then You can download the source using apt*

```
apt-get source nginx
```

## In order to publish the apt repository

You can easily publish the apt repository on github following this
instructions:

 - http://askubuntu.com/questions/71510/how-do-i-create-a-ppa

 