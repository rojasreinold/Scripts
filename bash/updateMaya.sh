#!/bin/bash
#Change USERS maya preferences as sometimes the shared dir causes issues


for item in $(ls /USERS/*/maya/20*/prefs/synColorConfig.xml); do

    sed -r 's/<SharedHome dir="\/USERS\/.*\/maya\/synColor\/Shared\/" \/>/<SharedHome dir="\/tmp\/" \\> /g' -i $item
    if [ $? ]
        then
        echo "Checked " $item
    fi
    done
    
