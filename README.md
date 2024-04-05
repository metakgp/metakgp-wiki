<div id="top"></div>

<!-- PROJECT SHIELDS -->
<div align="center">

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![Wiki][wiki-shield]][wiki-url]

</div>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/metakgp/metakgp-wiki">
    <img width="140" alt="image" src="https://raw.githubusercontent.com/metakgp/design/main/logos/logo.jpg">
  </a>

  <h3 align="center">MetaKGP Wiki</h3>

  <p align="center">
    <i>Dockerized for fun and profit.</i>
    <br />
    <a href="https://wiki.metakgp.org">Wiki</a>
    ·
    <a href="https://github.com/metakgp/metakgp-wiki/issues">Report Bug / Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
<summary>Table of Contents</summary>

- [About](#about-the-project)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Deployment](#deployment)
    - [Development](#development)
    - [Production](#production)
    - [Environment Variables](#environment-variables)
    - [Setting Up Secondary Services](#setting-up-secondary-services)
- [Runbook](./RUNBOOK.md)
- [Maintainer(s)](#maintainers)
- [Contact](#contact)
- [Additional documentation](#additional-documentation)

</details>

<!-- ABOUT THE PROJECT -->
## About
This is the dockerized source for the MetaKGP Wiki deployed at https://wiki.metakgp.org. The wiki is a [Mediawiki](https://mediawiki.org) instance with some extensions and services that take backups and update certain pages.

It is hosted on a DigitalOcean droplet with 2GB RAM and a single CPU. See [MetaPloy](https://github.com/metakgp/metaploy) for the deployment architecture.

### Architecture

<p align="right">(<a href="#top">back to top</a>)</p>

## Getting Started
See also: [The Runbook](./RUNBOOK.md) for a quick reference to processes needed to manage a production wiki.

### Prerequisites
Docker and docker compose are the only required dependencies. You can either install [Docker Desktop](https://docs.docker.com/get-docker/) or the [Docker Engine](https://docs.docker.com/engine/install/). For minimal installations and production use cases, Docker Engine is recommended.

<p align="right">(<a href="#top">back to top</a>)</p>

### Deployment
> **NOTE**: See the [#Production](#production) section for production deployment. DO NOT follow the development instructions in a production environment.

#### Development
0. Set up [MetaPloy](https://github.com/metakgp/metaploy).
1. Clone this repository.
2. Copy the contents of the `.env.template` file into the `.env` file. Create the file if it doesn't exist.
3. Set the necessary [environment variables](#environment-variables).
4. Run `docker compose up` to start the wiki. The wiki will be accessible on `localhost:8080` or whichever port MetaPloy is set to use.

<p align="right">(<a href="#top">back to top</a>)</p>

#### Production
0. Set up [MetaPloy](https://github.com/metakgp/metaploy) **for production**.
1. Clone this repository at a convenient location such as `/deployments`.
2. Set the appropriate **production** [environment variables](#environment-variables) in the `.env` file.
3. Run `docker compose -f docker-compose.prod.yml up` to start the wiki. This enables the `jobs` service which includes backups, log rotation, and other periodic jobs.
4. Optionally set up a Systemd service to start the wiki on startup.

<p align="right">(<a href="#top">back to top</a>)</p>

#### Environment Variables
Environment variables can be set using a `.env` file(use `.env.template` file for reference). The following variables are used:

- `DEV`: When set to `true`, Mediawiki PHP stack-trace is shown with error messages. (Default: `false`)
- `MYSQL_PASSWORD`: A secret password for the MySQL database.
- `SERVER_PORT`: Port on which the wiki server is exposed to the host. (Default: `8080`)
- `SERVER_NAME`: Base URL of the wiki (eg: `https://wiki.metakgp.org`).
- `MAILGUN_EMAIL`: The email ID used for sending emails via Mailgun. (eg: `admin@wiki.metakgp.org`)
- `MAILGUN_PASSWORD`: Mailgun SMTP password for sending official mails from the wiki.
- `WG_SECRET_KEY`: Secret key used for encryption by mediawiki. Make it a long, random, secret string ([Reference](https://www.mediawiki.org/wiki/Special:MyLanguage/Manual:$wgSecretKey)).
- Dropbox related variables (used for storing backups) (See [this](#dropbox-backups) section for details):
	- `DROPBOX_APP_KEY`:  Dropbox app key (can be found at [Dropbox App Console](https://www.dropbox.com/developers/apps)).
	- `DROPBOX_APP_SECRET`:  Dropbox app secret (can be found at [Dropbox App Console](https://www.dropbox.com/developers/apps)).
	- `DROPBOX_ACCESS_TOKEN`: Dropbox API access token (generated using `/scripts/get_dropbox_tokens.py`)
	- `DROPBOX_REFRESH_TOKEN`: Dropbox API refresh token (generated using `/scripts/get_dropbox_tokens.py`) used to refresh the access token.
- `SLACK_CHANGES_WH_URL`: URL to the Slack webhook used to send updates about wiki changes. (See [this](#slack-notifications) section for more details)
- `SLACK_INCIDENTS_WH_URL`: URL to the Slack webhook used to send incidents reports and errors(like Dropbox backup failure). (See [this](#slack-notifications) section for more details)
- `BATMAN_BOT_PASSWORD`: A generated password of the Batman bot user account on the wiki(Mediawiki documentation to generate bot passwords can be found [here](https://www.mediawiki.org/wiki/Manual:Pywikibot/BotPasswords)).

#### Setting Up Secondary Services
##### Dropbox Backups
The `jobs` service runs periodic local backups (see `/jobs/backups`) and stores the last 30 days of backups on [Dropbox](https://dropbox.com). To set this up, a Dropbox app has to be created, and access tokens need to be generated:

1. Create an app on the [Dropbox App Console](https://www.dropbox.com/developers/apps).
2. Copy the app key and app secret and set the corresponding [environment variables](#environment-variables).
3. Run the script `/scripts/get_dropbox_tokens.py` and when prompted, enter the app key and app secret.
4. Set the generated API access token and refresh tokens in the environment variables.

##### Slack Notifications
The Slack notifications are sent via [webhooks](https://api.slack.com/messaging/webhooks). Two webhooks are used by the wiki: Recent Changes webhook and Incidents webhook (See [environment variables](#environment-variables)). The recent changes webhook logs recent changes to the wiki (page edits, user creation, etc.) and the incidents webhook notifies about server incidents such as backup failures.

1. Create a [Slack app](https://api.slack.com/apps/new).
2. Enable "Incoming Webhooks".
3. Copy the webhook URL and set the appropriate [environment variables](#environment-variables).

##### Mailgun
[Mailgun](https://www.mailgun.com/) is used by the wiki as a mailing service for sending various emails to the users such as account verification and notifications.

1. Add a new domain in the "Sending" section on Mailgun.
2. [Copy](https://help.mailgun.com/hc/en-us/articles/203380100-Where-Can-I-Find-My-API-Key-and-SMTP-Credentials) the SMTP password and set the appropriate [environment variables](#environment-variables).

##### PyWikiBot


##### Batman Bot


##### Google Analytics

## Maintainer(s)
- [Harsh Khandeparkar](https://github.com/harshkhandeparkar)

<p align="right">(<a href="#top">back to top</a>)</p>

## Contact
<p>
📫 Metakgp -
<a href="https://bit.ly/metakgp-slack">
  <img align="center" alt="Metakgp's slack invite" width="22px" src="https://raw.githubusercontent.com/edent/SuperTinyIcons/master/images/svg/slack.svg" />
</a>
<a href="mailto:metakgp@gmail.com">
  <img align="center" alt="Metakgp's email " width="22px" src="https://raw.githubusercontent.com/edent/SuperTinyIcons/master/images/svg/gmail.svg" />
</a>
<a href="https://www.facebook.com/metakgp">
  <img align="center" alt="metakgp's Facebook" width="22px" src="https://raw.githubusercontent.com/edent/SuperTinyIcons/master/images/svg/facebook.svg" />
</a>
<a href="https://www.linkedin.com/company/metakgp-org/">
  <img align="center" alt="metakgp's LinkedIn" width="22px" src="https://raw.githubusercontent.com/edent/SuperTinyIcons/master/images/svg/linkedin.svg" />
</a>
<a href="https://twitter.com/metakgp">
  <img align="center" alt="metakgp's Twitter " width="22px" src="https://raw.githubusercontent.com/edent/SuperTinyIcons/master/images/svg/twitter.svg" />
</a>
<a href="https://www.instagram.com/metakgp_/">
  <img align="center" alt="metakgp's Instagram" width="22px" src="https://raw.githubusercontent.com/edent/SuperTinyIcons/master/images/svg/instagram.svg" />
</a>
</p>

<p align="right">(<a href="#top">back to top</a>)</p>

## Additional documentation
  - [License](/LICENSE)
  - [Code of Conduct](/.github/CODE_OF_CONDUCT.md)
  - [Security Policy](/.github/SECURITY.md)
  - [Contribution Guidelines](/.github/CONTRIBUTING.md)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->

[contributors-shield]: https://img.shields.io/github/contributors/metakgp/metakgp-wiki.svg?style=for-the-badge
[contributors-url]: https://github.com/metakgp/metakgp-wiki/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/metakgp/metakgp-wiki.svg?style=for-the-badge
[forks-url]: https://github.com/metakgp/metakgp-wiki/network/members
[stars-shield]: https://img.shields.io/github/stars/metakgp/metakgp-wiki.svg?style=for-the-badge
[stars-url]: https://github.com/metakgp/metakgp-wiki/stargazers
[issues-shield]: https://img.shields.io/github/issues/metakgp/metakgp-wiki.svg?style=for-the-badge
[issues-url]: https://github.com/metakgp/metakgp-wiki/issues
[license-shield]: https://img.shields.io/github/license/metakgp/metakgp-wiki.svg?style=for-the-badge
[license-url]: https://github.com/metakgp/metakgp-wiki/blob/master/LICENSE
[wiki-shield]: https://custom-icon-badges.demolab.com/badge/metakgp_wiki-grey?logo=metakgp_logo&logoColor=white&style=for-the-badge
[wiki-url]: https://wiki.metakgp.org
