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

RUN cpanm --notest Business::Hours Mail::Sendmail \
  && cpanm \
    Apache::Session \
    Business::Hours \
    CGI \
    CGI::Cookie \
    CGI::Emulate::PSGI \
    CGI::PSGI \
    CSS::Minifier::XS \
    CSS::Squish \
    Class::Accessor::Fast \
    Clone \
    Convert::Color \
    Crypt::Eksblowfish \
    DBD::Pg \
    DBI \
    DBIx::SearchBuilder \
    Data::GUID \
    Data::ICal \
    Data::Page::Pageset \
    Date::Extract \
    Date::Manip \
    DateTime \
    DateTime::Format::Natural \
    DateTime::Locale \
    Devel::GlobalDestruction \
    Devel::StackTrace \
    Email::Abstract \
    Email::Address \
    Email::Address::List \
    Encode \
    FCGI \
    File::ShareDir \
    GD \
    GD::Graph \
    GD::Text \
    GraphViz \
    HTML::FormatText::WithLinks \
    HTML::FormatText::WithLinks::AndTables \
    HTML::Mason \
    HTML::Mason::PSGIHandler \
    HTML::Quoted \
    HTML::RewriteAttributes \
    HTML::Scrubber \
    IPC::Run3 \
    JSON \
    JavaScript::Minifier::XS \
    LWP::Protocol::https \
    List::MoreUtils \
    Locale::Maketext::Fuzzy \
    Locale::Maketext::Lexicon \
    Locale::PO \
    Log::Dispatch \
    Log::Dispatch::Perl \
    MIME::Entity \
    MIME::Types \
    Mail::Header \
    Mail::Mailer \
    Module::Refresh \
    Module::Versions::Report \
    Mojo::DOM \
    Net::CIDR \
    Net::IP \
    Plack \
    Plack::Handler::Starlet \
    Plack::Middleware::Test::StashWarnings \
    Pod::Select \
    Regexp::Common \
    Regexp::Common::net::CIDR \
    Regexp::IPv6 \
    Role::Basic \
    Scope::Upper \
    Set::Tiny \
    String::ShellQuote \
    Symbol::Global::Name \
    Sys::Syslog \
    Test::Email \
    Test::Expect \
    Test::WWW::Mechanize \
    Test::WWW::Mechanize::PSGI \
    Text::Password::Pronounceable \
    Text::Quoted \
    Text::Template \
    Text::WikiFormat \
    Text::Wrapper \
    Time::ParseDate \
    Tree::Simple \
    UNIVERSAL::require \
    WWW::Mechanize \
    XML::RSS \
    XML::Simple

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
    --with-db-type=Pg \
   && make install \
   && rm -rf /usr/local/src/*

COPY apache.rt.conf /etc/httpd/conf.d/rt.conf
COPY RT_SiteConfig.pm /opt/rt4/etc/RT_SiteConfig.pm

VOLUME /opt/rt4

# EXPOSE 80
# # CMD ["/usr/sbin/apache2","-DFOREGROUND"]
CMD ["/bin/bash"]


