#!/usr/bin/env bash

set -xe

echo "Backing up database..."

set -a
source .env
set +a

wiki_root="/srv/mediawiki"
file="$wiki_root/LocalSettings.php"
backup_to_dropbox="/usr/local/bin/python /root/backup_to_dropbox.py"

timestamp=$(date +%Y_%m_%d_%H_%M_%S)
backups_path="/root/backups"
backup_dir="metakgp_wiki_${timestamp}"
backup_file="${backup_dir}.tar.gz"
mkdir -p "$backups_path/$backup_dir"

echo -e '\n$wgReadOnly = "Automatic backup in progress; access will be restored in a few seconds.";' >> $file
mysqldump -h mysql-docker -u metakgp_user -p$MYSQL_PASSWORD metakgp_wiki_db > "$backups_path/$backup_dir/metakgp_wiki_db.sql"
sed -i '$ d' $file

# backup images on the 21st of every month
if [[ $(date '+%d') == "21" ]]; then
    rsync -a "$wiki_root/images" "$backups_path/$backup_dir/" --exclude thumb --exclude temp
fi

cd $backups_path
tar -czvf $backup_file $backup_dir
rm -rf $backup_dir
$backup_to_dropbox $backup_file
