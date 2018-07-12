#!/bin/sh

cd /src
if [ ! -f ".env" ]; then
    POLR_GENERATED_AT=`date +"%B %d, %Y"`
    export POLR_GENERATED_AT

    APP_KEY=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    export APP_KEY
fi

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
