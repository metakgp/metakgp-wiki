# MetaMaint - script to add a random package to MetaKGP homepage.

import pywikibot
from random import randint
from datetime import date

def main():
    site = pywikibot.Site()
    
    # Read package blurbs
    rpage = pywikibot.Page(site, 'Metakgp:Package_blurbs')
    data = rpage.text
    packages = data.split('<hr>')[1:]
    
    # Generate a random package blurb

    header = "<noinclude>This page is automatically generated. Changes will be overwritten, so '''do not modify'''.</noinclude>\n"

    wpage = pywikibot.Page(site, 'Template:Random_package')
    wpage.text = header+packages[randint(1, len(packages))] # TODO: Replace random mode by frecency.
    wpage.save(('Updated on ' + date.today().strftime('%B %d, %Y')))

if __name__ == '__main__':
    main()
