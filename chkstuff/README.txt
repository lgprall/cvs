These are a couple of simple scripts (chklocks is a one-liner) which may
be helpful in doing some house-cleaning on your OS X system.

"chkUGM" is a perl script which compares the current User, Group, and
Mode of the files on your system to the ones they had when the system
was installed (based on the BaseSystem.bom).  It creates a shell script
in /tmp/fixUGM.sh which you can either run, or just read for it's
riveting plot.  Any files which are not of the same type they should be
are flagged as fatal errors, since the script can't do anything about
them, but the script will still run to completion.  Missing files are
reported, but otherwise ignored. (There will probably be several,
particularly in /private/var/db/netinfo.) This is a relatively sound
script; it makes the assumption that no filenames in the bom contain
tabs (which should be a fairly safe assumption) but just dies with an
error if it hits one.  It also assumes that no files are shipped with
an owner of "nobody" but the fix for that is already in the script
ready to go if it ever happens.  The fix is just too ugly to leave in
unless it's needed, so it's commented out at the moment.  You must run
"chkUGM" with sudo or as root.

"chklocks" is a shell script using awk, and is not at all sound.  It
will find locked files on your system, but may break if it hits
filenames with funny characters.
