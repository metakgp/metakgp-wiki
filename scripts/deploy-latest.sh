#!/usr/bin/env bash

# set -x

deploy () {
	local source_dir=$(pwd)
	echo "START: metakgp-wiki deploy"

	echo "STEP: Ensure that current branch is master"
	local branch=$(git rev-parse --abbrev-ref HEAD)
	if [[ "$branch" != "master" ]];
	then
		echo "Current branch is not master. Continue with deployment? (y/N)"
		read p

		if [[ "$p" != "y" ]];
		then
			echo "END: Stopping deployment"
			return 0
		fi
	fi

	echo "STEP: Update repository"
	git remote update

	echo "STEP: Check if there are any changes that need to be deployed"
	git --no-pager diff --exit-code origin/master > /dev/null

	if [[ "$?" == "0" ]];
	then
		echo "master and origin/master are the same. Continue with deployment? (y/N)"
		read p

		if [[ "$p" != "y" ]];
		then
			echo "END: Stopping deployment"
			return 0
		fi
	fi

	local docker_compose="docker-compose"
	local docker="docker"

	# TODO: Change default to the server location
	local config_path=${METAKGP_WIKI_PATH:-$HOME/code/metakgp/metakgp-wiki}
	cd "$config_path"

	# TODO: Fail if docker or docker-compose not found
	${docker} version
	${docker_compose} version

	echo "STEP: Running backup job"
	local backup_container_exec="${docker_compose} -f docker-compose.yml \
					  -f docker-compose.override.yml \
					  -f docker-compose.prod.yml exec backup"

	${backup_container_exec} ./run_backup.sh 2>/dev/null

	echo "STEP: Copy backup and store inside $source_dir/.backups"

	mkdir -p "$source_dir/.backups"
	# TODO: Strange head commands to get rid of the newlines at the end. Use gawk instead?
	backup_archive="$(${backup_container_exec} ls -1 -t /root/backups 2>/dev/null | head -1 | head -c -2)"
	backup_container_name=$(${docker} ps  --format '{{ .Names }}' | grep backup | head -1)
	backup_path="$backup_container_name:/root/backups/$backup_archive"
	docker cp "$backup_path" "$source_dir/.backups"

	echo "STEP: Deployed version"
	git log --oneline | head -n1

	echo "STEP: Merge branch and build Docker images"
	git merge --ff-only origin/master

	if [[ "$?" != "0" ]];
	then
		echo "ERROR: HEAD does not seem to contain master, can deploy only ff-only branches"
		return 1
	fi

	local docker_compose_override="${docker_compose} -f docker-compose.yml \
					  -f docker-compose.override.yml \
					  -f docker-compose.prod.yml"

	echo "STEP: Bring all containers down (Downtime begin) $(date +%s)"

	${docker_compose_override} down

	local volume_metakgp="metakgp-wiki_mediawiki-volume"
	docker volume rm "$volume_metakgp"

	${docker_compose_override} up --build -d

	echo "STEP: Bring all containers down (Downtime end) $(date +%s)"

	echo "END: deploying metakgp-wiki"
}

source_dir=$(pwd)
deploy
exit_code=$?
cd "$source_dir"
exit ${exit_code}
