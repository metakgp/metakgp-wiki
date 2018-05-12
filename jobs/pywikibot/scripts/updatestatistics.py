import re
from datetime import date
import difflib
import os

from apiclient.discovery import build
from oauth2client.service_account import ServiceAccountCredentials

import httplib2
import json

import pywikibot

from collections import OrderedDict

REQD_TEMPLATE_LEN = 10

def get_service(api_name, api_version, scopes, key_file_env):
    """Get a service that communicates to a Google API.

  Args:
    api_name: The name of the api to connect to.
    api_version: The api version to connect to.
    scope: A list auth scopes to authorize for the application.
    key_file_location: The path to a valid service account p12 key file.
    service_account_email: The service account email address.

  Returns:
    A service that is connected to the specified API.
  """

    credentials = ServiceAccountCredentials.from_json_keyfile_dict(
      json.loads(os.getenv(key_file_env)),
      scopes=scopes
    )

    # Build the service object.
    service = build(api_name, api_version, credentials=credentials)

    return service


def get_first_profile_id(service):
    # Use the Analytics service object to get the first profile id.

    # Get a list of all Google Analytics accounts for this user
    accounts = service.management().accounts().list().execute()

    if accounts.get('items'):
        # Get the first Google Analytics account.
        account = accounts.get('items')[0].get('id')

    # Get a list of all the properties for the first account.
    properties = service.management().webproperties().list(
        accountId=account).execute()

    if properties.get('items'):
        # Get the first property id.
        property = properties.get('items')[0].get('id')

        # Get a list of all views (profiles) for the first property.
        profiles = service.management().profiles().list(
            accountId=account,
            webPropertyId=property).execute()

        if profiles.get('items'):
            # return the first view (profile) id.
            return profiles.get('items')[0].get('id')

    return None


def filter_main_ns(results):
    pages = []
    for r in results:
        url_title = re.match(r'^/w/([^/]+)$', r[1])
        if not url_title:
            continue
        else:
            url_title = url_title.group(1)

        if re.match(r'[a-zA-Z0-9_ ]+:.*', url_title):
            continue
        if re.match('.*\.php', url_title):
            continue

        match = re.match(r'(.+) - Metakgp Wiki', r[0])
        if not match:
            continue

        if match.group(1) in pages:
            continue

        pages.append(match.group(1))

    return pages


def get_popular_pages(service, profile_id):
    results = service.data().ga().get(
        ids='ga:' + profile_id,
        start_date='90daysAgo',
        end_date='today',
        metrics='ga:uniquePageviews',
        dimensions='ga:pageTitle, ga:pagePath',
        sort='-ga:uniquePageviews',
        max_results=50).execute()

    return filter_main_ns(results['rows'])


def get_trending_pages(service, profile_id):
    results = service.data().ga().get(
        ids='ga:' + profile_id,
        start_date='7daysAgo',
        end_date='today',
        metrics='ga:entrances',
        dimensions='ga:pageTitle, ga:landingPagePath',
        sort='-ga:entrances',
        max_results=50).execute()

    return filter_main_ns(results['rows'])


def update_list_of_pages(template, pages):
    template_page = pywikibot.Page(pywikibot.Link(template), pywikibot.Site())
    text = " <noinclude>This page is automatically generated. Changes will be overwritten, so '''do not modify'''.</noinclude>\n"
    for p in pages[:REQD_TEMPLATE_LEN]:
        text += "*[[%s]]\n" % p
    text = text.rstrip()
    if template_page.text == text:
        print template, 'unchanged, no edit made.'
        return
    else:
        print template, 'changed:'
        print text
        #diff = difflib.ndiff(template_page.text.splitlines(1),
        #                     text.splitlines(1))
        #for d in diff:
        #    print d,
        template_page.text = text
        template_page.save('Updated on ' +
                           date.today().strftime('%B %d, %Y'))

def deduplicate_lists(list_to_dedup, base_list):
    '''
    will return list_to_dedup after removing any element that exists in
    base_list

    will maintain the order of elements in list_to_dedup
    '''

    dict_from_list = OrderedDict.fromkeys(list_to_dedup)
    for elem in base_list:
        if elem in dict_from_list:
            list_to_dedup.remove(elem)

    return list_to_dedup

def main():
    # Define the auth scopes to request.
    scope = ['https://www.googleapis.com/auth/analytics.readonly']
    key_file_env = 'GOOGLE_ANALYTICS_SERVICE_KEY'

    # Authenticate and construct service.
    service = get_service('analytics', 'v3', scope, key_file_env)
    profile = get_first_profile_id(service)

    popular_pages = get_popular_pages(service, profile)
    update_list_of_pages('Template:Popular_pages', popular_pages)

    trending_pages = get_trending_pages(service, profile)
    trending_pages_deduped = deduplicate_lists( \
                                trending_pages, \
                                popular_pages[:REQD_TEMPLATE_LEN] \
                            )
    
    update_list_of_pages('Template:Trending_pages', trending_pages_deduped)

if __name__ == '__main__':
    main()
