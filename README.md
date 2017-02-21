# Latest: plex-media-server 1.4.2.3400

# What
This is an unofficial gentoo ebuild, only a snapshot from my local overlay that I ended up maintaining after waiting for new plex-media-server ebuilds from megacoffee and alike.

There is an official gentoo build for plex now, look at: https://gitweb.gentoo.org/repo/gentoo.git/tree/media-tv/plex-media-server. Also, there are bunch of repos with plex in them.

# Why
Easy to do, and I'm usually fast in running into new version being available, up my ebuilds, update my box, git diff, commit, push. Feel free to grab.

# How
If you really want to use this (lol), you may wanna spin up your local overlay.
This is how you do this: https://wiki.gentoo.org/wiki/Custom_repository
Then, git clone this into your overlay dir, so you have a structure like /usr/local/portage/media-tv/plex-media-server/...

1. chown -R portage:portage /usr/local/portage/media-tv
2. cd /usr/local/portage/media-tv/plex-media-server
3. ebuild plex-media-server-<whatever-version-you-are-after>.ebuild manifest
4. remember to stop plex-media-server if running: /etc/init.d/plex-media-server stop
5. emerge -av plex-media-server # if you like what you see, proceed with [y]
6. should it not fail (:)), start plex-media-server: /etc/init.d/plex-media-server start.

# Thanks
Work is based on megacoffee initial ebuilds, many thanks for that!

# License
Plex is plex.
Ebuild is opensource.
No warranty, or guarantee of any kind that this will work for you, or that it won't blow up your kitchen. Beware.
