#!/bin/sh

################################
#
# slicktwitch - simple terminal twitch viewer + chat
# http://github.com/gcmartinelli/slicktwitch
# License: GNU GPLv3
#
################################


# Handle flags
while test $# -gt 0; do
    case "$1" in
        -h|--help)
            echo "slicktwitch -  Twitch stream and chat in the terminal"
            echo " "
            echo "slicktwitch [options]"
            echo " "
            echo "options:"
            echo "-h, --help                                         show script help"
            echo "-c CHANNEL, --CHANNEL=CHANNEL                      set twitch chat CHANNEL"
            echo "-n NICK, --nick=NICK                               set twitch chat nick"
            echo "-x, --nochat                                       do not open chat"
            echo "-q QUALITY, --quality={best|worst|audio_only}     set preffered stream quality"
            exit 0
            ;;
        -c)
            shift
            if test $# -gt 0; then
                export CHANNEL=$1
            else
                echo "No CHANNEL specified"
                exit 1
            fi
            shift
            ;;
        --CHANNEL*)
            export CHANNEL=`echo $1 | sed -e 's/^[^=]*=//g'`
            shift
            ;;
        -n)
            shift
            if test $# -gt 0; then
                export NICK=$1
            else
                echo "No NICK specified"
                exit 1
            fi
            shift
            ;;
        --nick*)
            export NICK=`echo $1 | sed -e 's/^[^=]*=//g'`
            shift
            ;;
        -q)
            shift
            if test $# -gt 0; then
                export QUALITY=$1
            else
                echo "No QUALITY specified"
                exit 1
            fi
            shift
            ;;
        --quality*)
            export QUALITY=`echo $1 | sed -e 's/^[^=]*//g'`
            shift
            ;;
        -x)
            export NOCHAT=1
            shift
            ;;
        --nochat)
            export NOCHAT=1
            shift
            ;;
        *)
            break
            ;;
    esac
done 

# Setup the config file
CONFIGDIR=$HOME/.config/slicktwitch
CONFIGFILE=$HOME/.config/slicktwitch/slicktwitch.conf

if [ ! -d "$CONFIGDIR" ]; then
    mkdir "$CONFIGDIR"
fi

if [ ! -f "$CONFIGFILE" ]; then
    echo "We need a Twitch OAuth key. You can generate one at https://twitchapps.com/tmi/"
    echo -n "> "
    read OAUTH
    
    if [ -z $OAUTH ]; then
        echo "You need to pass a valid OAuth key..."
        exit 1
    else
        echo "$OAUTH" > "$CONFIGFILE"
    fi

else OAUTH=`cat $CONFIGFILE`

fi


# Finish setting up arguments
if [ -z "$CHANNEL" ]; then
    echo "What CHANNEL would you like to watch today?"
    read CHANNEL

    if [ -z "$CHANNEL" ]; then
        echo "You need to give a CHANNEL name..."
        exit 1
    fi
    echo " "
fi

if [ -z "$NOCHAT" ]; then
    if [ -z "$NICK" ]; then
        echo "Do you want to joing chat?"
		echo "1 - No"
		echo "2 - Yes"
        echo -n " [Default 1: No] > "
        read CHAT
		echo " "
		if [ -z "$CHAT" ]; then
			NOCHAT=1
        elif [ "$CHAT" -eq 2 ]; then
			NOCHAT=0
		else
            NOCHAT=1
        fi
		
		if [ "$NOCHAT" -eq 0 ]; then
			echo "What is your Twitch username?"
			echo -n "> "
		read NICKi
    	fi
	fi
	echo " "		
fi

if [ -z "$QUALITY" ]; then
    echo "What quality do you want to watch the stream at (preferrably)?"
    echo "1 - Best"
    echo "2 - Worst"
    echo "3 - Audio Only"
    echo "[Default: 1]"
    read QUALITY
     QUALITY=${QUALITY:-1}
    if [ "$QUALITY" -eq 1 ]; then
        QUALITY='best'
    elif [ "$QUALITY" -eq 2 ]; then
        QUALITY='worst'
    else
        QUALITY='audio_only'
    fi
    echo " " 
fi
    

# Launch programs...
STREAMOPTS="-Q -p 'vlc --qt-minimal-view' --title '{title} - {category}'"

echo "**********************************************************"
echo "Attempting to connect to $CHANNEL... this may take a while"
echo "**********************************************************"

if [ ! -z "$NOCHAT" ]; then
    streamlink -p 'vlc --qt-minimal-view' --title '{title} - {category}' http://twitch.tv/$CHANNEL $QUALITY
else
    streamlink -Q -p 'vlc --qt-minimal-view' --title '{title} - {category}' http://twitch.tv/$CHANNEL $QUALITY &
    echo ""
    echo ""
    echo "IRSSI will open but you will need to join the chat CHANNEL yourself."
    echo ""
    echo "To join the chat type: /j $CHANNEL"
    echo ""
    echo -n "Press ENTER when ready."
    read input
    irssi -c irc.chat.twitch.tv -p 6667 -n $NICK -w "$OAUTH"
fi

exit 0


