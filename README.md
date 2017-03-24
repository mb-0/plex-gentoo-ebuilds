# Latest: plex-media-server 1.5.1.3520-ed60c70d6 (March 22, 2017)

# What
This is a snapshot of my local overlay I ended up maintaining after waiting for new plex-media-server ebuilds from official ebuild factories.

You may want to look at official repositories before playing with this one. 

# How
Brave enough? Ideally this can function as a local repository for your gentoo:

1. Add this repo to your /etc/portage/repos.conf/local.conf:

   [mb0plex]  
   location = /usr/local/plex-gentoo-ebuilds  
   masters = gentoo  
   auto-sync = no  

2. cd /usr/local; git clone https://github.com/mb-0/plex-gentoo-ebuilds.git
3. chown -R portage:portage /usr/local/plex-gentoo-ebuilds
4. emerge -av plex-media-server::mb0plex

# Thanks
Initial work is based on megacoffee initial ebuilds, many thanks for that!
Restuctured a bit to match Gentoo Portage version (act as one of those but newer).

# License
Plex is plex.
Ebuild is opensource.
No warranty, or guarantee of any kind that this will work for you, or that it won't blow up your kitchen. Beware.
