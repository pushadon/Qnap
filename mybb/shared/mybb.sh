#!/bin/sh
CONF=/etc/config/qpkg.conf
QPKG_NAME=mybb
MYBB_CONF=/etc/config/$QPKG_NAME.conf
MYBB_INSTALLDIR=$(/sbin/getcfg mybb Install_Path -f /etc/config/qpkg.conf)
APACHE_CONF=/etc/config/apache/apache.conf
APACHE_DOCROOT=$(grep DocumentRoot $APACHE_CONF | cut -f2 -d '"')

case "$1" in
  start)
    ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
    if [ "$ENABLED" != "TRUE" ]; then
        echo "$QPKG_NAME is disabled."
        exit 1
    fi
    
    MYBB_DIR=$(/sbin/getcfg $QPKG_NAME Install_Path -d "" -f $CONF)
    
    if [ ! -f $MYBB_DIR/Upload/install/lock ]; then
	mv $MYBB_DIR/Upload/inc/config.default.php $MYBB_DIR/Upload/inc/config.php
	chmod 666 $MYBB_DIR/Upload/inc/config.php
	chmod 666 $MYBB_DIR/Upload/inc/settings.php
	chmod 777 $MYBB_DIR/Upload/cache
	chmod 777 $MYBB_DIR/Upload/uploads
	chmod 777 $MYBB_DIR/Upload/uploads/avatars
	chmod 777 $MYBB_DIR/Upload/install

	[ -d /opt ] && OLD_OPT_LINK=$(readlink /opt) || OLD_OPT_LINK="X"
	/sbin/setcfg OLDOPTLINK link $OLD_OPT_LINK -f $MYBB_CONF
	[ -d /opt ] && /bin/rm -fr /opt
	/bin/ln -s $MYBB_INSTALLDIR /opt
    fi
	
    [ -x $MYBB_DIR/Upload ] && /bin/ln -sf $MYBB_DIR/Upload $APACHE_DOCROOT/mybb
    [ -x $MYBB_DIR/Documentation ] && /bin/ln -sf $MYBB_DIR/Documentation $APACHE_DOCROOT/mybb/Documentation
    ;;

  stop)
    /bin/rm -f $APACHE_DOCROOT/mybb/Documentation
    /bin/rm -f $APACHE_DOCROOT/mybb
    OLD_OPT_LINK=$(/sbin/getcfg OLDOPTLINK link -f $MYBB_CONF)
    [ $(readlink /opt) = $MYBB_INSTALLDIR ] && /bin/rm /opt
    [ "x$OLD_OPT_LINK" = "xX" ] && echo not exist link || /bin/ln -s $OLD_OPT_LINK /opt    
    ;;

  restart)
    $0 stop
    $0 start
    ;;

  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac

exit 0
