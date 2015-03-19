# 1. Download daily manual, and save filename with date.
elite_full_current="ELITE-DANGEROUS-GAME-MANUAL current.pdf"
elite_quick_current="ELITE-DANGEROUS-MANUAL current.pdf"
elite_full_daily="ELITE-DANGEROUS-GAME-MANUAL "`date +%Y-%m-%d`".pdf" 
elite_quick_daily="ELITE-DANGEROUS-MANUAL "`date +%Y-%m-%d`".pdf" 
elite_full_url="http://hosting.zaonce.net/elite/website/assets/ELITE-DANGEROUS-GAME-MANUAL.pdf"
elite_quick_url="http://hosting.zaonce.net/elite/website/assets/ELITE-DANGEROUS-MANUAL.pdf"

wget -O "$elite_full_daily" "$elite_full_url"
wget -O "$elite_quick_daily" "$elite_quick_url"

# 2. Compare files.
# 3. If different, save. Else, delete.
 # 3a. Remove symlink to current manual.
 # 3b. Create simlink to daily manual.

# full manual
if [ ! -f "$elite_full_current" ]; then
  # no 'current' exists. link to daily and continue.
  ln -s "$elite_full_daily" "$elite_full_current";
else
  # current exists. compare with daily.
  diff "$elite_full_current" "$elite_full_daily" 
  if [ $? -ne 0 ]; then
    # newest version differs. save and update
    rm "$elite_full_current"; #only removes symlink, not actual file.
    ln -s "$elite_full_daily" "$elite_full_current";
  else
    # newest version is the same. delete daily download.
    rm "$elite_full_daily";
  fi;
fi;

# quick start manual
if [ ! -f "$elite_quick_current" ]; then
  ln -s "$elite_quick_daily" "$elite_quick_current";
else
  diff "$elite_quick_current" "$elite_quick_daily";
  if [ $? -ne 0 ]; then
    rm "$elite_quick_current";
    ln -s "$elite_quick_daily" "$elite_quick_current";
  else
    rm "$elite_quick_daily";
  fi;
fi;
