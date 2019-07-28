# slicktwitch

![slicktwitch screenshot](https://i.imgur.com/YoUyZml.png)

Simple shell script that runs VLC and IRSSI to launch a Twitch video and Twitch chat on the terminal.

Only tested on Linux.

Use at your own risk.

#### Dependencies
* VLC Media Player - http://www.videolan.org/vlc
* IRSSI - https://www.irssi.org

#### Instalation
1. Clone with `git clone https://github.com/gcmartinelli/slicktwitch.git`
2. Navigate to the directory where you cloned the script
3. Launch with `./slicktwitch.sh`

**Optional step**: Add `alias "slicktwitch=/path/to/slicktwitch.sh"` to your `.bashrc` file and launch with `slicktwitch` command.

#### Possible new features
- [ ] Nick command line argument
- [ ] Channel command line argument
- [ ] List channels you follow that are live
- [ ] Allow change of channel
- [ ] Allow change of stream quality (defaults to the best available right now)
