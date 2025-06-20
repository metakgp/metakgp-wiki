<?php
# This file was automatically generated by MediaWiki 1.24.2 and then updated over the years by real, flesh and blood based, sentient, and really hardworking/stupid humans.
if (!defined('MEDIAWIKI')) {
  exit;
}

$wgSitename = "Metakgp Wiki";
$wgMetaNamespace = "Metakgp";

wfLoadSkin('Vector');
wfLoadSkin('MinervaNeue'); # mobile optimised

## The URL base path to the directory containing the wiki;
## defaults for all runtime URL paths are based off of this.
## For more information on customizing the URLs
## (like /w/index.php/Page_title to /wiki/Page_title) please see:
## https://www.mediawiki.org/wiki/Manual:Short_URL
$wgScriptPath = "";
$wgArticlePath = "/w/$1";
$wgScriptExtension = ".php";
$wgUsePathInfo = true;

## The protocol and server name to use in fully-qualified URLs
# $wgServer = "https://wiki.metakgp.org";
$wgServer = getenv('SERVER_NAME', true);

## The relative URL path to the skins directory
$wgStylePath = "$wgScriptPath/skins";

## The relative URL path to the logo.  Make sure you change this from the default,
## or else you'll overwrite your logo when you upgrade!
$wgLogo = "$wgScriptPath/resources/assets/metakgp_logo.png";
$wgFavicon = "$wgScriptPath/resources/assets/metakgp_favicon.png";

## UPO means: this is also a user preference option

$wgEnableEmail = true;
$wgEnableUserEmail = true; # UPO
// $wgEmailConfirmToEdit = true;

$wgEmergencyContact = "admin@wiki.metakgp.org";
$wgPasswordSender = "no-reply@wiki.metakgp.org";

$wgEnotifUserTalk = true; # UPO
$wgEnotifWatchlist = true; # UPO
$wgEmailAuthentication = true;

## Database settings
$wgDBtype = "mysql";
$wgDBserver = "mysql-docker";
$wgDBname = "metakgp_wiki_db";
$wgDBuser = "metakgp_user";
$wgDBpassword = getenv('MYSQL_PASSWORD', true);

# MySQL specific settings
$wgDBprefix = "";

# MySQL table options to use during installation or update
$wgDBTableOptions = "ENGINE=InnoDB, DEFAULT CHARSET=binary";

# Experimental charset support for MySQL 5.0.
$wgDBmysql5 = false;

## Shared memory settings
$wgMainCacheType = CACHE_ACCEL;
$wgMemCachedServers = [];
# Make sure logins work (https://phabricator.wikimedia.org/T147161)
$wgSessionCacheType = CACHE_DB;

## To enable image uploads, make sure the 'images' directory
## is writable, then set this to true:
$wgTmpDirectory = "$IP/images/temp";
$wgEnableUploads = true;

$wgUseImageMagick = false;
$wgCustomConvertCommand = "/usr/bin/gm convert %s -resize %wx%h %d";

# For extension PdfHandler
$wgPdfPostProcessor = "/opt/gmconvert.sh";

# InstantCommons allows wiki to use images from http://commons.wikimedia.org
$wgUseInstantCommons = true;

## If you use ImageMagick (or any other shell command) on a
## Linux server, this will need to be set to the name of an
## available UTF-8 locale
$wgShellLocale = "en_US.utf8";

$wgLocaltimezone = "Asia/Kolkata";
date_default_timezone_set($wgLocaltimezone);

## Set $wgCacheDirectory to a writable directory on the web server
## to make your wiki go slightly faster. The directory should not
## be publically accessible from the web.
$wgCacheDirectory = "$IP/cache";

# Site language code, should be one of the list in ./languages/Names.php
$wgLanguageCode = "en";

$wgSecretKey = getenv("WG_SECRET_KEY", true);

# Site upgrade key. Must be set to a string (default provided) to turn on the
# web installer while LocalSettings.php is in place
$wgUpgradeKey = getenv("SITE_UPGRADE_KEY", true);

## For attaching licensing metadata to pages, and displaying an
## appropriate copyright notice / icon. GNU Free Documentation
## License and Creative Commons licenses are supported so far.
$wgRightsPage = ""; # Set to the title of a wiki page that describes your license/copyright
$wgRightsUrl = "https://creativecommons.org/licenses/by-sa/4.0/";
$wgRightsText = "Creative Commons Attribution-ShareAlike";
$wgRightsIcon = "{$wgResourceBasePath}/resources/assets/licenses/cc-by-sa.png";

# Path to the GNU diff3 utility. Used for conflict resolution.
$wgDiff3 = "/usr/bin/diff3";

## Default skin: you can change the default skin. Use the internal symbolic
## names, ie 'vector', 'monobook':
$wgDefaultSkin = "vector";

# End of automatically generated settings.
# Add more configuration options below.

// mail configuration (with Mailgun)
$wgSMTP = array(
  'host' => 'smtp.mailgun.org',
  'IDHost' => 'username.mailgun.org',
  'port' => 587,
  'username' => getenv('MAILGUN_EMAIL', true),
  'password' => getenv('MAILGUN_PASSWORD', true),
  'auth' => true
);

# Search configuration
$wgAdvancedSearchHighlighting = true;

$wgNamespacesToBeSearchedDefault = array(
  NS_MAIN => true,
  NS_TALK => false,
  NS_USER => true,
  NS_USER_TALK => false,
  NS_PROJECT => true,
  NS_PROJECT_TALK => false,
  NS_FILE => true,
  NS_FILE_TALK => false,
  NS_HELP => true,
  NS_HELP_TALK => false,
  NS_CATEGORY => true,
  NS_CATEGORY_TALK => false
);

# Load all extensions
wfLoadExtension('ParserFunctions');
wfLoadExtension('Cite');

wfLoadExtension("NewestPages");
wfLoadExtension('WikimediaMessages');

wfLoadExtension('WikiEditor');
$wgDefaultUserOptions['usebetatoolbar'] = 1;
$wgDefaultUserOptions['usebetatoolbar-cgd'] = 1;
$wgDefaultUserOptions['wikieditor-preview'] = 1;
#$wgDefaultUserOptions['wikieditor-publish'] = 1;

wfLoadExtension('Gadgets');
wfLoadExtension('Echo');

// Use 'noanalytics' permission to exclude specific user groups from web analytics, e.g.
$wgGroupPermissions['sysop']['noanalytics'] = true;
$wgGroupPermissions['bot']['noanalytics'] = true;

wfLoadExtension('MobileFrontend');
$wgMFAutodetectMobileView = true;
$wgMFDefaultSkinClass = 'SkinMinerva';

wfLoadExtension("ContributionScores");
$wgContribScoreIgnoreBots = true;          // Exclude Bots from the reporting - Can be omitted.
$wgContribScoreIgnoreBlockedUsers = true;  // Exclude Blocked Users from the reporting - Can be omitted.
$wgContribScoresUseRealName = true;        // Use real user names when available - Can be omitted. Only for MediaWiki 1.19 and later.
$wgContribScoreDisableCache = false;       // Set to true to disable cache for parser function and inclusion of table.

$wgContribScoreReports = array(
  array(7, 50),
  array(30, 50),
  array(0, 50)
);

$wgMaxShellMemory = 307200;
$wgMaxImageArea = 1250000000; // 1.25e9

wfLoadExtension('SyntaxHighlight_GeSHi');

# Set up google analytics extension
require_once "$IP/extensions/googleAnalytics/googleAnalytics.php";
$wgGoogleAnalyticsAccount = getenv('GOOGLE_ANALYTICS_ACCOUNT', true);

// Optional configuration (for defaults see googleAnalytics.php)
// Store full IP address in Google Universal Analytics (see https://support.google.com/analytics/answer/2763052?hl=en for details)
$wgGoogleAnalyticsAnonymizeIP = false;

wfLoadExtensions(array(
  'ConfirmEdit',
  'ConfirmEdit/QuestyCaptcha'
));

$wgCaptchaClass = 'QuestyCaptcha';

# case-insensitive, but answers must be written here in lowercase
$wgCaptchaQuestions = [
  'What is the 3 letter station code for Kharagpur Railway Junction?' => 'kgp',
  'What is the capital of the state IIT KGP is in' => ['kolkata, calcutta'],
  'What is the name of our social-cultural fest?' => ['springfest', 'spring fest', 'sf'],
  'What is the name of our techno-management fest?' => ['kshitij', 'ktj'],
  'What is the closest neighbouring country to IIT KGP?' => 'bangladesh',
  'Which is the worst operating system known to mankind?' => ['windows', 'windows 11', 'windows 8', 'win']
];

# Present captcha by default
$wgCaptchaTriggers['edit'] = true;
$wgCaptchaTriggers['create'] = true;

# Skip CAPTCHA for the no-captcha group
$wgGroupPermissions['no-captcha']['skipcaptcha'] = true;
# $ceAllowConfirmedEmail = true;

# Rate limit to prevent brute-forcing captchas
# 20 wrong captchas allowed every 10 minutes per IP
$wgRateLimits['badcaptcha']['ip'] = array(20, 10 * 60);

$wgJobRunRate = 1;
$wgRunJobsAsync = true;

$wgUseFileCache = true;
$wgFileCacheDirectory = "$IP/images/cache";
$wgShowIPInHeader = false;
$wgDisableCounters = true;
$wgEnableSidebarCache = true;

# Visual Editor
wfLoadExtension('VisualEditor');

// Enable by default for everybody
$wgDefaultUserOptions['visualeditor-enable'] = 1;

$wgVisualEditorAvailableNamespaces = [
  "Help" => true
];

wfLoadExtension( 'Parsoid', "$IP/vendor/wikimedia/parsoid/extension.json" );

# Default user options
$wgDefaultUserOptions['enotifusertalkpages'] = 1;
$wgDefaultUserOptions['enotifwatchlistpages'] = 1;
$wgDefaultUserOptions['usenewrc'] = 1;
$wgDefaultUserOptions['watchdefault'] = 1;

$wgRestrictDisplayTitle = false;

wfLoadExtension('CommonsMetadata');
wfLoadExtension("MultimediaViewer");
wfLoadExtension('Poem');

# File upload permissions
$wgGroupPermissions['user']['upload'] = true;
$wgGroupPermissions['user']['reupload-own'] = false;
$wgGroupPermissions['user']['reupload'] = false;
$wgGroupPermissions['user']['reupload-shared'] = false;
$wgGroupPermissions['uploadaccess']['upload'] = true;
$wgFileExtensions = array_merge($wgFileExtensions, array('pdf'));

# Autopatrol
$wgGroupPermissions['autopatrol'] = $wgGroupPermissions['user'];
$wgGroupPermissions['autopatrol']['autopatrol'] = true;

# Maintainers
$wgGroupPermissions['maintainers'] = $wgGroupPermissions['sysop'];

# Rm-spam
$wgGroupPermissions['rm-spam']['delete'] = true;
$wgGroupPermissions['rm-spam']['block'] = true;
$wgGroupPermissions['rm-spam']['blockemail'] = true;
$wgGroupPermissions['rm-spam']['nuke'] = true;

# Disable anonymous editing
$wgGroupPermissions['*']['edit'] = false;
$wgGroupPermissions['user']['edit'] = true;
$wgGroupPermissions['sysop']['edit'] = true;

# Spam mitigation
$wgGroupPermissions['user']['createtalk'] = false; # No user talk pages
$wgGroupPermissions['user']['sendemail'] = false;  # No email send
$wgGroupPermissions['user']['delete'] = false;     # No deletion
$wgNamespaceProtection[NS_USER] = ['nobody'];      # No user page editing/creation

# Autoconfirm
$wgAutoConfirmAge = 3 * 24 * 3600;
$wgAutoConfirmCount = 5;

# No captcha
$wgAutopromote['no-captcha'] = array(
  APCOND_INGROUPS,
  'autoconfirmed',
  'emailconfirmed'
);

# Allow CORS
$wgCrossSiteAJAXdomains = array('*');

# Slack integration
wfLoadExtension('SlackNotifications');

# Slack extension configuration options
$wgSlackIncomingWebhookUrl = getenv('SLACK_CHANGES_WH_URL', true);
$wgSlackFromName = "Batman";
$wgSlackNotificationWikiUrl = $wgServer . "/";
$wgSlackIconURL = "https://i.picresize.com/images/2015/09/20/tdpsU.jpg";
$wgSlackSendMethod = "exec_curl";
$wgSlackIncludeUserUrls = false;
$wgSlackShowNewUserEmail = false;
$wgSlackShowNewUserFullName = false;
$wgSlackShowNewUserIP = false;

# Add subpages for main namespace
$wgNamespacesWithSubpages[NS_MAIN] = true;

# Math
// Set MathML as default rendering option;
$wgDefaultUserOptions['math'] = 'mathml';
# $wgMathFullRestbaseURL= 'http://127.0.0.1:10044';

# Nuke extension for mass deleting pages
wfLoadExtension('Nuke');

# InputBox extension for nice boxes
wfLoadExtension('InputBox');

# Sandbox extension;
wfLoadExtension('SandboxLink');

# Blocks edits with any link in the list of blocked urls
wfLoadExtension('SpamBlacklist');

# Use Mediawiki global block list and Wikipedia block list
# See https://www.mediawiki.org/wiki/Extension:SpamBlacklist#Examples
$wgSpamBlacklistFiles = array(
  "[[m:Spam blacklist]]",
  "https://en.wikipedia.org/wiki/MediaWiki:Spam-blacklist"
);

# Bump the Perl Compatible Regular Expressions backtrack memory limit
# (PHP 5.3.x default, 1000K, is too low for SpamBlacklist)
# See https://www.mediawiki.org/wiki/Extension:SpamBlacklist#Issues
ini_set('pcre.backtrack_limit', '8M');

# CheckUser for spam control
wfLoadExtension('CheckUser');
$wgGroupPermissions['sysop']['checkuser'] = true;
$wgGroupPermissions['sysop']['checkuser-log'] = true;

# DNS-based real-time spam blacklist
$wgEnableDnsBlacklist = true;
$wgDnsBlacklistUrls = array('sbl.spamhaus.org.');

wfLoadExtension('SimpleBatchUpload');

# Bots
$wgGroupPermissions['whitelisted-bot']['editprotected'] = true;

# Maps extension; installed through composer
wfLoadExtension('Maps');

# ArticleFeedbackv5
wfLoadExtension('ArticleFeedbackv5');
$wgArticleFeedbackv5LotteryOdds = 100;

# StopForumSpam
wfLoadExtension('StopForumSpam');
$wgSFSIPListLocation = "$IP/extensions/StopForumSpam/listed_ip_30_all.txt";

# Scribunto Extension, bundled with MediaWiki 1.34
wfLoadExtension('Scribunto');
$wgScribuntoDefaultEngine = 'luastandalone';

# Show exception details in development environment
$wgShowExceptionDetails = getenv('DEV', true);
