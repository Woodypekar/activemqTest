#!/bin/bash
#
#
# Sends a message to the message broker on localhost.
# Uses ActiveMQ's REST API and the curl utility.
#

if [ $# -lt 2 -o $# -gt 3 ]  ; then
    echo "Usage: msgSender (topic|queue) DESTINATION [ FILE ]"
    echo "   Ex: msgSender topic myTopic msg.json"
    echo "   Ex: msgSender topic myTopic <<< 'this is my message'"
    exit 2
fi

UNAME=admin
PSWD=admin

TYPE=$1
DESTINATION=$2
FILE=$3

BHOST=${BROKER_HOST:-'localhost'}
BPORT=${BROKER_REST_PORT:-'8161'}

if [ -z "$FILE" -o "$FILE" = "-" ]  ; then
    # Get msg from stdin if no filename given

    ( echo -n "body="  ;  cat )  \
        | curl -u $UNAME:$PSWD --data-binary '@-' --proxy ""  \
             "http://$BHOST:$BPORT/api/message/$DESTINATION?type=$TYPE"
else
    # Get msg from a file
    if [ ! -r "$FILE" ]  ; then
        echo "File not found or not readable"
        exit 2
    fi

    ( echo -n "body="  ;  cat $FILE )  \
        | curl -u $UNAME:$PSWD --data-binary '@-' --proxy ""  \
             "http://$BHOST:$BPORT/api/message/$DESTINATION?type=$TYPE"
fi
