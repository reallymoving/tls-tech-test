FROM --platform=linux/amd64 ubuntu:20.04
EXPOSE 8888 2222

# environment variables
ENV provision_path=/provision site_path=/var/www/quiz

# * * * *                       INSTALL ESSENTIALS                      * * * *

# create "docker" user that all environments will rely upon; set its password
RUN useradd --create-home --user-group --shell /bin/false docker \
    && echo "docker:password" | chpasswd \
    && echo "root:password" | chpasswd

# set timezone
RUN ln -s /usr/share/zoneinfo/Europe/London /etc/localtime && \
    echo "Europe/London" | tee /etc/timezone

# update and upgrade repositories, and then install core packages
RUN apt-get update -qqy && apt-get upgrade -qqy && \
    apt-get install -qqy --no-install-recommends curl htop locales ntp \
    openssh-server software-properties-common supervisor unzip \
    vim gpg-agent libssl-dev

# generate the locale, then set the language and locale
RUN locale-gen en_GB.UTF-8
ENV LANG="en_GB.UTF-8" LANGUAGE="en_GB:en" LC_ALL="en_GB.UTF-8"

# * * * *                 INSTALL MEMCACHE, NGINX AND PHP               * * * *

RUN apt-get install -qqy cron nginx php \
    php-apcu php-curl php-fpm php-intl php-mbstring \
    php-mysql php-xml php-zip php-pdo-sqlite

# * * * *                       INSTALL COMPOSER                        * * * *

RUN curl -sS https://getcomposer.org/installer | php \
    -- --install-dir=/usr/local/bin --filename=composer

# * * * *        CREATE PATHS THAT APPLICATIONS COMMONLY REQUIRE        * * * *

# create provision path and other, common, paths that containers will need
RUN mkdir -p ${provision_path} /logs /pids /run/sshd && \
    chown -R docker:docker ${provision_path} \
    /logs /pids /var/lib/nginx /var/log/nginx /var/www

# * * * *           INJECT PLATFORM CONTENT AND CONFIGURATION           * * * *

# content
COPY --chown=docker:docker src ${site_path}

# configuration
COPY conf/common_env /
RUN chmod +x ${provision_path}/*.sh

# * * * *                       DEFINE ENTRYPOINT                       * * * *

ENTRYPOINT ["/provision/entrypoint.sh"]
