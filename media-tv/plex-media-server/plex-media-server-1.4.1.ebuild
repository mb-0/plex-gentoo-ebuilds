# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# https://downloads.plex.tv/plex-media-server/1.4.1.3362-77c6a4f80/plexmediaserver_1.4.1.3362-77c6a4f80_amd64.deb
# Version 1.4.1.3362
#
# New
# (DVR) Plex DVR beta 5.
# (macOS) macOS version 10.8 is no longer supported. (#6155)
# (Movies) Add related and post-play hubs for a movie's collections. (#6005) (#6011)
# (Music) Improved performance of music hubs with large libraries (#6060)
# (Music) Removed 'Music Videos For Recent Artists' hub. (#6075)
# (Photos) Added same-day and same-month hubs for photos. (#5666)
# (Metadata) Added hidden 'ArticleStrings' preference, a comma-separated list of words considered to be grammatical articles when sorting titles in a library. (#6110)

# Fixes
# (Windows) Work around crash on startup on some Windows 10 installations. (#5719)
# (Web) Transcode multi-channel audio to stereo, when transcoding audio. (#5588)
# (Music) MP3 files with certain ID3v2 tag patterns were being ignored. (#5093)
# (Music) Local lyrics weren't displayed in certain cases. (#6153)
# (Music) Transcoding lossless audio at 'original' quality to a lossy codec could result in low-bitrate output. (#5858)
# (Music) Issues with Plex Mixes on NVIDIA SHIELD. (#5724)
# (Metadata) Sort cast entries from TVDB correctly. (#5744)
# (Metadata) Posters and art were unnecessarily re-downloaded on every refresh. (#6001)
# (Metadata) Score matches similarly for TMDB and IMDB results. (#6027)
# (Metadata) Issues downloading metadata from TVDB over TLS. (#5986)
# (Scanner) Improve performance refreshing album metadata. (#3894)
# (Scanner) Fixed intermittent crash on startup, particularly for FreeBSD users. (#6026)
# (Network) Server would transiently deny access to apps that hadn't run for a while. (#5443)
# (Network) Server might become unresponsive under load. (#5558)
# (Network) Incorrect Remote Access status reported in some cases. (#5834) (#6105)
# (Subtitles) Prefer embedded subtitles, over agent-provided sidecar subtitles in bundles. (#5848)
# (Database) Improve database backup performance. (#5839)
# (Transcoder) Improve streaming MKV output, improving seek performance with conformant clients. (#2495)
# (Hubs) Adding many episodes from a single show could swamp Recently Added hubs. (#5687)
# (Sync) Sync items in a failure state might not be cleared on next successful sync. (#6078)
# (Sync) Improved performance when garbage-collecting (#6077)
# (Sync) Empty sync items might not be marked as completed. (#6194)
# (NAS) Rare installation failures on Synology devices. (#6045)
# (Channels) Issues on Windows for some channels, e.g. ExportTools. (#6127)
# (DVR) Fix for post-processing sometimes not moving files into library (#6087)
# (DVR) Fix a rare crash while processing recording schedule (#6050)
# (DVR) When adding or removing a device, make sure we re-run scheduling (#6177)
# (DVR) Support for logical channels in XMLTV, may require remapping.
# (DVR) Support for previously-shown element in XMLTV.
# (DVR) A recording with pre-padding could be cancelled prematurely (#6256)
# The default sort order for albums was alphabetical (#6255)
# A rare crash when computing recently added TV shows.

EAPI="2"
inherit eutils user

# https://downloads.plex.tv/plex-media-server/1.4.1.3362-77c6a4f80/plexmediaserver_1.4.1.3362-77c6a4f80_amd64.deb
MAGIC="3362-77c6a4f80"
URI_PRE="https://downloads.plex.tv/plex-media-server/${PV}.${MAGIC}/plexmediaserver_${PV}.${MAGIC}_"

DESCRIPTION="Plex Media Server is a free media library that is intended for use with a plex client available for OS X, iOS and Android systems. It is a standalone product which can be used in conjunction with every program, that knows the API. For managing the library a web based interface is provided."
HOMEPAGE="http://www.plexapp.com/"
KEYWORDS="-* ~x86 ~amd64"
SRC_URI="x86? ( ${URI_PRE}i386.deb )
	amd64?  ( ${URI_PRE}amd64.deb )"
SLOT="0"
LICENSE="PMS-License"
IUSE=""
RESTRICT="mirror"

RDEPEND="net-dns/avahi"
DEPEND="${RDEPEND}"

INIT_SCRIPT="${ROOT}/etc/init/plexmediaserver"

pkg_setup() {
	enewgroup plex
	enewuser plex -1 /bin/bash /var/lib/plexmediaserver "plex" --system
}

pkg_preinst() {
	einfo "unpacking DEB File"
	cd ${WORKDIR}
	# ar x ${DISTDIR}/${A}
        mkdir data
        mkdir control
        tar -xzf data.tar.gz -C data
        tar -xzf control.tar.gz -C control

	einfo "updating init script"
	# replace debian specific init scripts with gentoo specific ones
        rm data/etc/init.d/plexmediaserver
	rm -r data/etc/init
	cp "${FILESDIR}"/pms_initd_1 data/etc/init.d/plex-media-server
        chmod 755 data/etc/init.d/plex-media-server

	einfo "moving config files"
	# move the config to the correct place
	mkdir data/etc/plex
	mv data/etc/default/plexmediaserver data/etc/plex/plexmediaserver.conf
	rmdir data/etc/default

	einfo "cleaning apt config entry"
	rm -r data/etc/apt

	einfo "patching startup"
	# apply patch for start_pms to use the new config file
	cd data/usr/sbin
	epatch "${FILESDIR}"/start_pms_1.patch
	cd ../../..
	# remove debian specific useless files
	rm data/usr/share/doc/plexmediaserver/README.Debian

        # as the patch doesn't seem to correctly set the permissions on new files do this now
	# now copy to image directory for actual installation
	cp -R data/* ${D}

	einfo "preparing logging targets"
	# make sure the logging directory is created
	mkdir ${D}var
	mkdir ${D}var/log
	mkdir ${D}var/log/pms
	chown plex:plex ${D}var/log/pms

	einfo "prepare default library destination"
	# also make sure the default library folder is pre created with correct permissions
	mkdir ${D}var/lib
	mkdir ${D}var/lib/plexmediaserver
	chown plex:plex ${D}var/lib/plexmediaserver

	einfo "Stopping running instances of Media Server"
	if [ -e "${INIT_SCRIPT}" ]; then
		${INIT_SCRIPT} stop
	fi
}

pkg_prerm() {
	einfo "Stopping running instances of Media Server"
        if [ -e "${INIT_SCRIPT}" ]; then
                ${INIT_SCRIPT} stop
        fi
}

pkg_postinst() {
	einfo ""
	elog "Change Log for 1.4.1.3362"
	elog "  New"
    elog "  - (DVR) Plex DVR beta 5."
    elog "  - (macOS) macOS version 10.8 is no longer supported. (#6155)"
    elog "  - (Movies) Add related and post-play hubs for a movie's collections. (#6005) (#6011)"
    elog "  - (Music) Improved performance of music hubs with large libraries (#6060)"
    elog "  - (Music) Removed 'Music Videos For Recent Artists' hub. (#6075)"
    elog "  - (Photos) Added same-day and same-month hubs for photos. (#5666)"
    elog "  - (Metadata) Added hidden 'ArticleStrings' preference, a comma-separated list of words considered to be grammatical articles when sorting titles in a library. (#6110)"
    elog ""
    elog "  Fixes"
    elog "  - (Windows) Work around crash on startup on some Windows 10 installations. (#5719)"
    elog "  - (Web) Transcode multi-channel audio to stereo, when transcoding audio. (#5588)"
    elog "  - (Music) MP3 files with certain ID3v2 tag patterns were being ignored. (#5093)"
    elog "  - (Music) Local lyrics weren't displayed in certain cases. (#6153)"
    elog "  - (Music) Transcoding lossless audio at 'original' quality to a lossy codec could result in low-bitrate output. (#5858)"
    elog "  - (Music) Issues with Plex Mixes on NVIDIA SHIELD. (#5724)"
    elog "  - (Metadata) Sort cast entries from TVDB correctly. (#5744)"
    elog "  - (Metadata) Posters and art were unnecessarily re-downloaded on every refresh. (#6001)"
    elog "  - (Metadata) Score matches similarly for TMDB and IMDB results. (#6027)"
    elog "  - (Metadata) Issues downloading metadata from TVDB over TLS. (#5986)"
    elog "  - (Scanner) Improve performance refreshing album metadata. (#3894)"
    elog "  - (Scanner) Fixed intermittent crash on startup, particularly for FreeBSD users. (#6026)"
    elog "  - (Network) Server would transiently deny access to apps that hadn't run for a while. (#5443)"
    elog "  - (Network) Server might become unresponsive under load. (#5558)"
    elog "  - (Network) Incorrect Remote Access status reported in some cases. (#5834) (#6105)"
    elog "  - (Subtitles) Prefer embedded subtitles, over agent-provided sidecar subtitles in bundles. (#5848)"
    elog "  - (Database) Improve database backup performance. (#5839)"
    elog "  - (Transcoder) Improve streaming MKV output, improving seek performance with conformant clients. (#2495)"
    elog "  - (Hubs) Adding many episodes from a single show could swamp Recently Added hubs. (#5687)"
    elog "  - (Sync) Sync items in a failure state might not be cleared on next successful sync. (#6078)"
    elog "  - (Sync) Improved performance when garbage-collecting (#6077)"
    elog "  - (Sync) Empty sync items might not be marked as completed. (#6194)"
    elog "  - (NAS) Rare installation failures on Synology devices. (#6045)"
    elog "  - (Channels) Issues on Windows for some channels, e.g. ExportTools. (#6127)"
    elog "  - (DVR) Fix for post-processing sometimes not moving files into library (#6087)"
    elog "  - (DVR) Fix a rare crash while processing recording schedule (#6050)"
    elog "  - (DVR) When adding or removing a device, make sure we re-run scheduling (#6177)"
    elog "  - (DVR) Support for logical channels in XMLTV, may require remapping."
    elog "  - (DVR) Support for previously-shown element in XMLTV."
    elog "  - (DVR) A recording with pre-padding could be cancelled prematurely (#6256)"
    elog "  - The default sort order for albums was alphabetical (#6255)"
    elog "  - A rare crash when computing recently added TV shows."

	einfo ""

	ewarn "Please note, that the URL to the library management has changed from http://<ip>:32400/manage to http://<ip>:32400/web!"
	ewarn "If the new management interface forces you to log into myPlex and afterwards gives you an error that you need to be a plex-pass subscriber please delete the folder WebClient.bundle inside the Plug-Ins folder found in your library!"
    ewarn ""
}
