#!/bin/bash

# see https://www.linode.com/docs/email/postfix/postfix-smtp-debian7/
# Configures Postfix to send auth'ed email via O365
# run as root

postconf -e 'myhostname = isambard.gw4.ac.uk'

# Configuring the Relay Server
postconf -e 'relayhost = [smtp.office365.com]:587'
postconf -e 'smtp_sasl_auth_enable = yes'
postconf -e 'smtp_sasl_security_options = noanonymous'
postconf -e 'smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd'
postconf -e 'smtp_use_tls = yes'
postconf -e 'smtp_tls_CAfile = /etc/ssl/certs/ca-bundle.crt'
postconf -e 'inet_protocols = ipv4'

# Configuring SMTP Usernames and Passwords
echo '[smtp.office365.com]:587 '"$O365_USER:$O365_PASS" >> /etc/postfix/sasl_passwd
postmap /etc/postfix/sasl_passwd
chown root:root /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
chmod 0600 /etc/postfix/sasl_passwd /etc/postfix/sasl_passwd.db
