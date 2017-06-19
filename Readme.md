# Metakgp Wiki Setup
[![Build Status](https://travis-ci.org/amrav/metakgp-wiki.svg?branch=master)](https://travis-ci.org/amrav/metakgp-wiki)

Dockerized for fun and profit.

## Installation instructions for prerequisites
- [Docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04)
- [Docker compose](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-16-04)

## Setup
- Create a `.env` file at the repo root with all the required secrets.
```
cp .env.template .env # now modify .env
```
- Run:
```
docker-compose up
```
Monitor the output to make sure nothing failed.

- Restore from backup (This is for production, no need to run this for development):
```
./scripts/restore-from-backup.sh <path to backup>
```
- Go to localhost:8080 and gaze upon its wonder.

## Development
Make sure that your changes are actually being picked up. If you don't mind *deleting all docker volumes*, you can run `./scripts/clean-build.sh`.

## Todo
- Enable remaining extensions
- Restore images, peqp
- Measure performance
