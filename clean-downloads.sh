#!/bin/bash
# Clean folder /where/to/download by flatening it (put all downloaded shows at the
# same tree level, removing useless files, etc...)
# This might be wise to set the same folder as the one you set in
# .flexget/config.yml

cd "/where/to/download/Series"
# Remove useless files (NFO, SFV, TXT files)
find . -name "*.nfo" -print0 -o -name "*.sfv" -print0 -o -name "*.txt" -print0 | xargs -0 rm -rf
# Flatten folder tree
find . -mindepth 2 -type f -exec mv --backup=numbered -t . -- {}
find . -empty -type d -delete
# remove recurent strings in releases
rename -v 's/\[VTV\].//g' *
