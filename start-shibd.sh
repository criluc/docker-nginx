#! /bin/sh
### BEGIN INIT INFO
# Provides:             shibd
# Required-Start:       $local_fs $remote_fs $network
# Required-Stop:        $local_fs $remote_fs
# Default-Start:        2 3 4 5
# Default-Stop:
# Short-Description:    Shibboleth 2 Service Provider Daemon
# Description:          Starts the separate daemon used by the Shibboleth
#                       Apache module to manage sessions and to retrieve
#                       attributes from Shibboleth Identity Providers.
### END INIT INFO
#
# Written by Quanah Gibson-Mount <quanah@stanford.edu>
# Modified by Lukas Haemmerle <lukas.haemmerle@switch.ch> for Shibboleth 2
# Updated to use the LSB init functions by Russ Allbery <rra@debian.org>
#
# Based on the dh-make template written by:
#
# Written by Miquel van Smoorenburg <miquels@cistron.nl>.
# Modified for Debian
# by Ian Murdock <imurdock@gnu.ai.mit.edu>.

PATH=/sbin:/bin:/usr/sbin:/usr/bin
DESC="Shibboleth 2 daemon"
NAME=shibd
SHIB_HOME=/usr
SHIBSP_CONFIG=/etc/shibboleth/shibboleth2.xml
LD_LIBRARY_PATH=/usr/lib
DAEMON=/usr/sbin/$NAME
SCRIPTNAME=/etc/init.d/$NAME
PIDFILE=/var/run/shibboleth/$NAME.pid
DAEMON_OPTS="-F"
DAEMON_USER=_shibd

# Force removal of socket
DAEMON_OPTS="$DAEMON_OPTS -f"

# Use defined configuration file
DAEMON_OPTS="$DAEMON_OPTS -c $SHIBSP_CONFIG"

# Specify pid file to use
DAEMON_OPTS="$DAEMON_OPTS -p $PIDFILE"

# Specify wait time to use
DAEMON_OPTS="$DAEMON_OPTS -w 30"

# Exit if the package is not installed.
[ -x "$DAEMON" ] || exit 0

# Read configuration if it is present.
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
. /lib/lsb/init-functions

prepare_environment () {
    # Ensure /var/run/shibboleth exists.  /var/run may be on a tmpfs file system.
    [ -d '/var/run/shibboleth' ] || mkdir -p '/var/run/shibboleth'

    # If $DAEMON_USER is set, try to run shibd as that user.  However,
    # versions of the Debian package prior to 2.3+dfsg-1 ran shibd as root,
    # and the local administrator may not have made the server's private key
    # readable by $DAEMON_USER.  We therefore test first by running shibd -t
    # and looking for the error code indicating that the private key could not
    # be read.  If we get that error, we fall back on running shibd as root.
    if [ -n "$DAEMON_USER" ]; then
        DIAG=$(su -s $DAEMON $DAEMON_USER -- -t $DAEMON_OPTS 2>/dev/null)
        if [ $? = 0 ] ; then
            # openssl errstr 200100D (hex for 33558541) says:
            # error:0200100D:system library:fopen:Permission denied
            ERROR='ERROR OpenSSL : error code: 33558541 '
            if echo "$DIAG" | fgrep -q "$ERROR" ; then
                unset DAEMON_USER
                log_warning_msg "$NAME: file permissions require running as" \
                    "root"
            else
                chown -Rh "$DAEMON_USER" '/var/run/shibboleth' '/var/log/shibboleth'
            fi
        else
            unset DAEMON_USER
            log_warning_msg "$NAME: unable to run config check as user" \
                "$DAEMON_USER"
        fi
        unset DIAG
    fi
}

# Start shibd.
do_start () {
    # Return
    #   0 if daemon has been started
    #   1 if daemon was already running
    #   2 if daemon could not be started
    start-stop-daemon --start --quiet ${DAEMON_USER:+--chuid $DAEMON_USER} \
        --pidfile $PIDFILE --exec $DAEMON --test > /dev/null \
        || return 1
    start-stop-daemon --start --quiet ${DAEMON_USER:+--chuid $DAEMON_USER} \
        --pidfile $PIDFILE --exec $DAEMON -- $DAEMON_OPTS \
        || return 2
}

# Stop shibd.
do_stop () {
    # Return
    #   0 if daemon has been stopped
    #   1 if daemon was already stopped
    #   2 if daemon could not be stopped
    #   other if a failure occurred
    start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 \
        --pidfile $PIDFILE --name $NAME
    RETVAL="$?"
    return "$RETVAL"
}

start () {
    prepare_environment

    # Don't start shibd if NO_START is set.
    if [ "$NO_START" = 1 ] ; then
        if [ "$VERBOSE" != no ] ; then
            echo "Not starting $DESC (see /etc/default/$NAME)"
        fi
        exit 0
    fi
    [ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
    do_start
    case "$?" in
        0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
        2)   [ "$VERBOSE" != no ] && log_end_msg 1 ;;
    esac
}

start

exit 0
