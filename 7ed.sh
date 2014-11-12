#!/bin/bash
# For each video file in the execution directory, tries to find matching subtitle
# on Addic7ed. Asks for confirmation before download.

# It uses Michael Baudino's addic7ed-ruby gem.
# For convinience I HIGHLY suggest you to use my own for of this gem.
# https://github.com/Jesus-21/addic7ed-ruby/tree/FilenameContentDisposition
# The difference is that the later use Addic7ed's content-disposition top set
# files names (subtitles and video files).

GREEN="\\033[1;32m"
DEFAULT="\\033[0;39m"
RED="\\033[1;31m"
BLUE="\\033[1;34m"

# By default seek FRENCH subtitles, you might want to change that.
# Add -l, --language [LANGUAGE] argument to addic7ed commands.
for f in *.{mp4,avi}
do
    if [ -f "$f" ]
    then
        echo -e "$BLUE""$f""$DEFAULT"
        # set language here
        a=`addic7ed "$f" -na`
        skip=`echo "$a" | grep -o "Skipping.$\|later.$"`
        echo "$a"
        if [ "$skip" == "" ]
        then
            read -p "Download subtitle? " yn
            case $yn in
                [Yy]* ) 
                    # set language here
                    dl=`addic7ed "$f"`
                    res=`echo "$dl" | grep -o "Enjoy your show :-)$"`
                    if [ "$res" == "Enjoy your show :-)" ]
                    then
                        echo -e "$GREEN""$dl""$DEFAULT"
                    else
                        echo -e "$RED""$dl""$DEFAULT"
                    fi
                    ;;
            esac
        fi
        echo
    fi
done
