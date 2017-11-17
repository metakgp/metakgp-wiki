# Runbook

## Deploying to prod

0. Take a backup! Run `docker-compose exec backup run_backup.sh` and make sure it succeeded. Also run `git log` and note down the current deployed sha, in case you need to roll back.
1. `git pull` and `docker-compose build`. This builds and caches the new images locally without interrupting the old server, which reduces downtime.
2. `docker-compose down` shuts down the server and removes containers. Now downtime has started ticking.
3. Copy any assets you need from the mediawiki volume `docker-compose cp ...`. Right now this is just images, but we should move everything to static so this step is unnecessary.
4. `docker volume rm <mediawiki-volume>`, so that the mediawiki container can create a new volume with updates in the next step.
5. `docker-compose up --build -d` starts all the services using the newly built images. Server is back online, verify by going to the wiki in a browser. If there are database problems, it's often fixed by running `docker-compose exec php /srv/mediawiki/maintenance/update.php`.
6. Restore images `docker-compose cp ...`

## Docker

> Docker is hard, let this file be your guide if your only goal is to ensure the
> server is running

* I just want everything to start and run like a normal server

    ```sh
    $ cd path/to/docker-compose.yml
    # if something is already running, shut it all down
    $ docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.prod.yml down
    # check to see if anything else is running
    $ docker ps
    # now, start all containers!
    $ docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.prod.yml up -d --build
    ```

* I want to retrieve the latest backup

    ```sh
    # ensure that the backup container is running
    $ docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.prod.yml exec backup /bin/bash
    # this will drop you into the container's bash
    container $ ./run_backup.sh
    container $ ls /root/backups # to ensure that the backup tar was created
    container $ exit
    # now copy the created tar file into the host filesystem
    # docker cp doesn't take wildcard paths (??)
    $ docker cp metakgpwiki_backup_1:/root/backups/metakgpwiki_2017_10_23_10_11_44.tar.gz .
    $ pwd
    ```

    Now, `rsync` takes over. You need to `rsync` or `scp` this file back to your
    computer. This step is out of the scope of this tutorial. Check out
    [`rsync`'s man page](https://linux.die.net/man/1/rsync) for instructions.

* I want to restore a MySql backup

    ```sh
    $ ./script/restore-from-backup.sh <path-to-sql-file>
    ```

    You have to `rsync` the tar.gz archive to the host filesystem and extract
    it. Inside the archive, you will find the sql file whose path you must
    supply to the `restore-from-backup.sh` script.

* I want to copy a file from the filesystem into a container

    ```sh
    # copy a file from the container to the host filesystem
    $ docker cp metakgpwiki_nginx_1:/srv/mediawiki/LocalSettings.php .

    # copy a file from the host filesystem to a container
    $ docker cp Local.php metakgpwiki_nginx_1:/srv/mediawiki/LocalSettings.php
    ```

## Mediawiki

* I want to upgrade to a new mediawiki version

    You have to run `maintenance/update.php` after installing a new extension or 
    upgrading mediawiki. This will update the database tables as necessary.
    
    ```
    docker-compose exec php /srv/mediawiki/maintenance/update.php
    ```
