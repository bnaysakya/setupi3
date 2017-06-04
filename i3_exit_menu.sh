#!/bin/bash

# Copyright (C) 2015  Beniamine, David <David@Beniamine.net>
# Author: Beniamine, David <David@Beniamine.net>
# Author: Bleuse, Raphael <Raphael.Bleuse@gmail.com>
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


# A nice exit menu for i3 based on dmenu
usage()
{
    echo "$0 [options]"
    echo "-D        Do not use dmenu"
    echo "-l        Lock screen"
    echo "-e        Exit session"
    echo "-s        Suspend"
    echo "-p        Power off"
    echo "-h        Hibernate"
}

USER_CHOICE=""
# Use dmenu only if available and xserver is started
dmenu=$(xset -q  > /dev/null  2>&1 && which dmenu > /dev/null  2>&1 && true || false)
while getopts ":Dlesph" opt; do
    case $opt in
        D)
            dmenu=false
            ;;
        l)
            USER_CHOICE="LockScreen"
            ;;
        e)
            USER_CHOICE="Exit"
            ;;
        s)
            USER_CHOICE="Suspend"
            ;;
        h)
            USER_CHOICE="Hibernate"
            ;;
        p)
            USER_CHOICE="Poweroff"
            ;;
        *)
            echo "Invalid option $opt"
            usage
            exit 1
            ;;
    esac
done

# This settings can/ must be adapted to your configuration
CHOICES='LockScreen\nExit\nSuspend\nHibernate\nPoweroff\nReboot'
#LOCKCMD="xflock4"
LOCKCMD=~/.lock.sh
EXITCMD="xfce4-session-logout --fast --logout"
PROMPT="Exit session ?"
PREFIX=$HOME/scripts

# Actions corresponding to the user choice
declare -A ARGUMENTS
declare -A PREACTIONS

if [ "$(pstree | head -n 1 | cut -d '-' -f 1)" == "systemd" ]
then
    # Using systemd
    CMD="systemctl"
    ARGUMENTS=([Suspend]="suspend" [Hibernate]="hibernate" \
        [Poweroff]="poweroff" [Reboot]="reboot")
else
    # Systemd is not the init program, we use dbus
    CMD="dbus-send --system --print-reply"
    # Dbus arguments
    ConsoleKit="--dest=org.freedesktop.ConsoleKit \
        /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager"
    UPower="--dest=org.freedesktop.UPower \
        /org/freedesktop/UPower org.freedesktop.UPower"
    ARGUMENTS=([Suspend]="$UPower.Suspend" [Hibernate]="$UPower.Hibernate" \
        [Poweroff]="$ConsoleKit.Stop" [Reboot]="$ConsoleKit.Restart")
fi
PREACTIONS=([Suspend]=$LOCKCMD [Hibernate]=$LOCKCMD)


# Ask the user
if [ -z "$USER_CHOICE" ]
then
    source $PREFIX/prompt_user.sh "$CHOICES" "$PROMPT" $dmenu
fi

# Actually do stuff
case "$USER_CHOICE" in
    "Exit")
        $EXITCMD
        ;;
    "LockScreen")
       $LOCKCMD 
        ;;
    "Suspend" | "Hibernate" | "Poweroff" | "Reboot")
        (sleep 1; $CMD ${ARGUMENTS[$USER_CHOICE]} ) & ${PREACTIONS[$USER_CHOICE]}
        ;;
    *)
        exit 1
        ;;
esac
