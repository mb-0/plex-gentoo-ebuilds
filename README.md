# Latest: Plex Media Server 1.19.3.2793 PLEXPASS Release
Version: 1.19.3.2793-36efde971 May 12, 2020
Changelog: https://forums.plex.tv/search?q=1.19.3.2793%20tags%3Arelease-announcements

Note: for Plex Pass releases, you need to have an active Plex Pass subscription.
Updating to a plex pass release unless you have an active subscription is not only bad to do, but can be dangerous as likely you won't be able to use the release anyway, but downgrading is not deeply tested.

You have been warned.

# What
This is a snapshot of my local overlay I ended up maintaining after waiting for new plex-media-server ebuilds from official ebuild factories.
You may want to look at official repositories before playing with this one. 

# How
Brave enough?
Clone this repo, and optionally checkout the branch best fit for you.

Ideally this can function as a local repository for your gentoo.

1. Add this repo to your /etc/portage/repos.conf/local.conf:

   [mb0plex]  
   location = /usr/local/plex-gentoo-ebuilds  
   masters = gentoo  
   auto-sync = no  

2. cd /usr/local; git clone https://github.com/mb-0/plex-gentoo-ebuilds.git
3. chown -R portage:portage /usr/local/plex-gentoo-ebuilds
4. emerge -av plex-media-server::mb0plex

# Additional stuff required by plex
When you see stuff like:
``
ERROR	[Transcoder] [eac3_eae @ 0x150d760] EAE timeout! EAE not running, or wrong folder? Could not read ‘/tmp/pms-66181c4b-c3d6-4b37-b6a2-67b8556d1c86/EasyAudioEncoder/Convert to WAV (to 8ch or less)/030kau81ld0a3bf2eyuxzufr_626-1-21.wav’
``
in your plex media server log, you will need to:
``
echo   "fs.inotify.max_user_watches=65536" >> /etc/sysctl.conf
sysctl -p
``
(https://forums.plex.tv/t/any-video-with-eac3-audio-fails-to-play/207266/5)

# Thanks
Initial work is based on megacoffee initial ebuilds, many thanks for that!
Restuctured a bit to match Gentoo Portage version (act as one of those but newer).

# Legal
Plex is plex.
Ebuild is opensource.
No warranty, or guarantee of any kind that this will work for you, or that it won't blow up your kitchen. Beware.
