# Metakgp Wiki Setup

[![Build Status](https://travis-ci.org/metakgp/metakgp-wiki.svg?branch=master)](https://travis-ci.org/metakgp/metakgp-wiki)

Dockerized for fun and profit.

New to Docker? See the [Runbook](./RUNBOOK.md) for some useful recipes.

**Note:** This readme is for development only, refer to the
[Runbook](./RUNBOOK.md) for commands to use in production.

## Contents

- [Metakgp Wiki Setup](#Metakgp-Wiki-Setup)
  - [Contents](#Contents)
  - [Installation instructions for prerequisites](#Installation-instructions-for-prerequisites)
  - [Quick start](#Quick-start)
    - [Option 1: Run the web installer](#Option-1-Run-the-web-installer)
    - [Option 2: Restore from backup](#Option-2-Restore-from-backup)
  - [Development](#Development)
    - [Compose configuration](#Compose-configuration)
    - [Volumes](#Volumes)
  - [Todo](#Todo)
  - [Contributing](#Contributing)
  - [Helping PRs](#Helping-PRs)

## Installation instructions for prerequisites

- [Docker](https://docs.docker.com/engine/installation/)
- [Docker compose](https://docs.docker.com/compose/install/)

## Quick start
Create a `.env` file at the repo root and add all the secrets.
```
cp .env.template .env
```

**Note:** Required environment variables:

- `MYSQL_PASSWORD`
- `SERVER_NAME`
- `SERVER_PORT`

Other variables inside `.env.template` are optional.

Start all the basic services

**Note:** Depending on how you installed docker, you might have to run the docker commands through `sudo`
```
docker compose up --build -d
```

Monitor the output to make sure nothing failed.

```
docker compose logs -f
```

Now you need to initialise the database. Pick one of the following
options.

### Option 1: Run the web installer

Remove LocalSettings.php
```
docker compose exec mediawiki rm /srv/mediawiki/LocalSettings.php
```

Go to http://localhost:8080 and complete the web installation. The
database user is `metakgp_user` and the database host is
`mysql-docker`. All the other configuration should be exactly the same
as your `.env` file.

After completing the installation, download the generated
`LocalSettings.php` file and move it into place.
```
docker cp <path to downloaded LocalSettings.php> $(docker compose ps -q mediawiki):/srv/mediawiki
```

Create the tables necessary for extensions.
```
docker compose exec mediawiki php /srv/mediawiki/maintenance/run.php update
```

Reload http://localhost:8080, you should see the main page.

### Option 2: Restore from backup

**Note: This is for production, no need to run this for development**

Check the [Runbook](./RUNBOOK.md)

***

Go to http://localhost:8080, you should see the main page.

## Development

### Compose configuration
`docker compose` supports
[multiple configuration files](https://docs.docker.com/compose/extends/#understanding-multiple-compose-files).
`docker-compose.yml` is the base config, and
`docker-compose.override.yml` is the default override. This is set up
so that while developing, you can just use `docker compose <command>`,
and it will work.

For production, we want to run some additional services (like backups),
so we need to specify `docker-compose.prod.yml` as an _additional_
override.

For integration tests, we want to make sure that volumes created
during integration tests don't overwrite volumes being used for
development. We use `test/integration/docker-compose.test.yml` as the
override instead.

Overrides can be applied by using the `-f` option. See
`test/integration/run_tests.sh` for an example.
```
docker compose -f docker-compose.yml -f <another compose file>
```

### Volumes
We use [Docker volumes](https://docs.docker.com/engine/tutorials/dockervolumes/)
to persist data between container rebuilds (eg. mysql database), and
to share data between containers (eg. mediawiki volume shared between
nginx and php).

When rebuilding/restarting containers, keep in mind that volumes are
not automatically recreated. If a volume already exists, it will be
attached to the new container. If you want a "clean" build, you need
to make sure any existing volumes are removed.

List volumes:
```
docker compose volume ls
```

Remove the volumes you want to recreate:
```
docker compose volume rm <volume name>
```

## Todo

Check the [issues
dashboard](https://github.com/metakgp/metakgp-wiki/issues?q=is%3Aissue+is%3Aopen+label%3Afeature).

## Contributing

Please read CONTRIBUTING.md guide to know more.

## Helping PRs

This section lists PRs that can be viewed as example for performing particular updates or maintenance tasks.

- How to change captcha service used with ConfirmEdit extension. [#56](https://github.com/metakgp/metakgp-wiki/pull/56)
- How to upgrade mediawiki version. [#60](https://github.com/metakgp/metakgp-wiki/pull/60)
