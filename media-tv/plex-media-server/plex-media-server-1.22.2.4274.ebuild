# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8,9} )
inherit eutils systemd unpacker pax-utils

HASH="a85c82272"
DT="April 01, 2021"
LNK="https://forums.plex.tv/search?q=1.22.2.4274%20tags%3Arelease-announcements"

_APPNAME="plexmediaserver"
_USERNAME="plex"
_SHORTNAME="${_USERNAME}"
_FULL_VERSION="${PV}-${HASH}"

URI="https://downloads.plex.tv/plex-media-server-new"
DESCRIPTION="A free media library that is intended for use with a plex client."
HOMEPAGE="http://www.plex.tv/"
SRC_URI="
	amd64? ( ${URI}/${_FULL_VERSION}/debian/plexmediaserver_${_FULL_VERSION}_amd64.deb )"
SLOT="0"
LICENSE="Plex"
RESTRICT="bindist strip"
KEYWORDS="-* ~amd64 ~x86"
BDEPEND="dev-util/patchelf"
RDEPEND="
	acct-group/plex
	acct-user/plex
	net-dns/avahi"
QA_DESKTOP_FILE="usr/share/applications/plexmediamanager.desktop"
QA_PREBUILT="*"
QA_MULTILIB_PATHS=(
	"usr/lib/${_APPNAME}/.*"
)


BINS_TO_PAX_MARK=(
	"${ED}/usr/lib/plexmediaserver/Plex Script Host"
	"${ED}/usr/lib/plexmediaserver/Plex Media Scanner"
)

S="${WORKDIR}"
PATCHES=(
    "${FILESDIR}/start_script_dirfix.patch"
	"${FILESDIR}/add_gentoo_profile_as_platform_version_mb.patch"
	"${FILESDIR}/plexmediamanager.desktop.new.patch"
)

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	# Move the config to the correct place
	local config_vanilla="/etc/default/plexmediaserver"
	local config_path="/etc/${_SHORTNAME}"
	insinto "${config_path}"
	einfo "${FILESDIR}${config_vanilla}"
	# doins "${config_vanilla#/}"
	# inserting vanilla config properly
	doins "${FILESDIR}${config_vanilla}"
	# removed the following as of new start script from plex needs none of this.
	# sed -e "s#${config_vanilla}#${config_path}/${_APPNAME}#g" -i "${S}"/usr/sbin/start_pms || die

	# Remove Debian specific files
	rm -r "usr/share/doc" || die

	# Copy main files over to image and preserve permissions so it is portable
	cp -rp usr/ "${ED}"/ || die

	# Make sure the logging directory is created
	local logging_dir="/var/log/pms"
	dodir "${logging_dir}"
	fowners "${_USERNAME}":"${_USERNAME}" "${logging_dir}"
	keepdir "${logging_dir}"

	# Create default library folder with correct permissions
	local default_library_dir="/var/lib/${_APPNAME}"
	dodir "${default_library_dir}"
	fowners "${_USERNAME}":"${_USERNAME}" "${default_library_dir}"
	keepdir "${default_library_dir}"

	# Install the OpenRC init/conf files
	doinitd "${FILESDIR}/init.d/${PN}"
	doconfd "${FILESDIR}/conf.d/${PN}"

	# Mask Plex libraries so that revdep-rebuild doesn't try to rebuild them.
	# Plex has its own precompiled libraries.
	_mask_plex_libraries_revdep

	# Fix RPATH
	patchelf --force-rpath --set-rpath '$ORIGIN:$ORIGIN/../../../../../../lib' "${ED}"/usr/lib/plexmediaserver/Resources/Python/lib/python2.7/lib-dynload/_codecs_kr.so|| die

	# Install systemd service file
	systemd_newunit "${FILESDIR}/systemd/${PN}.service" "${PN}.service"

	# Add pax markings to some binaries so that they work on hardened setup
	for f in "${BINS_TO_PAX_MARK[@]}"; do
		pax-mark m "${f}"
	done
}

pkg_postinst() {
	einfo ""
	einfo "This is Plex Media Server Linux / Ubuntu 64-Bit."
	einfo "${PV}-${HASH} ${DT}"
	einfo "Plex Pass Only release"
	einfo ""
	einfo "Changes are described in the Plex Release Announcement forums:"
	einfo "${LNK}"
	einfo ""
	elog "Plex Media Server is now installed. Please check the configuration"
	elog "file in /etc/${_SHORTNAME}/${_APPNAME}"
	elog "to verify the default settings."
	elog "To start the Plex Server, run 'rc-config start plex-media-server',"
	elog "you will then be able to access your library at"
	elog "http://<ip>:32400/web/"
	einfo ""
}

# Adds the precompiled plex libraries to the revdep-rebuild's mask list
# so it doesn't try to rebuild libraries that can't be rebuilt.
_mask_plex_libraries_revdep() {
	dodir /etc/revdep-rebuild/

	# Bug: 659702. The upstream plex binary installs its precompiled package to /usr/lib.
	# Due to profile 17.1 splitting /usr/lib and /usr/lib64, we can no longer rely
	# on the implicit symlink automatically satisfying our revdep requirement when we use $(get_libdir).
	# Thus we will match upstream's directory automatically. If upstream switches their location,
	# then so should we.
	echo "SEARCH_DIRS_MASK=\"${EPREFIX}/usr/lib/plexmediaserver\"" > "${ED}"/etc/revdep-rebuild/80plexmediaserver
}
