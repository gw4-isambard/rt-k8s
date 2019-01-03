# After https://github.com/cloos/docker-rt by Christian Loos <cloos@netsandbox.de>
# but with postgres for the database and CentOS rather than debian

FROM centos:7

LABEL maintainer="Chris Edsall <chris.edsall@bristol.ac.uk>"

ENV RT_VERSION 4.4.3
ENV RT_SHA 738ab43cac902420b3525459e288515d51130d85810659f6c8a7e223c77dadb1

RUN yum -y update \
  && yum clean all \
  && yum -y install \
            perl \
            perl-CPAN \
            perl-App-cpanminus \
            make \
            expat \
            gd \
            graphviz \
            openssl \
            expat-devel \
            gd-devel \
            graphviz-devel  \
            openssl-devel \
            wget \
            mod_fcgid \
            postgresql \
            postgresql-devel \
  && yum -y groupinstall \
            "Development Tools" \
            "Web Server"

RUN cpanm --notest Business::Hours
  && cpanm \
        Net::IP \
        Encode Crypt::Eksblowfish \
        Module::Versions::Report \
        List::MoreUtils DBI \
        Devel::StackTrace \
        Text::Password::Pronounceable \
        Devel::GlobalDestruction \
        Time::ParseDate \
        IPC::Run3 \
        Tree::Simple \
        HTML::Scrubber \
        HTML::Quoted \
        Data::Page::Pageset \
        Sys::Syslog \
        Mail::Mailer \
        Data::GUID \
        HTML::Mason \
        Symbol::Global::Name \
        DateTime::Format::Natural \
        Plack Text::Wrapper \
        Regexp::Common::net::CIDR \
        Log::Dispatch \
        HTML::FormatText::WithLinks::AndTables
        DateTime \
        CGI::Emulate::PSGI \
        Text::Quoted \
        Regexp::IPv6 \
        CGI \
        Class::Accessor::Fast \
        CSS::Squish \
        DateTime::Locale \
        CGI::PSGI \
        Apache::Session \
        Date::Extract \
        HTML::Mason::PSGIHandler \
        MIME::Entity \
        Locale::Maketext::Lexicon \
        Role::Basic \
        Module::Refresh \
        Date::Manip \
        HTML::RewriteAttributes \
        Text::Template \
        CGI::Cookie \
        XML::RSS \
        Text::WikiFormat \
        DBIx::SearchBuilder \
        Regexp::Common \
        File::ShareDir \
        CSS::Minifier::XS \
        Data::ICal \
        Pod::Select \
        HTML::FormatText::WithLinks \
        Scope::Upper \
        Mail::Header \
        Locale::Maketext::Fuzzy \
        MIME::Types \
        Email::Address::List Convert::Color \
        JavaScript::Minifier::XS \
        Clone \
        Net::CIDR \
        JSON \
        UNIVERSAL::require \
        Email::Address \
        Plack::Handler::Starlet \
        Test::Email \
        Email::Abstract \
        Test::Deep \
        Set::Tiny \
        String::ShellQuote \
        Test::MockTime \
        File::Which \
        Test::WWW::Mechanize::PSGI \
        Locale::PO \
        Test::Expect \
        Test::Warn \
        Plack::Middleware::Test::StashWarnings \
        Log::Dispatch::Perl \
        Test::NoWarnings \
        Test::Builder \
        Test::LongString \
        WWW::Mechanize \
        XML::Simple \
        Test::Pod \
        Mojo::DOM \
        Test::WWW::Mechanize \
        FCGI \
        GD::Text \
        GD \
        GD::Graph \
        IPC::Run \
        GraphViz \
        LWP::Protocol::https \
        DBD::Pg \
        DBIx::SearchBuilder \
        LWP::Protocol::https \
        IPC::Run \
        GraphViz \
        Plack::Middleware::Test::StashWarnings \
        Log::Dispatch::Perl \
        Test::MockTime \
        XML::Simple \
        File::Which \
        Test::NoWarnings \
        Test::Pod Test::Email \
        Test::Builder \
        Email::Abstract \
        Mojo::DOM \
        Test::WWW::Mechanize::PSGI \
        Locale::PO \
        Test::Deep \
        Set::Tiny \
        Test::LongString \
        WWW::Mechanize Test::Expect \
        String::ShellQuote \
        Test::Warn \
        Test::WWW::Mechanize \
        DBD::Pg \
        DBIx::SearchBuilder \
        GD::Graph GD::Text \
        GD Net::IP Business::Hours Encode \
        Crypt::Eksblowfish \
        Module::Versions::Report \
        List::MoreUtils \
        DBI \
        Devel::StackTrace \
        Text::Password::Pronounceable \
        Devel::GlobalDestruction \
        Time::ParseDate \
        IPC::Run3 \
        Tree::Simple \
        HTML::Scrubber \
        HTML::Quoted \
        Data::Page::Pageset \
        Sys::Syslog Mail::Mailer \
        Data::GUID \
        HTML::Mason \
        Symbol::Global::Name \
        DateTime::Format::Natural \
        Plack \
        Text::Wrapper \
        Regexp::Common::net::CIDR \
        Log::Dispatch \
        HTML::FormatText::WithLinks::AndTables \
        DateTime \
        CGI::Emulate::PSGI \
        Text::Quoted Regexp::IPv6 \
        CGI \
        Class::Accessor::Fast \
        CSS::Squish \
        DateTime::Locale \
        CGI::PSGI \
        Apache::Session \
        Date::Extract \
        HTML::Mason::PSGIHandler \
        MIME::Entity \
        Locale::Maketext::Lexicon \
        Role::Basic \
        Module::Refresh \
        Date::Manip \
        HTML::RewriteAttributes \
        Text::Template \
        CGI::Cookie \
        XML::RSS \
        Text::WikiFormat \
        DBIx::SearchBuilder \
        Regexp::Common \
        File::ShareDir \
        CSS::Minifier::XS \
        Data::ICal \
        Pod::Select \
        HTML::FormatText::WithLinks \
        Scope::Upper \
        Mail::Header \
        Locale::Maketext::Fuzzy MIME::Types \
        Email::Address::List \
        Convert::Color \
        JavaScript::Minifier::XS \
        Clone \
        Net::CIDR \
        JSON \
        UNIVERSAL::require \
        Email::Address \
        Plack::Handler::Starlet \
        FCGI
        
RUN cd /usr/local/src \
  && curl -sSL "https://download.bestpractical.com/pub/rt/release/rt-${RT_VERSION}.tar.gz" -o rt.tar.gz \
  && echo "${RT_SHA}  rt.tar.gz" | sha256sum -c \
  && tar -xzf rt.tar.gz \
  && rm rt.tar.gz \
  && cd "rt-${RT_VERSION}" \
  && ./configure \
    --disable-gpg \
    --disable-smime \
    --enable-developer \
    --enable-gd \
    --enable-graphviz \
    --with-db-type=Pg


#   && make install \
#   && make initdb \
#   && rm -rf /usr/local/src/*
# 
# COPY apache.rt.conf /etc/apache2/sites-available/rt.conf
# RUN a2dissite 000-default.conf && a2ensite rt.conf
# 
# RUN chown -R www-data:www-data /opt/rt4/var/
# 
# COPY RT_SiteConfig.pm /opt/rt4/etc/RT_SiteConfig.pm
# 
# # /etc/apache2/envvars isn't sourced by default
# ENV APACHE_LOCK_DIR=/var/lock/apache2 \
# APACHE_LOG_DIR=/var/log/apache2 \
# APACHE_PID_FILE=/var/run/apache2/apache2.pid \
# APACHE_RUN_DIR=/var/run/apache2 \
# APACHE_RUN_GROUP=www-data \
# APACHE_RUN_USER=www-data
# 
# VOLUME /opt/rt4
# 
# EXPOSE 80
# # CMD ["/usr/sbin/apache2","-DFOREGROUND"]
CMD ["/bin/bash"]


