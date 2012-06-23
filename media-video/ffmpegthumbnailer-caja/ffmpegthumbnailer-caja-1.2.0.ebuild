# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit mate

DESCRIPTION="Caja video thumbnailer for MATE"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=">=mate-base/mate-conf-1.2.1"
RDEPEND="${DEPEND}
	media-video/ffmpegthumbnailer
	>=mate-base/mate-file-manager-1.2.2"

DOCS="AUTHORS README"
