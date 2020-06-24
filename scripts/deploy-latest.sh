#!/usr/bin/env bash

# Environment variables:
# 1. METAKGP_WIKI_PATH => Path to the cloned metakgp/metakgp-wiki repository
# 2. SLACK_NOTIFICATIONS_URL => Webhook URL to which notifications will be sent as a Post request

set -xe

# TODO:
# 1. Include the real username (or at least users who are logged in to the server)
# 2. Include the old commit and the commit that is going to be deployed
deploy_message () {
	local action=$1
	case $action in
		"deploy_start")
			echo "Deploy begin: User $(whoami) is deploying to metakgp-wiki"
			;;
		"downtime_start")
			echo "Downtime begin"
			;;
		"downtime_end")
			echo "Downtime end"
			;;
		"deploy_end")
			echo "Deploy end"
			;;
	esac
}

notify_slack () {
	message="${1}"
	if [[ -n "$SLACK_NOTIFICATIONS_URL" ]];
	then
		curl -s -H 'content-type: application/json' \
			 -d "{ \"text\": \"${message}\" }" \
			 "$SLACK_NOTIFICATIONS_URL"
	fi
}

# TODO: Better as parameters to the deploy function?
base_branch="master"
deploy_branch="origin/master"

deploy () {
	local go="${1}"

	notify_slack "$(deploy_message deploy_start)"

	local source_dir=$(pwd)
	echo "START: metakgp-wiki deploy"

	local config_path=${METAKGP_WIKI_PATH:-/root/metakgp-wiki}
	cd "$config_path"

	echo "STEP: Ensure that current branch is $base_branch"
	local branch=$(git rev-parse --abbrev-ref HEAD)

	[[ "$branch" == "$base_branch" ]]

	echo "STEP: Update all branches"
	git remote update

	echo "STEP: Check if there are any changes that need to be deployed"
	git --no-pager diff --exit-code $deploy_branch > /dev/null

	local docker_compose="docker-compose"
	local docker="docker"

	[[ -x "$(which ${docker})" ]]
	[[ -x "$(which ${docker_compose})" ]]

	echo "STEP: Running backup job"

	local docker_compose_override="${docker_compose} -f docker-compose.yml \
					  -f docker-compose.override.yml \
					  -f docker-compose.prod.yml"
	local backup_container_exec="${docker_compose_override} exec backup"

	${backup_container_exec} ./run_backup.sh 2>/dev/null

	echo "STEP: Copy backup and store inside $source_dir/.backups"

	mkdir -p "$source_dir/.backups"
	# TODO: Strange head commands to get rid of the newlines at the end. Use gawk instead?
	backup_archive="$(${backup_container_exec} ls -1 -t /root/backups 2>/dev/null | head -1 | head -c -2)"
	backup_container_name=$(${docker} ps  --format '{{ .Names }}' | grep backup | head -1)
	backup_path="$backup_container_name:/root/backups/$backup_archive"
	docker cp "$backup_path" "$source_dir/.backups"

	echo "STEP: Current deployed version"
	git log --oneline | head -n1

	if [[ "$go" != "--go" ]];
	then
		echo "DRY RUN: Stopping deploy; Run with --go to continue beyond this point"
		return 0
	fi

	echo "STEP: Merge branch and build Docker images"
	git merge --ff-only $deploy_branch

	local docker_compose_override="${docker_compose} -f docker-compose.yml \
					  -f docker-compose.override.yml \
					  -f docker-compose.prod.yml"

	echo "STEP: Build docker images for the new configuration"
	${docker_compose_override} build

	notify_slack "$(deploy_message downtime_start)"

	echo "STEP: Bring all containers down"
	${docker_compose_override} down

	echo "STEP: All containers are down (Downtime begin) $(date +%s)"

	local volume_metakgp="metakgp-wiki_mediawiki-volume"
	docker volume rm "$volume_metakgp"

	echo "STEP: Bring all containers up"
	${docker_compose_override} up -d

	echo "STEP: All containers are up (Downtime end) $(date +%s)"

	notify_slack "$(deploy_message downtime_end)"

	echo "STEP: Run maintenance/update.php to update DB schema, if required"
	local php_container_exec="${docker_compose_override} exec php"
	${php_container_exec} /srv/mediawiki/maintenance/update.php --quick

	notify_slack "$(deploy_message deploy_end)"
	echo "END: deploying metakgp-wiki"
}

if [[ "$1" == "-h" || "$1" == "--help" ]];
then
	echo "./deploy-latest.sh [--go]"
	exit 0
fi

source_dir=$(pwd)

deploy $1

exit_code=$?
cd "$source_dir"
exit ${exit_code}
