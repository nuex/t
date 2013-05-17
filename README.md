# t #

## Description ##

t is a shell script for working with [ledger][]'s [timelog][] format.

## Usage ##

Usage: `t <action>`

### Actions ###

- `t in` - clock into project
- `t out` - clock out of project
- `t sw,switch` - switch projects
- `t bal` - show balance
- `t hours` - show balance for today
- `t edit` - edit timelog file
- `t cur` - show currently open project
- `t last` - show last closed project
- `t grep` - grep timelog for argument
- `t cat` - show timelog
- `t less` - show timelog in pager
- `t timelog` - show timelog file

## References ##

Even though this works with [ledger][] 3, the [timelog][] format is only referenced in the [ledger][] v2 documents.  Here are a few resources about the [timelog][] format:

- [Using timeclock to record billable time][timelog]
- [timelog files][htl] - from the [hledger][] project

## About ##

I forked this from <https://github.com/nuex/t>.  I'm not trying to maintain compatibility with the original for several reasons:

- I didn't need the timelog file switching capabilities.
- I changed the `switch` command to switch projects instead of files
- I changed the default timelog file name.
- I generalized a 'do' command and the 'ledger' command to easily add commands without having to add more functions in the script.

[ledger]: http://ledger-cli.org
[timelog]: http://ledger-cli.org/2.6/ledger.html#Using-timeclock-to-record-billable-time
[htl]: http://hledger.org/MANUAL.html#timelog-files
[hledger]: http://hledger.org/
