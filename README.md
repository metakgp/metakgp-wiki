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

<p align="right">(<a href="#top">back to top</a>)</p>

#### Environment Variables

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
