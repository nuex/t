#!/bin/sh

# Show current timelog
_t_timelog() {
  echo "$timelog"
}

# Run a ledger command on the timelog
_t_ledger() {
  ledger -f $timelog "$@"
}

# do something in unix with the timelog
_t_do() {
    action=$1; shift
    ${action} "$@" ${timelog}
}

# Clock in to the given project
# Clock in to the last project if no project is given
_t_in() {
  [ ! "$1" ] && set -- "$@" "$(_t_last)"
  echo i `date '+%Y-%m-%d %H:%M:%S'` $* >>$timelog
}

# Clock out
_t_out() {
  echo o `date '+%Y-%m-%d %H:%M:%S'` $* >>$timelog
}

# switch projects
_t_sw() {
  echo o `date '+%Y-%m-%d %H:%M:%S'` >>$timelog
  echo i `date '+%Y-%m-%d %H:%M:%S'` $* >>$timelog
}

# Show the currently clocked-in project
_t_cur() {
  sed -e '/^i/!d;$!d' ${timelog} | __t_extract_project
}

# Show the last checked out project
_t_last() {
  sed -ne '/^o/{g;p;};h;' ${timelog} | tail -n 1 | __t_extract_project
}

# Show usage
_t_usage() {
  # TODO
  cat << EOF
Usage: t action
actions:
     in - clock into project or last project
     out - clock out of project
     sw,switch - switch projects
     bal - show balance
     hours - show balance for today
     edit - edit timelog file
     cur - show currently open project
     last - show last closed project
     grep - grep timelog for argument
     cat - show timelog
     less - show timelog in pager
     timelog - show timelog file
EOF
}

#
# INTERNAL FUNCTIONS
#

__t_extract_project() {
  awk '$1 != "o" {
          line = $4
          for (i=5; i<=NF; i++)
            line = line " " $i;
          print line
      }'
}

action=$1; shift
[ "$TIMELOG" ] && timelog="$TIMELOG" || timelog="${HOME}/.timelog.ldg"

case "${action}" in
  in)   _t_in "$@";;
  out)  _t_out "$@";;
  sw)   _t_sw "$@";;
  bal) _t_ledger bal "$@";;
  hours) _t_ledger bal -p "since today" "$@";;
  switch)   _t_sw "$@";;
  edit) _t_do $EDITOR "$@";;
  cur)  _t_cur "$@";;
  last) _t_last "$@";;
  grep) _t_do grep "$@";;
  cat)  _t_do cat "$@";;
  less)  _t_do less;;
  timelog) _t_timelog "$@";;

  h)    _t_usage;;
  *)    _t_usage;;
esac

exit 0
