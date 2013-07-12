#
# Set rcS vars
#

[ -f /etc/default/rcS ] && . /etc/default/rcS || true
[ "$INIT_VERBOSE" ] && VERBOSE="$INIT_VERBOSE" || true
