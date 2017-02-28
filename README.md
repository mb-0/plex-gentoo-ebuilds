# Latest: plex-media-server 1.4.2.3400

# What
This is an unofficial gentoo ebuild, only a snapshot from my local overlay that I ended up maintaining after waiting for new plex-media-server ebuilds from megacoffee and alike.

There is an official gentoo build for plex now, look at: https://gitweb.gentoo.org/repo/gentoo.git/tree/media-tv/plex-media-server. Also, there are bunch of repos with plex in them.

# Why
Easy to do, and I'm usually fast in running into new version being available, up my ebuilds, update my box, git diff, commit, push. Feel free to grab.

# How
Ideally this can function as a local repository for your gentoo.
Here's how:

1. Add this repo to your /etc/portage/repos.conf/local.conf

   [mb0plex]  
   location = /usr/local/plex-gentoo-ebuilds  
   masters = gentoo  
   auto-sync = no  

2. cd /usr/local; git clone https://github.com/mb-0/plex-gentoo-ebuilds.git
3. chown -R portage:portage /usr/local/plex-gentoo-ebuilds
4. emerge -av plex-media-server::mb0plex

# Thanks
Work is based on megacoffee initial ebuilds, many thanks for that!

# License
Plex is plex.
Ebuild is opensource.
No warranty, or guarantee of any kind that this will work for you, or that it won't blow up your kitchen. Beware.
