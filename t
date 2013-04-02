#!/bin/sh

[ ! "$DEFAULT_TIMELOG_NAME" ] && DEFAULT_TIMELOG_NAME="timelog"

# Show a balance for the current timelog
_t_bal() {
  ledger -f $timelog bal "$@"
}

# Show total time for today
_t_hours() {
  ledger -f $timelog -p "since today" bal
}

# Show current timelog
_t_timelog() {
  __t_current_timelog
}

# Switch to a different timelog
_t_switch() {
  name="$1"; shift
  echo "$name" > "$config"
}

# Grep for specific text in the timelog
_t_grep() {
  grep "$@" $timelog
}

# Clock in to the given project
_t_in() {
  echo i `date '+%Y-%m-%d %H:%M:%S'` $* >>$timelog
}

# Clock out
_t_out() {
  echo o `date '+%Y-%m-%d %H:%M:%S'` $* >>$timelog
}

# Show the currently clocked-in project
_t_cur() {
  tail $timelog -n1 | __t_extract_project
}

# Show the last checked in project
_t_last() {
  count="$(wc -l $timelog | cut -f 1 -d " ")"
  number="$(($count - 1))"
  sed "${number}q;d" $timelog | __t_extract_project
}

# Show usage
_t_usage() {
  # TODO
  echo "Usage: t action"
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

__t_current_timelog() {
  [ ! -f "$config" ] && echo "$DEFAULT_TIMELOG_NAME" > "$config"
  cat "$config"
}

action=$1; shift
config="$HOME/.t"
timelog="$TIMELOG_DIR/$(__t_current_timelog).ledger"

case "${action}" in
  in)   _t_in "$@";;
  out)  _t_out "$@";;
  cur)  _t_cur "$@";;
  last) _t_last "$@";;
  grep) _t_grep "$@";;
  timelog) _t_timelog "$@";;
  switch) _t_switch "$@";;
  hours) _t_hours "$@";;
  bal) _t_bal "$@";;
  ?)    _t_usage;;
  *)    _t_usage;;
esac

exit 0
