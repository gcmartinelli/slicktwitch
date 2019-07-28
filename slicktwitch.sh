#!/bin/sh

################################
#
# slicktwitch - simple terminal twitch viewer + chat
# http://github.com/gcmartinelli/slicktwitch
# License: GNU GPLv3
#
################################

configdir=$HOME/.config/slicktwitch
configfile=$HOME/.config/slicktwitch/slicktwitch.conf

if [ ! -d "$configdir" ]; then
	mkdir "$configdir"
fi

if [ ! -f "$configfile" ]; then
	echo "We need a Twitch OAuth key. You can generate one at https://twitchapps.com/tmi/"
	echo -n "> "
	read oauth
	
	if [ -z $oauth ]; then
		echo "You need to pass a valid OAut key..."
		exit 1
	else
		echo "$oauth" > "$configfile"
	fi

else oauth=`cat $configfile`

fi

echo "What channel would you like to watch today?"
read channel

if [ -z "$channel" ]; then
	echo "You need to give a channel name..."
	exit 1
fi

echo "Do you want to joing chat? If so what is your Twitch username? [Default: No]"
echo -n "> "
read nick

echo "Attempting to connect to $channel..."
streamlink -Q -p "vlc --qt-minimal-view" http://twitch.tv/$channel medium,worst,best &

if [ ! -z "$nick" ]; then
	echo "\n\n"
	echo "IRSSI will open but you will need to join the chat channel yourself."
	echo "\n\n"
	echo "To join the chat type: /j $channel"
	echo "\n\n"
	echo -n "Press ENTER when ready."
	read input
	irssi -c irc.chat.twitch.tv -p 6667 -n $nick -w "$oauth"
fi
