#!/bin/bash

cd ${site_path}

chown -f docker.docker storage/logs/laravel.log

# fire supervisor
umask 0000
/usr/bin/supervisord -n
