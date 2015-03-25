#!/bin/bash
# For each video file in the execution directory, asks for matching subtitle

# Downloads subtitle from Addic7ed, then rename video file.

for f in *.{mp4,avi}
do
    if [ -f "$f" ]
    then
        ext="${f##*.}"
        regex="(.*)\.[s|S]?([0-9]{1,2})[x|X|e|E]?([0-9]{2})(.*)"
        [[ $f =~ $regex  ]]
        serie=`echo ${BASH_REMATCH[1]} | tr '[:upper:]' '[:lower:]'`
        serie=$(echo $serie | tr '\.' '_')
        season=`echo ${BASH_REMATCH[2]}`
        season=$(expr $season + 0)
        episode=`echo ${BASH_REMATCH[3]}`
        episode=$(expr $episode + 0)

        if [ $season -eq 0 ] && [ $episode -eq 0  ]; then
            continue
        fi

        referer="Referer:http://addic7ed.com/serie/$serie/$season/$episode/addic7ed"

        if [ "$serie" == "marvels_agent_carter" ]; then
            serie="marvel's_agent_carter"
        elif [ "$serie" == "marvels_agents_of_s_h_i_e_l_d" ]; then
            serie="marvel's_agents_of_s.h.i.e.l.d."
        elif [ "$serie" == "marvels_daredevil" ]; then
            serie="marvel's_daredevil"
        fi

        link="http://addic7ed.com/serie/$serie/$season/$episode/8"

        echo "$f"
        echo "Link: $link"
        read -e -p "Subs? " url
        if [[ ! -z "$url" ]]
        then
            filename="$(curl -sIL $url -H "$referer" | sed -r -e 's/^ *Content-Disposition[ \t]*:[ \t]*[^ \t;]+;[ \t]*filename[ \t]*=[ \t]*("(([^"]|\")*)".*|([^; \t\r"]+)(([^;\r]*[^; \t\r]+)*)[ \t]*(;.*|[\r]?)$)/\2\4\5/' -e 't' -e 'd')"
            name=`echo $filename | sed -E 's/\.\S*Addic7ed.com.srt$//g'`

            curl --silent -O -J -L $url -H "$referer"
            mv "$filename" "$name".srt
            mv "$f" "$name"."$ext"
        fi
        echo
    fi
done
tree
