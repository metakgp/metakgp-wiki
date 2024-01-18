#!/usr/bin/env bash

set -x

echo "Backing up database..."

set -a
source .env
set +a

timestamp=$(date +%Y_%m_%d_%H_%M_%S)

# Wiki paths
wiki_root="/srv/mediawiki"
static_root="/srv/static"
settings_file="$wiki_root/LocalSettings.php"

# Dropbox backup script runner
backup_to_dropbox="/usr/local/bin/python /root/backup_to_dropbox.py"

# Backup locations
backups_path="/root/backups"
backup_dir="metakgp_wiki_${timestamp}"
backup_file="${backup_dir}.tar.gz"

mkdir -p "$backups_path/$backup_dir"

# Show a message on the wiki and make it read only while backing up
echo -e '$wgReadOnly = "Automatic backup in progress; access will be restored in a few seconds.";' >> $settings_file

# Take a mysql dump
mysqldump --no-tablespaces -h mysql-docker -u metakgp_user -p$MYSQL_PASSWORD metakgp_wiki_db > "$backups_path/$backup_dir/metakgp_wiki_db.sql"

# Remove the notice and make the wiki editable
sed -i '$ d' $settings_file

# backup images on the 21st of every month
if [[ $(date '+%d') == "21" ]]; then
    rsync -a "$static_root/images" "$backups_path/$backup_dir/" --exclude thumb --exclude temp
fi

# Put the backup into an archive
cd $backups_path
tar -czvf $backup_file $backup_dir
rm -rf $backup_dir

# Backup to Dropbox
if ! $backup_to_dropbox $backup_file; then
    echo DROPBOX BACKUP FAILURE!
    # Notify Slack
    if [[ -n "$SLACK_INCIDENTS_WH_URL" ]]; then
        curl -s -H 'content-type: application/json' \
            -d "{ \"text\": \"❗DROPBOX BACKUP FAILURE❗\nBackup filename: $backup_file\" }" \
            "$SLACK_INCIDENTS_WH_URL"
    fi
    exit 1
fi

# Delete local backups older than one week
for file in ./*tar.gz; do
    if [ $(($(date +%s) - $(date -r $file +%s))) -gt 604800 ]; then
        rm $file
    fi
done