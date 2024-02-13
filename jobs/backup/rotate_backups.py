#!/usr/bin/env python

import dropbox
import os
import datetime

app_key = os.environ["DROPBOX_APP_KEY"]
app_secret = os.environ["DROPBOX_APP_SECRET"]
access_token = os.environ["DROPBOX_ACCESS_TOKEN"]
refresh_token = os.environ["DROPBOX_REFRESH_TOKEN"]
client = dropbox.Dropbox(
    app_key=app_key,
    app_secret=app_secret,
    oauth2_access_token=access_token,
    oauth2_refresh_token=refresh_token,
)

backup_folder_path = ""
has_more_files = True
cursor = None
result = None
files = []
now = datetime.datetime.now()

while has_more_files:
    if cursor is None:
        result = client.files_list_folder(backup_folder_path)
    else:
        result = client.files_list_folder_continue(cursor=cursor)
    cursor = result.cursor
    has_more_files = result.has_more
    files.extend(result.entries)

for file in files:
    if file.name.find("metakgp_wiki") == -1:
        continue
    file_timestamp = file.client_modified
    days_old = (now - file_timestamp).days
    if days_old > 30:
        client.files_delete(file.path_display)