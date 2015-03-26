# 1. Download daily manual, and save filename with date.
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
DIR="$DIR/"
log_dir=$DIR"log.txt"
current_date=`date +%Y-%m-%d`
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
  echo "$current_date Missing Symlink - Full" >> $log_dir
else
  # current exists. compare with daily.
  if [ -f "$elite_full_daily" ]; then
    diff "$elite_full_current" "$elite_full_daily"  >> $log_dir
    if [ $? -ne 0 ]; then
      # newest version differs. save and update
      rm "$elite_full_current"; #only removes symlink, not actual file.
      ln -sf "$elite_full_daily" "$elite_full_current";
      echo "$current_date New Version - Full" >> $log_dir
    else
      # newest version is the same. delete daily download.
      rm "$elite_full_daily";
      echo "$current_date No Change - Full" >> $log_dir
    fi;
  else
    echo 'file not exists'
    # had a malfunction. either wget failed to get the file,
    # or some other error (permissions, hd space, etc) caused
    # the new daily to not download properly
    echo "$elite_full_daily not found. Filesystem error. Check permissions." >> $log_dir
  fi;
fi;

# quick start manual
if [ ! -L "$elite_quick_current" ]; then
  ln -sf "$elite_quick_daily" "$elite_quick_current";
  echo "$current_date Missing Symlink - Quick" >> $log_dir
else
  if [ -f "$elite_quick_daily" ]; then
    diff "$elite_quick_current" "$elite_quick_daily";
    if [ $? -ne 0 ]; then
      rm "$elite_quick_current";
      ln -sf "$elite_quick_daily" "$elite_quick_current";
      echo "$current_date New Version - Quick" >> $log_dir
    else
      rm "$elite_quick_daily";
      echo "$current_date No Change - Quick" >> $log_dir
    fi;
  else
    # had a malfunction. either wget failed to get the file,
    # or some other error (permissions, hd space, etc) caused
    # the new daily to not download properly
    echo "$elite_quick_daily not found. Filesystem error. Check permissions." >> $log_dir
  fi;
fi;
