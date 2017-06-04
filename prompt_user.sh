#!/bin/bash

# Copyright (C) 2015  Beniamine, David <David@Beniamine.net>
# Author: Beniamine, David <David@Beniamine.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Usefull script to prompt user using terminal or dmenu
usage ()
{
    echo "Usage souce $0 choices question dmenu"
    echo "Set USER_CHOICE to the user choice"
    echo "Choices   a \n separated list of choice"
    echo "Question  The question to prompt the user"
    echo "dmenu     A boolean, if true use dmenu for prompting"
}

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$2" ]
then
    usage
    exit 1
fi

if $3
then
    USER_CHOICE=$(echo -e "$1" | dmenu -sb darkgreen -p "$2" -i )
else
    OFS=$IFS
    IFS=$" "
    choices=$(echo $1 | sed 's/\\n/ /g')
    IFS=$OFS
    echo $2
    select USER_CHOICE in $choices; do
        test ! -z $USER_CHOICE && \
            test ! -z "$(echo "$choices" | grep "$USER_CHOICE")" && break;
        echo "Invalid choice !"
    done
fi
export USER_CHOICE=$USER_CHOICE
