#!/bin/sh
GROUP_NAME_TMP=$(getent group $GROUP_ID | cut -d: -f1)
if [ "$GROUP_NAME_TMP" == "" ]; then
    addgroup -g $GROUP_ID $GROUP
else
    GROUP=$GROUP_NAME_TMP
fi
adduser -h "$USER_HOME" -u $USER_ID -G "$GROUP" -s /bin/bash -D "$USER"
