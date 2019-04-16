#!/bin/sh

envsubst '$DATABASE_PASSWORD' </opt/rt4/etc/RT_SiteConfig.pm.in >/opt/rt4/etc/RT_SiteConfig.pm
envsubst '$O365_USER $O365_PASS' </etc/fetchmailrc.in >/etc/fetchmailrc

# Launch fetchmail daemon
touch /var/log/fetchmail.log
chmod og-rwx /etc/fetchmailrc
fetchmail -f /etc/fetchmailrc

# Lauch webserver
/usr/sbin/httpd -DFOREGROUND
