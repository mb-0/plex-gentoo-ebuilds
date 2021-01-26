# Plex Media Server 1.21.2.3939
Version: 1.21.2.3939-3945797bd (January 26, 2021)

Changelog: https://forums.plex.tv/search?q=1.21.2.3939%20tags%3Arelease-announcements

For a complete plex experience, you may need an active Plex Pass subscription.

# What
This is a snapshot of my local overlay I ended up maintaining after waiting for new plex-media-server ebuilds from official ebuild factories.
You may want to look at official repositories before playing with this one. 

# How
Clone this repo, and optionally checkout the branch best fit for you.
This functions as a gentoo local repo.

1. Add this repo to your /etc/portage/repos.conf/local.conf:
```   
   [mb0plex]  
   location = /usr/local/plex-gentoo-ebuilds  
   masters = gentoo  
   auto-sync = no  
```
2. cd /usr/local; git clone https://github.com/mb-0/plex-gentoo-ebuilds.git
3. chown -R portage:portage /usr/local/plex-gentoo-ebuilds
4. emerge -av plex-media-server::mb0plex

# Known issues and fixes
## Installation issues
### Gentoo vs Python 2.7 warning
You may have ran into the following message while emerging anything plex-media-server lately on gentoo:
```
- media-tv/plex-media-server-1.20.1.3252::mb0plex (masked by: package.mask)
/usr/portage/profiles/package.mask:
# Michał Górny <mgorny@gentoo.org> (2020-09-20)
# Bundles vulnerable version of Python 2.7, also boost and other
# libraries in undetermined versions.  Simultaneously blocks removal
# of Python 2.7 packages.
# Removal in 30 days.  Bug #735396.
```

The ::mb0plex builds remove all wiring between gentoo system-wide python and plex's own embedded python packages, which is as much as we can do until Plex gets rid of its legacy Python 2.7 dependency.

To unmask, please add the following to your /etc/portage/package.unmask:
```
# mb0plex (no dependency on system-wide gentoo python)
media-tv/plex-media-server::mb0plex
```

Following this, you should be OK to install/upgrade.

## Transcoder errors
### EAE Timeout
When you encounter errors in the logs like:
```
ERROR	[Transcoder] [eac3_eae @ 0x150d760] EAE timeout! EAE not running, or wrong folder? Could not read ‘/tmp/pms-66181c4b-c3d6-4b37-b6a2-67b8556d1c86/EasyAudioEncoder/Convert to WAV (to 8ch or less)/030kau81ld0a3bf2eyuxzufr_626-1-21.wav’
```
Try tweaking inotify a bit:
```
echo   "fs.inotify.max_user_watches=65536" >> /etc/sysctl.conf
sysctl -p
```
(https://forums.plex.tv/t/any-video-with-eac3-audio-fails-to-play/207266/5)

# Thanks
Initial work is based on megacoffee initial ebuilds.
I merged a bunch from the upstream Gentoo repo for Py 2.7 compat, but removed almost all of that when 2.7 offboarding started.

# Legal
Plex is plex.
Ebuild is opensource.
Gentoo: break it and leave.
No warranty, or guarantee of any kind that this will work for you, or that it won't blow up your kitchen. Beware.
