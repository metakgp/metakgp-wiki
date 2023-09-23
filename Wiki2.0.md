### What Was Done to Update the Wiki
- Composer was installed using new method.
- Removed `composer.local.json` and instead used composer require to install the Maps extension.
	- Many workarounds were used - ignored superuser, ignored some php extension stuff
- Updated LocalSettings.php
- Upgraded both `mediawiki` and `php` containers to `php:8.2-fpm-bookworm`
- Upgraded to mediawiki version `1.40`
- Some extensions are now bundled with MediaWiki, removed them from `install_extensions.sh`
- Removed parsoid container entirely and loaded the Parsoid extension in LocalSettings.php instead. It is now bundled with MediaWiki and automatically used by the VisualEditor extension.

### What Can Be Done
- Need to create `metakgp-wiki_main_network` docker network manually.
- Why are `php` and `mediawiki` two separate containers? Can merge the two.
- nginx can be split from this repo. It can be maintained separately since it includes other projects' configuration.
- Is `SlackNotifications` extension required in this repo? Can it not be installed in the same manner used for all other extensions?
- Update docs:
	- Running `maintenance/update.php` directly has been deprecated. Have to run `maintenance/run.php` instead.
	- Update about how to take and restore backups.

### How Much to Simplify?
The wiki is over-engineered. This makes it hard to update and maintain but to what extent should we simplify it? Simplifying it to the point of not needing any management at all makes no sense, it will be the same as using an externally managed cloud-hosted Mediawiki instance.

Self-hosting the wiki has many benefits such as getting complete control over the configuration, the extensions, etc. But more importantly, it is a good project to learn a lot about Docker, Docker compose, Nginx, and many other tools.