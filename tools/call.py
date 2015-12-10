#!/usr/bin/python

from getpass import getpass
from urllib import quote
import os
import subprocess

os.environ['OVFPASSWD'] = quote(getpass( "\nEnter your password: "))

subprocess.call( './deployall.sh' )
