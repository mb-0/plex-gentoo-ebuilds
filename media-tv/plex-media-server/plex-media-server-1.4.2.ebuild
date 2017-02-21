# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# 1.4.2.3400-ab906953b
# February 19, 2017
# https://downloads.plex.tv/plex-media-server/1.4.2.3400-ab906953b/plexmediaserver_1.4.2.3400-ab906953b_amd64.deb
#

EAPI="2"
inherit eutils user

# https://downloads.plex.tv/plex-media-server/1.4.1.3362-77c6a4f80/plexmediaserver_1.4.1.3362-77c6a4f80_amd64.deb
MAGIC="3400-ab906953b"
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
	elog "Change Log for Version 1.4.1.3362"
	elog ""
    elog "  New:"
    elog "  - (Search) Include matching collections in search results. (Requires performing an Optimize Database on the server before it can be used the first time.) (#6006)"
    elog "  - (Media Flags) Updated bundle to 2017-02-15."
    elog ""
    elog "  Fixes:"
    elog ""
    elog "  - (macOS) Code-signing issues on macOS 10.9.x and 10.10.x. (#6318)"
    elog "  - (macOS) Unexpected requests for firewall access when launching the server. (#6315)"
    elog "  - (Linux) RPM installation failures. (#6314)"
    elog "  - (Chromecast) Some H.264-specific limitations were being applied to all codecs. (#6342)"
    elog "  - (Metadata) Issues obtaining artwork from third party agents. (#6326)"
    elog "  - (Streaming Brain) Crash transcoding video file with no video stream. (#6334)"
    elog "  - (Music) Crash parsing invalid GraceNote album data. (#6332)"
    elog "  - (Photos) Crash generating composite image with invalid parameters. (#6329)"
    elog "  - (Media Analysis) Crash generating thumbnails from media with over a hundred parts. (#6327)"
    elog "  - (Media Analysis) Rare crash performing deep media analysis. (#6335)"
    elog "  - (Media Optimizer) Rare crash optimizing media. (#6305)"
    elog "  - (DVR) Rare crash pruning old airings. (#6316)"
    elog "  - (Windows) Rare crash after disabling automatic library updates. (#6346)"
    elog "  - (Home) Crash viewing movie libraries with content filters with certain clients. (#6370)"
	einfo ""
	ewarn "Please note, that the URL to the library management has changed from http://<ip>:32400/manage to http://<ip>:32400/web!"
	ewarn "If the new management interface forces you to log into myPlex and afterwards gives you an error that you need to be a plex-pass subscriber please delete the folder WebClient.bundle inside the Plug-Ins folder found in your library!"
    ewarn ""
}
