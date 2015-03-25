# 1. Download daily manual, and save filename with date.
current_date=`date +%y-%m-%d`
elite_full_current="ELITE-DANGEROUS-GAME-MANUAL current.pdf"
elite_quick_current="ELITE-DANGEROUS-MANUAL current.pdf"
elite_full_daily="ELITE-DANGEROUS-GAME-MANUAL $current_date.pdf" 
elite_quick_daily="ELITE-DANGEROUS-MANUAL $current_date.pdf" 
elite_full_url="http://hosting.zaonce.net/elite/website/assets/ELITE-DANGEROUS-GAME-MANUAL.pdf"
elite_quick_url="http://hosting.zaonce.net/elite/website/assets/ELITE-DANGEROUS-MANUAL.pdf"

wget --quiet -O "$elite_full_daily" "$elite_full_url"
wget --quiet -O "$elite_quick_daily" "$elite_quick_url"

# 2. Compare files.
# 3. If different, save. Else, delete.
 # 3a. Remove symlink to current manual.
 # 3b. Create simlink to daily manual.

# full manual
if [ ! -f "$elite_full_current" ]; then
  # no 'current' exists. link to daily and continue.
  ln -s "$elite_full_daily" "$elite_full_current";
  echo "$current_date Missing Symlink - Full" >> log.txt
else
  # current exists. compare with daily.
  diff "$elite_full_current" "$elite_full_daily"  >> log.txt
  if [ $? -ne 0 ]; then
    # newest version differs. save and update
    rm "$elite_full_current"; #only removes symlink, not actual file.
    ln -s "$elite_full_daily" "$elite_full_current";
    echo "$current_date New Version - Full" >> log.txt
  else
    # newest version is the same. delete daily download.
    rm "$elite_full_daily";
    echo "$current_date No Change - Full" >> log.txt
  fi;
fi;

# quick start manual
if [ ! -f "$elite_quick_current" ]; then
  ln -s "$elite_quick_daily" "$elite_quick_current";
  echo "$current_date Missing Symlink - Quick" >> log.txt
else
  diff "$elite_quick_current" "$elite_quick_daily";
  if [ $? -ne 0 ]; then
    rm "$elite_quick_current";
    ln -s "$elite_quick_daily" "$elite_quick_current";
    echo "$current_date New Version - Quick" >> log.txt
  else
    rm "$elite_quick_daily";
    echo "$current_date No Change - Quick" >> log.txt
  fi;
fi;
