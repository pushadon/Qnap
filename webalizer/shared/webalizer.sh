#!/bin/sh

RETVAL=0
CONF=/etc/config/qpkg.conf
QPKG_NAME="webalizer"
QPKG_DIR=$(/sbin/getcfg $QPKG_NAME Install_Path -d "" -f $CONF)
WEB_SHARENAME=$(/sbin/getcfg SHARE_DEF defWeb -d Web -f /etc/config/def_share.info)
SYS_WEB_PATH=$( /sbin/getcfg $WEB_SHARENAME path -f /etc/config/smb.conf)
QPKG_WWW=$QPKG_DIR/webalizer
SYS_WWW=$SYS_WEB_PATH/webalizer
WEBALIZER_WEB_HTACCESS="/share/Web/webalizer/.htaccess"
TMP_HTACCESS="/tmp/.htaccess.$$"
CMD_SED="/bin/sed"
CMD_CP="/bin/cp"
CMD_RM="/bin/rm"


source "$QPKG_DIR/webalizer_qnap.conf"



case "$1" in
  start)
	

	 ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
    if [ "$ENABLED" != "TRUE" ]; then
        echo "$QPKG_NAME is disabled."
        exit 1
    else 
	


	 echo "$QPKG_NAME is enabled, enable Webalizer Web UI."

        ${CMD_SED} 's/^deny from all$/#deny from all/g' ${WEBALIZER_WEB_HTACCESS} > ${TMP_HTACCESS}

        ${CMD_CP} ${TMP_HTACCESS} ${WEBALIZER_WEB_HTACCESS}

        /bin/echo ${TMP_HTACCESS} ${WEBALIZER_WEB_HTACCESS}

        ${CMD_RM} ${TMP_HTACCESS}


   fi


	ln -nfs $QPKG_WWW $SYS_WWW

	 # Starting webalizer...

                start_webalizer
                RETVAL=$?




    ;;

  stop)

	 rm -r  $SYS_WWW
	 # Stopping webalizer...
                stop_webalizer

                RETVAL=$?



   
    : ADD STOP ACTIONS HERE
    ;;

  restart)


	 # restart webalizer...
                restart_webalizer

                RETVAL=$?


    ;;

  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac

exit $RETVAL
