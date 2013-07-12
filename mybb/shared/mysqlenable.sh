#!/bin/sh
CMD_SETCFG=/sbin/setcfg
CMD_MYSQLD=/etc/init.d/mysqld.sh
CMD_SUDO=/opt/bin/sudo
SYS_LINUXCONF=/etc/config/uLinux.conf

$CMD_SETCFG MySQL Enable TRUE -f $SYS_LINUXCONF
$CMD_MYSQLD start
