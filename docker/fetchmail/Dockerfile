FROM cguenther/docker-fetchmail:latest
# (the only tag available is latest)

LABEL maintainer="chris.edsall@bristol.ac.uk"
LABEL uk.ac.bristol.acrc.name="gw4-isambard-fetchmail"
LABEL decsription="Service to ingest mail from Office365 in to Request Tracker"
LABEL vcs-url="https://github.com/christopheredsall/rt-k8s/docker/fetchmail"
LABEL version="0.1"

# for the envsubst command to parse the variables in the template
RUN apk add gettext

ADD fetchmailrc.tmpl /data/etc/fetchmailrc.tmpl
ADD start.sh /bin/start.sh

CMD ["/bin/sh", "/bin/start.sh"]
