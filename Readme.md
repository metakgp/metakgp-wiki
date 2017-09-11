# Metakgp Wiki Setup
[![Build Status](https://travis-ci.org/metakgp/metakgp-wiki.svg?branch=master)](https://travis-ci.org/metakgp/metakgp-wiki)

Dockerized for fun and profit.

## Prerequisites
- Install [Docker](https://docs.docker.com/engine/installation/)

## Quick start
Create a `.env` file at the repo root and add all the required secrets.
```
cp .env.template .env
```

Start all the basic services

**Note:** Depending on how you installed docker, you might have to run the docker commands through `sudo`
```
docker-compose up --build -d
```

Monitor the output to make sure nothing failed.
```
docker-compose logs -f
```

Now you need to initialise the database. Pick one of the following
options.

### Run the web installer

Remove LocalSettings.php
```
docker-compose exec php rm /srv/mediawiki/LocalSettings.php
```

Go to http://localhost:8080 and complete the web installation. The
database user is `metakgp_user` and the database host is
`mysql-docker`. All the other configuration should be exactly the same
as your `.env` file.

After completing the installation, download the generated
`LocalSettings.php` file and move it into place.
```
docker cp <path to downloaded LocalSettings.php> $(docker-compose ps -q php):/srv/mediawiki
```

Create the tables necessary for extensions.
```
docker-compose exec php php /srv/mediawiki/maintenance/update.php
```

Reload http://localhost:8080, you should see the main page.

### Restore from backup
```
./scripts/restore-from-backup.sh <path to backup>
```

Go to http://localhost:8080, you should see the main page.

## Development

### Compose configuration
`docker-compose` supports
[multiple configuration files](https://docs.docker.com/compose/extends/#understanding-multiple-compose-files).
`docker-compose.yml` is the base config, and
`docker-compose.override.yml` is the default override. This is set up
so that while developing, you can just use `docker-compose <command>`,
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
docker-compose -f docker-compose.yml -f <another compose file>
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
docker-compose volume ls
```

Remove the volumes you want to recreate:
```
docker-compose volume rm <volume name>
```

## Todo
- Enable VisualEditor
- Restore images, peqp
- Measure performance
