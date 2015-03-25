#!/bin/bash
# Move shows in current directory to $DEST in proper subfolders using show name
# and season number.
# Files MUST be formated as follow: "Show Name - 01x01 - Episode Title"
# Actually, this is Addic7ed default format, so if you use 7ed/addic7ed, you're
# good to go.

DEST="/where/to/move"

for f in *.{mp4,avi}
do
    if [ -f "$f" ]
    then
        all_f="${f%.*}"
        serie=`echo "$f" | sed 's/ -.*//'`
        regex="([0-9]{2})x[0-9]{2}"
        [[ $f =~ $regex  ]]
        season="${BASH_REMATCH[1]}"
        dir="$DEST/$serie/Season $season/"

        if [ -n "$season" ]
        then
            mkdir -p "$dir"
            mv "$all_f".* "$dir"
            tree "$dir"
        fi
    fi
done
