These are a couple of simple scripts (chklocks was a one-liner)
which may be helpful in doing some house-cleaning on your OS X
system.

"chkUGM" is a perl script which compares the current User, Group,
and Mode of the files on your system to the ones they had when the
system was installed (based on the BaseSystem.bom and some of the
other bom files; you can easily add others).  It creates a shell
script in /tmp/fixUGM.sh which you can either run, or just read
for its riveting plot.  Any files which are not of the same type
they should be are flagged as fatal errors, since the script can't
do anything about them, but the script will still run to completion.
Missing files are reported, but otherwise ignored.  There will
probably be a lot of them, some of the originally installed apps
will have been replaced, some applications may have been moved,
and some files may simply have been removed. Netinfo database files
are ignored, since most of the installed files will have been
replaced. The names of other  missing files are written to a file
in /tmp.  Symbolic links are ignored, as are the directories "/.vol"
and "/dev" since they can't be changed anyway.  This is a relatively
sound script; it makes the assumption that no filenames in the bom
contain tabs (which should be a fairly safe assumption) but just
dies with an error if it hits one.  It also assumes that no files
are shipped with an owner of "nobody" but the fix for that is
already in the script ready to go if it ever happens.  The fix is
just too ugly to leave in unless it's needed so it's commented out
for now.  You must run "chkUGM" with sudo or as root.

"chklocks" is a shell script using awk, and is not at all sound.
It must be run as root or with sudo.
It was a one-liner until I put in the check for root, and added
the ability to take a list of directories as arguments.  With no
arguments, it scans the entire file tree starting at root; with
a list of directories as arguments it scans only those directories;
with anything other than a list of one or more directories as
arguments it complains and quits.
It will find locked files on your system, but may break if it hits
filenames with funny characters. 
Output lines have a flag (normally "uchg") followed by a full pathname.
If the flag is anything other than "uchg" something weird has happened
to the system; if the flag happens to be "schg" you will have to go to
single-user mode to correct or delete the offending file.

Comments, suggestions, and enhancements to:
Larry Prall <lgp@cablespeed.com>

Brickbats and other complaints to:
Joe Root <root@localhost.localdomain>
