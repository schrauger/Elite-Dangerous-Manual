# Elite-Dangerous-Manual
Historical collection of old versions of the Game Manual.

As [Elite: Dangerous][elite] changes and gets updated, so does the manual. Frontier, the developer of the game, only hosts the latest copies of the [full game manual][full] and the [quickstart manual][quick], so older versions are inaccessible. This repository was created to maintain a collection of the previous versions.

This is not an official repository. A [script][script] downloads the latest version of the full and quick manual every day and saves them if a change is detected. If Frontier publishes a version and quickly replaces it with an update within the same day, the script may not refresh quickly enough to catch both copies.

Even if there isn't any important historical significance, it can still be fun just to look back at old manuals to see how the game has progressed.

## Script
Included is a linux bash script. It can be used to check for new versions daily (or hourly).

When set up as a cron job, it will automatically download the latest copy of the full and quick manual and compare it to the current version. If they are the same, it will discard the daily copy. If it differs, that means a new version has been placed online, and it will archive the 'current' copy and make the latest daily version the new 'current' version.

[elite]: http://www.elitedangerous.com/
[full]: http://hosting.zaonce.net/elite/website/assets/ELITE-DANGEROUS-GAME-MANUAL.pdf
[quick]: http://hosting.zaonce.net/elite/website/assets/ELITE-DANGEROUS-MANUAL.pdf
[script]: https://github.com/schrauger/Elite-Dangerous-Manual/blob/master/script/dailycheck.sh
