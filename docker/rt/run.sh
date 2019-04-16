#!/bin/sh

envsubst '$DATABASE_PASSWORD' </opt/rt4/etc/RT_SiteConfig.pm.in >/opt/rt4/etc/RT_SiteConfig.pm

/usr/sbin/httpd -DFOREGROUND
