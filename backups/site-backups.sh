#!/usr/bin/env bash
set -euo pipefail
# Backup script for cron or systemd to backup your sites
# Create a systemd process or cron (preferably systemd so you can monitor logs)

# IMPORTANT:
# This is intended for WordPress Sites so change file locations as needed
# Make sure `rclone` and whatever mysql/php stuff you need is installed prior to running this script
# Make sure you have rclone configured already, otherwise there's no point

# If you're running cron and want to have logs include this for logging 
# echo "Site backup started - $(date)" >> $LOGFILE

# Intro
echo "Backup process starting...\n"

# Check if rclone is installed otherwise prompt and exit script.
printf "Checking if rclone is installed..."
[[ ! -e "/usr/bin/rclone" ]] && echo "rclone is not installed, please install via your package manager." && echo "Stopping backup..." && exit 1
printf " ✓\n"

# Check if rclone is installed otherwise prompt and exit script.
printf "Checking if mysql is installed..."
[[ ! -e "/usr/bin/mysql" ]] && echo "mysql is not installed, please install via your package manager or via cpanel." && echo "Stopping backup..." && exit 1
printf " ✓\n"

# Custom variables - Fill out this section with what you want
file_paths="/var/www $HOME "    #List all directories you want to backup, separate with spaces
zip_prefix="My-Cool-Backup_"    #The prefix for backups on your system
backup_dir="$HOME/tmp/backup/"  #Leave as is unless you know what you're doing
rclone_drive="gdrive"           #!! Please change to what your actual drive name is
databases="wordpress site"      #Databases you'll be using, separated by spaces
backupdays="30d"                #If you're doing a rolling release then here's how you'd delete the older files

# Static Variables - Change only if you know what you're doing
DATEFORM=$(date +"%Y-%m-%d")

# Check if temp backup folder exists otherwise create it
printf "Looking for your backup directory..."
[[ ! -e $backup_dir ]] && mkdir -p "$backup_dir"
printf " ✓\n"

# Dumping all MySQL databases
printf "Backing up mysql databases... "
if mysqldump --compress --databases $databases > $backup_dir/databases.sql
then printf "✓\n" && mysql="$backup_dir/databases.sql"
else echo "Failed to backup database. Consult mysql and see what is wrong..."
     echo "Stopping backup..." && exit 1
fi

# Saving the name of the tarball for future use
TARNAME="$backup_dir/$zip_prefix-$DATEFORM.tar.gz"

printf "Compressing data..."
tar -czf $TARNAME $mysql $file_paths && printf " ✓\n" || exit 1

printf "Backing up data via rclone..."
rclone copy $TARNAME $rclone_drive: && printf " ✓\n" || exit 1

# If you want rolling backups uncomment this section
# echo "Cleanup old backups..."
# rclone --min-age $backupdays delete $rclone_drive: && printf " ✓\n" || exit 1
# This can optionally be run via cron if you don't want it checking each time
# Min age being that the files you want to delete are x days or older (ie 30+)


printf "Cleaning up temp files..."
chmod -R 777 $backup_dir && rm -rf $backup_dir && printf " ✓\n"
echo "All done!"

# If you're running cron and want to have logs include this for logging
# echo "Site backup ran successfully - $(date)" >> $LOGFILE

