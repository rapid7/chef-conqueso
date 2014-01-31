#!/bin/bash
### BEGIN INIT INFO
# Provides: node_debian_init
# Required-Start: $remote_fs $named $syslog
# Required-Stop: $remote_fs $named $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: The conqueso server
# Description: The conqueso server 
### END INIT INFO
 
# Author: EJ Ciramella
PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin
 
DAEMON_ARGS="/srv/conqueso/server/app.js"
 
DESC="Conqueso config server"
 
NODEUSER=conqueso:conqueso
 
LOCAL_VAR_RUN=/var/run
 
NAME=node 
DAEMON=/usr/local/bin/$NAME
 
[ $UID -eq "0" ] && LOCAL_VAR_RUN=/var/run
THIS_ARG=$0
INIT_SCRIPT_NAME=`basename $THIS_ARG`
[ -h $THIS_ARG ] && INIT_SCRIPT_NAME=`basename $(readlink $THIS_ARG)`
INIT_SCRIPT_NAME_NOEXT=${INIT_SCRIPT_NAME%.*}
PIDFILE="$LOCAL_VAR_RUN/$INIT_SCRIPT_NAME_NOEXT.pid"
SCRIPTNAME=/etc/init.d/$INIT_SCRIPT_NAME
 
[ -x "$DAEMON" ] || { echo "can't find Node.js ($DAEMON)" >&2; exit 0; }
 
[ -d "$LOCAL_VAR_RUN" ] || { echo "Directory $LOCAL_VAR_RUN does not exist. Modify the '$INIT_SCRIPT_NAME_NOEXT' init.d script ($THIS_ARG) accordingly" >&2; exit 0; }
 
[ -r /etc/default/$INIT_SCRIPT_NAME ] && . /etc/default/$INIT_SCRIPT_NAME
 
. /lib/init/vars.sh
 
. /lib/lsb/init-functions
 
# uncomment to override system setting
# VERBOSE=yes
 
do_start()
{
    start-stop-daemon --start --quiet --pidfile $PIDFILE --chuid $NODEUSER --background --exec $DAEMON --test > /dev/null \
       || { [ "$VERBOSE" != no ] && log_daemon_msg " ---> Daemon already running $DESC" "$INIT_SCRIPT_NAME_NOEXT"; return 1; }
    start-stop-daemon --start --quiet --chuid $NODEUSER --make-pidfile --pidfile $PIDFILE --background --exec $DAEMON -- \
       $DAEMON_ARGS \
        || { [ "$VERBOSE" != no ] && log_daemon_msg " ---> could not be start $DESC" "$INIT_SCRIPT_NAME_NOEXT"; return 2; }
      [ "$VERBOSE" != no ] && log_daemon_msg " ---> started $DESC" "$INIT_SCRIPT_NAME_NOEXT"
}
 
do_stop()
{
  start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --pidfile $PIDFILE --chuid $NODEUSER --name $DAEMON
  RETVAL="$?"
  #[ "$VERBOSE" != no ] && [ "$RETVAL" = 1 ] && log_daemon_msg " ---> SIGKILL failed => hardkill $DESC" "$INIT_SCRIPT_NAME_NOEXT"
  [ "$RETVAL" = 2 ] && return 2
  start-stop-daemon --stop --quiet --oknodo --retry=0/3/KILL/5 --pidfile $PIDFILE --chuid $NODEUSER --exec $DAEMON -- $DAEMON_ARGS
  [ "$?" = 2 ] && return 2
  rm -f $PIDFILE
  [ "$VERBOSE" != no ] && [ "$RETVAL" = 1 ] && log_daemon_msg " ---> $DESC not running" "$INIT_SCRIPT_NAME_NOEXT"
  [ "$VERBOSE" != no -a "$RETVAL" = 0 ] && log_daemon_msg " ---> $DESC stopped" "$INIT_SCRIPT_NAME_NOEXT"
  return "$RETVAL"
}
 
#
# Function that sends a SIGHUP to the daemon/service
#
do_reload() {
#
# If the daemon can reload its configuration without
# restarting (for example, when it is sent a SIGHUP),
# then implement that here.
#
start-stop-daemon --stop --quiet --signal 1 --pidfile $PIDFILE --chuid $NODEUSER --name $NAME
return 0
}
 
#
# Function that returns the daemon
#
do_status() {
#
# http://refspecs.freestandards.org/LSB_3.1.1/LSB-Core-generic/LSB-Core-generic/iniscrptact.html
# 0 program is running or service is OK
# 1 program is dead and /var/run pid file exists
# (2 program is dead and /var/lock lock file exists) (not used here)
# 3 program is not running
# 4 program or service status is unknown
RUNNING=$(running)
# $PIDFILE corresponds to a live $NAME process
ispidactive=$(pidof $NAME | grep `cat $PIDFILE 2>&1` >/dev/null 2>&1)
ISPIDACTIVE=$?
 
if [ -n "$RUNNING" ]; then
if [ $ISPIDACTIVE ]; then
log_success_msg "$INIT_SCRIPT_NAME_NOEXT (launched by $USER) (--chuid $NODEUSER) is running"
exit 0
fi
else
if [ -f $PIDFILE ]; then
log_success_msg "$INIT_SCRIPT_NAME_NOEXT (launched by $USER) (--chuid $NODEUSER) is not running, phantom pidfile $PIDFILE"
exit 1
else
log_success_msg "no instance launched by $USER, of $INIT_SCRIPT_NAME_NOEXT (--chuid $NODEUSER) found"
exit 3
fi
fi
}
 
running() {
RUNSTAT=$(start-stop-daemon --start --quiet --pidfile $PIDFILE --chuid $NODEUSER --background --exec $DAEMON --test > /dev/null)
if [ "$?" = 1 ]; then
echo y
fi
}
 
 
case "$1" in
start)
[ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$INIT_SCRIPT_NAME_NOEXT"
do_start
case "$?" in
0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
esac
;;
stop)
[ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$INIT_SCRIPT_NAME_NOEXT"
do_stop
case "$?" in
0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
esac
;;
#reload|force-reload)
#
# If do_reload() is not implemented then leave this commented out
# and leave 'force-reload' as an alias for 'restart'.
#
#log_daemon_msg "Reloading $DESC" "$NAME"
#do_reload
#log_end_msg $?
#;;
restart|force-reload)
#
# If the "reload" option is implemented then remove the
# 'force-reload' alias
#
log_daemon_msg "Restarting $DESC" "$INIT_SCRIPT_NAME_NOEXT"
do_stop
case "$?" in
0|1)
do_start
case "$?" in
0) log_end_msg 0 ;;
1) log_end_msg 1 ;; # Old process is still running
*) log_end_msg 1 ;; # Failed to start
esac
;;
*)
# Failed to stop
log_end_msg 1
;;
esac
;;
status)
do_status
;;
*)
#echo "Usage: $SCRIPTNAME {start|stop|restart|reload|force-reload}" >&2
echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload}" >&2
exit 3
;;
esac
 
exit 0
