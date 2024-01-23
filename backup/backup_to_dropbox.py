#!/usr/bin/env python

import dropbox
import traceback
import sys
import os

# Name/path of the file to backup
file_name = sys.argv[1]

# Initliaze a Dropbox client
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

with open(file_name, "rb") as f:
    chunksize = 32 * 1024 * 1024

    try:
        # If the size of the file is less than 32 MB, upload directly
        if os.path.getsize(file_name) < chunksize:
            result = client.files_upload(f.read(), "/" + file_name)
            print(result)

        # Else upload in chunks of 32MB
        else:
            next_chunk = f.read(chunksize)

            session = client.files_upload_session_start(next_chunk)
            uploaded = len(next_chunk)

            next_chunk = f.read(chunksize)
            cursor = dropbox.files.UploadSessionCursor(session.session_id, uploaded)

            print("Uploaded: ", float(uploaded) / (1024 * 1024), "MB")
            while next_chunk:
                client.files_upload_session_append_v2(next_chunk, cursor)
                uploaded += len(next_chunk)
                cursor = dropbox.files.UploadSessionCursor(session.session_id, uploaded)
                print("Uploaded: ", float(uploaded) / (1024 * 1024), "MB")

                next_chunk = f.read(chunksize)

            commit_info = dropbox.files.CommitInfo(path="/" + file_name)
            result = client.files_upload_session_finish(f.read(), cursor, commit_info)
            print(result)
    except Exception as e:
        sys.exit(traceback.format_exc())
