#!/usr/bin/env python

import dropbox
import sys
import os

access_token = os.environ['DROPBOX_ACCESS_TOKEN']

client = dropbox.client.DropboxClient(access_token)

file_name = sys.argv[1]

with open(file_name, 'rb') as f:
    response = client.put_file(file_name, f)
    print response
