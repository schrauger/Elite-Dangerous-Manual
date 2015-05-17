#!/bin/bash
# Add this script to your crontab.
# Run `crontab -e`, then place this line at the bottom.
#  Be sure to change the path to the proper location of the script,
#  and make sure to `chmod +x dailycheck.sh` so that it is executable.
# 5 0 * * * /home/USERNAME/workspace/Elite-Dangerous-Manual/script/dailycheck.sh

# 1. Download daily manual, and save filename with date.
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
DIR="$DIR/"
log_dir_full=$DIR"log_full.txt"
log_dir_quick=$DIR"log_quick.txt"
current_date=`date "+%Y-%m-%d.%H"`
elite_full_current="$DIR""ELITE-DANGEROUS-GAME-MANUAL current.pdf"
elite_quick_current="$DIR""ELITE-DANGEROUS-MANUAL current.pdf"
elite_full_daily="$DIR""ELITE-DANGEROUS-GAME-MANUAL $current_date.pdf" 
elite_quick_daily="$DIR""ELITE-DANGEROUS-MANUAL $current_date.pdf" 
elite_full_url="http://hosting.zaonce.net/elite/website/assets/ELITE-DANGEROUS-GAME-MANUAL.pdf"
elite_quick_url="http://hosting.zaonce.net/elite/website/assets/ELITE-DANGEROUS-MANUAL.pdf"
wget --quiet -O "$elite_full_daily" "$elite_full_url"
wget --quiet -O "$elite_quick_daily" "$elite_quick_url"

# 2. Compare files.
# 3. If different, save. Else, delete.
 # 3a. Remove symlink to current manual.
 # 3b. Create simlink to daily manual.

# full manual
if [ ! -L "$elite_full_current" ]; then
  # no 'current' exists. link to daily and continue.
  ln -sf "$elite_full_daily" "$elite_full_current";
  echo "$current_date Missing Symlink - Full" >> $log_dir_full
else
  # current exists. compare with daily.
  if [ -f "$elite_full_daily" ]; then
    diff "$elite_full_current" "$elite_full_daily" >> $log_dir_full
    if [ $? -ne 0 ]; then
      # newest version differs. save and update
      rm "$elite_full_current"; #only removes symlink, not actual file.
      ln -sf "$elite_full_daily" "$elite_full_current";
      echo "$current_date New Version - Full" >> $log_dir_full
    else
      # newest version is the same. delete daily download.
      rm "$elite_full_daily";
      echo "$current_date No Change - Full" >> $log_dir_full
    fi;
  else
    # had a malfunction. either wget failed to get the file,
    # or some other error (permissions, hd space, etc) caused
    # the new daily to not download properly
    echo "$elite_full_daily not found. Filesystem error. Check permissions." >> $log_dir_full
  fi;
fi;

# quick start manual
if [ ! -L "$elite_quick_current" ]; then
  ln -sf "$elite_quick_daily" "$elite_quick_current";
  echo "$current_date Missing Symlink - Quick" >> $log_dir_quick
else
  if [ -f "$elite_quick_daily" ]; then
    diff "$elite_quick_current" "$elite_quick_daily" >> $log_dir_quick
    if [ $? -ne 0 ]; then
      rm "$elite_quick_current";
      ln -sf "$elite_quick_daily" "$elite_quick_current";
      echo "$current_date New Version - Quick" >> $log_dir_quick
    else
      rm "$elite_quick_daily";
      echo "$current_date No Change - Quick" >> $log_dir_quick
    fi;
  else
    echo "$elite_quick_daily not found. Filesystem error. Check permissions." >> $log_dir_quick
  fi;
fi;
