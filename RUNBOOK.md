# Runbook

## Upgrading MediaWiki Version

Please follow below instructions in order to upgrade the mediawiki version. Refer to [this Pull Request](https://github.com/metakgp/metakgp-wiki/pull/53/files) for an example.

1. Update `mediawiki/Dockerfile` to download the targeted version.
1. Update `mediawiki/install_extensions.sh` to download compatible mediawiki extensions.
1. Read through the change log and see if any other updates need to be made.
1. Try to build, and rectify errors.
1. Follow instructions mentioned in "Deploying to prod" section.
1. Run `docker compose exec mediawiki /srv/mediawiki/maintenance/run.php update`

## Deploying to prod

1. Run the deploy script

``` sh
$ sudo SLACK_NOTIFICATIONS_URL=$(SLACK_NOTIFICATIONS_URL) /root/metakgp-wiki/scripts/deploy-latest.sh --go
```

_Note:_ The `--go` flag indicates that the deployment will be completed. For a dry run, run the same
command without that flag at the end.

To get the `SLACK_NOTIFICATIONS_URL`, go to Manage Apps -> Custom Integrations -> Incoming Webhooks -> Choose to edit "Posts to #server as Deployment Notifications" -> copy Webhook URL.

### Deprecated

**Note:** Manual operation for regular configuration updates is now deprecated. Please use the
deploy script: [./scripts/deploy-latest.sh](./scripts/deploy-latest.sh).

1. Take a backup! Run `docker compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.prod.yml exec backup ./run_backup.sh` and make sure it succeeded. Also run `git log` and note down the current deployed sha, in case you need to roll back.
1. `git pull` and `docker compose build`. This builds and caches the new images locally without interrupting the old server, which reduces downtime.
1. `docker compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.prod.yml down` shuts down the server and removes containers. Now downtime has started ticking.
1. `docker volume rm metakgp-wiki_mediawiki-volume`, so that the mediawiki container can create a new volume with updates in the next step.
1. `docker compose up --build -d` starts all the services using the newly built images. Server is back online, verify by going to the wiki in a browser. If there are database problems, it's often fixed by running `docker compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.prod.yml exec mediawiki /srv/mediawiki/maintenance/run.php update`.

## Docker

> Docker is hard, let this file be your guide if your only goal is to ensure the
> server is running

### I just want everything to start and run like a normal server

```sh
$ cd path/to/docker-compose.yml
# if something is already running, shut it all down
$ docker compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.prod.yml down
# check to see if anything else is running
$ docker ps
# now, start all containers!
$ docker compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.prod.yml up -d --build
```

### I want to retrieve the latest backup

```sh
# ensure that the backup container is running and drop into the container's bash
$ docker compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.prod.yml exec backup /bin/bash
# below command will create a new backup of the server
container $ ./run_backup.sh
# to ensure that the backup tar was created
container $ ls /root/backups
container $ exit
# now copy the created tar file into the host filesystem
# docker cp doesn't take wildcard paths (??)
$ docker cp metakgp-wiki_backup_1:/root/backups/metakgpwiki_2017_10_23_10_11_44.tar.gz .
$ pwd
```

Now, `rsync` takes over. You need to `rsync` or `scp` this file back to your
computer. This step is out of the scope of this tutorial. Check out
[`rsync`'s man page](https://linux.die.net/man/1/rsync) for instructions.

### I want to spawn a metakgp server from a backup

**Note:** Currently, the backup contains of a single SQL file.

```sh
$ # install docker and docker-compose
$ git clone https://github.com/metakgp/metakgp-wiki.git
$ cd metakgp-wiki
$ docker compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.prod.yml up --build -d
$ ./script/restore-from-backup.sh <path to sql file>
```

### I want to restore a MySql backup

```sh
$ ./script/restore-from-backup.sh <path-to-sql-file>
```

You have to `rsync` the tar.gz archive to the host filesystem and extract
it. Inside the archive, you will find the sql file whose path you must
supply to the `restore-from-backup.sh` script.

### I want to copy a file from the host filesystem into a container

```sh
# copy a file from the container to the host filesystem
$ docker cp metakgpwiki_nginx_1:/srv/mediawiki/LocalSettings.php .

# copy a file from the host filesystem to a container
$ docker cp Local.php metakgpwiki_nginx_1:/srv/mediawiki/LocalSettings.php
```

### I want to spawn a clone of the current metakgp server

```txt
1. Get the backup from the current server
2. Copy this backup to the new server
3. Spawn a server from this backup
```

**Note** Visit `http://<NEW_SERVER_IP>/w/Main_Page>` to see your newly
installed wiki. Redirection from `http://<NEW_SERVER_IP/` to the Wiki's main
page may not work.

### I want to clean up all the containers, images and volumes on a server

**NOTE** This is a destructive operation. **DO NOT** do this in production.

```sh
# shut down all the containers before doing this
$ docker compose down
$ docker system prune -a
$ docker volume prune
```

## Mediawiki

### I want to upgrade to a new mediawiki version

You have to run `maintenance/run.php update` after installing a new extension or
upgrading mediawiki. This will update the database tables as necessary.

```sh
$ docker compose exec mediawiki /srv/mediawiki/maintenance/run.php update
```
