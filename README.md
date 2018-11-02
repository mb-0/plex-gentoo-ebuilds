# Latest: Plex Media Server 1.13.9.5456 PLEXPASS Release
Version: 1.13.9.5456-ecd600442 
Changelog: https://forums.plex.tv/t/plex-media-server/30447/237

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

# Thanks
Initial work is based on megacoffee initial ebuilds, many thanks for that!
Restuctured a bit to match Gentoo Portage version (act as one of those but newer).

# Legal
Plex is plex.
Ebuild is opensource.
No warranty, or guarantee of any kind that this will work for you, or that it won't blow up your kitchen. Beware.
