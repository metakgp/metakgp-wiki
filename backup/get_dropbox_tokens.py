import os
from dropbox import DropboxOAuth2FlowNoRedirect
from dotenv import load_dotenv

load_dotenv()

APP_KEY = os.getenv("DROPBOX_APP_KEY")
APP_SECRET = os.getenv("DROPBOX_APP_SECRET")

auth_flow = DropboxOAuth2FlowNoRedirect(
    APP_KEY,
    consumer_secret=APP_SECRET,
    token_access_type="offline",
)

authorize_url = auth_flow.start()
print("Go to the url for authorization code: " + authorize_url)
auth_code = input("Enter the authorization code: ").strip()

oauth_result = auth_flow.finish(auth_code)
print("DROPBOX_ACCESS_TOKEN=" + oauth_result.access_token)
print("DROPBOX_REFRESH_TOKEN=" + oauth_result.refresh_token)
