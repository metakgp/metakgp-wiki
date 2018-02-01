#!/usr/bin/env bash

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

set -e

REPO_ROOT=$(git rev-parse --show-toplevel)
TEST_ROOT="$REPO_ROOT/test/integration"
DOCKER_CONFIG="-f $REPO_ROOT/docker-compose.yml -f $TEST_ROOT/docker-compose.test.yml"
DOCKER_COMPOSE="docker-compose $DOCKER_CONFIG"
WIKI="/srv/mediawiki"

cd $TEST_ROOT
source .env

function info {
    echo -e "${YELLOW}$1${NC}"
}

function error {
    echo -e "${RED}$1${NC}"
    exit 1
}

function cleanup {
    EXIT_CODE=$?

    if [[ $EXIT_CODE != 0 && $($DOCKER_COMPOSE top) != "" ]]; then
        info "Dumping logs"
        $DOCKER_COMPOSE logs
    fi

    info "Cleaning up"
    $DOCKER_COMPOSE down --volumes

    if [[ $EXIT_CODE == 0 ]]; then
        echo -e "${GREEN}All tests passed.${NC}"
    else
        echo -e "${RED}Test failure(s)!${NC}"
    fi

    exit $EXIT_CODE
}

info "Making sure no services are running"
if [[ $($DOCKER_COMPOSE top) != "" ]]; then
    error "Cannot run integration tests while services are running. Run 'docker-compose down' and try again."
fi

# About to start tests; make sure we clean up afterwards
trap cleanup EXIT

info "Starting integration test services"
$DOCKER_COMPOSE up --build -d 1>/dev/null
info "Waiting for mysql to initialize"
for i in {1..24}; do
    if [[ $($DOCKER_COMPOSE logs mysql | grep "ready for connections") != "" ]]; then
        sleep 5 # to be extra-sure that mysql is ready
        break
    fi
    sleep 5
    if [[ $i == 24 ]]; then
        error "mysql failed to initialise within 120 seconds"
    fi
done

# Find the random port that nginx is mapped to
NGINX_ADDR=$(docker-compose port nginx 80)

info "Initializing database"
# Move LocalSettings.php out of the way otherwise the installer complains
$DOCKER_COMPOSE exec -T php mv $WIKI/LocalSettings.php $WIKI/LocalSettings.php.bak
$DOCKER_COMPOSE exec -T php php $WIKI/maintenance/install.php \
    --confpath /tmp \
    --dbname metakgp_wiki_db \
    --dbserver mysql-docker \
    --dbuser metakgp_user \
    --dbpass $MYSQL_PASSWORD \
    --installdbuser metakgp_user \
    --installdbpass $MYSQL_PASSWORD \
    --pass admin_password \
    --scriptpath "" \
    Metakgp Test Wiki \
    Admin

# Move LocalSettings.php back in place
$DOCKER_COMPOSE exec -T php mv $WIKI/LocalSettings.php.bak $WIKI/LocalSettings.php

# Sample test only; more comprehensive tests to follow
CURL_OUTPUT=$(curl -sSL $NGINX_ADDR)
if [[ $CURL_OUTPUT != *"Powered by MediaWiki"* ]]; then
    error "Main page failed to load properly: "$CURL_OUTPUT
fi

MOBILE_CURL_OUTPUT=$(curl -sSL $NGINX_ADDR'/index.php?title=Main_Page&mobileaction=toggle_view_mobile')
if [[ $MOBILE_CURL_OUTPUT != *"Special:MobileMenu"* ]]; then
    error "Main page failed to load properly on mobile: "$MOBILE_CURL_OUTPUT
fi

info "Tests complete"
