#!/bin/bash
### BEGIN INIT INFO
# Provides: conqueso
# Required-Start: $remote_fs $named $syslog
# Required-Stop: $remote_fs $named $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: The conqueso server
# Description: The conqueso server 
### END INIT INFO

# Author: EJ Ciramella
PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin

NAME="conqueso"
USERNAME=conqueso
NODE_BIN_DIR=/usr/bin
NODE_PATH=/srv/conqueso/node_modules/
APPLICATION_DIRECTORY=/srv/conqueso
APPLICATION_START=server/app.js
PIDFILE=$APPLICATION_DIRECTORY/.forever/$NAME.pid
export HOME=$APPLICATION_DIRECTORY

DATE_FORMAT=`date +%Y-%m-%d -d "today"`
LOGFILE=$APPLICATION_DIRECTORY/logs/server.log.$DATE_FORMAT

PATH=$NODE_BIN_DIR:$PATH
export NODE_ENV=production
export NODE_PATH=$NODE_PATH

. /lib/lsb/init-functions

start() {
 if [ -f $PIDFILE ]; then
                echo "$NAME already running"
        else

                echo "Starting $NAME"
                cd $APPLICATION_DIRECTORY
                exec sudo -u conqueso forever --pidFile $PIDFILE --sourceDir $APPLICATION_DIRECTORY \
                    -a -l $LOGFILE --minUptime 3000 --spinSleepTime 5000 \
                    start $APPLICATION_START
                RETVAL=$?
   fi
}

stop() {
 if [ -f $PIDFILE ]; then

                echo "Shutting down $NAME"
                cd $APPLICATION_DIRECTORY
                exec sudo -u conqueso forever --pidFile $PIDFILE --sourceDir $APPLICATION_DIRECTORY stop $APPLICATION_START
                rm -f $PIDFILE
                RETVAL=$?
        else
                echo "$NAME is not running"
     fi
}

restart() {
        echo "Restarting $NAME"
        stop
        start
}

status() {
        echo "Status for $NAME:"
        #exec sudo -u conqueso forever list
        status_of_proc "/usr/bin/node" "$NAME" -p $PIDFILE && exit 0 || exit $?
        RETVAL=$?
}

case "$1" in
        start)
                start
                ;;
        stop)
                stop
                ;;
        status)
                status
                ;;
        restart)
                restart
                ;;
        *)
                echo "Usage: {start|stop|status|restart}"
                exit 1
                ;;
esac
exit $RETVAL
