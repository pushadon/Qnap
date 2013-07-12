#!/bin/sh
CONF=/etc/config/qpkg.conf
QPKG_NAME=mybb
MYBB_CONF=/etc/config/$QPKG_NAME.conf
MYBB_INSTALLDIR=$(/sbin/getcfg $QPKG_NAME Install_Path -f $CONF)
OLD_OPT_LINK=$(/sbin/getcfg OLDOPTLINK link -f $MYBB_CONF)

[ $(readlink /opt) = $MYBB_INSTALLDIR ] && /bin/rm /opt
[ "x$OLD_OPT_LINK" = "xX" ] && echo not exist link || /bin/ln -s $OLD_OPT_LINK /opt
