<<<<<<< HEAD
# Latest Plex Public: Plex Media Server 1.8.2
=======
# Latest Plex Pass: Plex Media Server 1.9.1 
Version: 1.9.1.4272-b207937f1 Public Release. September 19, 2017
Changelog: https://forums.plex.tv/discussion/comment/1519625#Comment_1519625
>>>>>>> plexpass

Version: 1.8.2.4209-b1d4aa012 PUBLIC Release. Aug 10, 2017
Changelog: https://forums.plex.tv/discussion/comment/1510687#Comment_1510687

For Plex Pass releases, please check the plexpass branch.

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
