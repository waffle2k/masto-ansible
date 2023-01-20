#!/bin/bash

DAYS=5
DOCKER_IMAGE=live-web-1
LOGFILE=/tmp/media_remove.log

REMOVED=$(/usr/bin/docker exec -i $DOCKER_IMAGE /opt/mastodon/bin/tootctl media remove --days $DAYS 2>&1 | egrep -e '^Removed')

echo "$(date): $REMOVED" >> $LOGFILE
