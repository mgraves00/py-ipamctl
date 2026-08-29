#
COMMENT =		cli utility for manipulating simple IPAM database

V =			1.0.3
MODPY_EGG_VERSION =	${V}
REVISION =		1
DISTNAME =		py-ipamctl-${V}
PKGNAME =		py-ipamctl-${V}

CATEGORIES =		net

HOMEPATH =		https://github.com/mgraves00/py-ipamctl/

MAINTAINER =		Michael Graves

SITES = 		https://github.com/mgraves00/py-ipamctl/releases/download/v${V}/

# BSD 3 clause
PERMIT_PACKAGE =	Yes
PERMIT_DISTFILES =	Yes

MODULES =		lang/python

MODPY_PI =		No
#MODPY_PYBUILD = 	setuptools

CONFIGURE_STYLE =	none
NO_BUILD =		Yes
NO_TEST =		Yes

FLAVOR =		python3
FLAVORS =		python3
RUN_DEPENDS =		net/py-libipam${MODPY_FLAVOR} \
			www/py-requests${MODPY_FLAVOR}

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/ipamctl ${PREFIX}/bin/
	${INSTALL_DATA_DIR} ${PREFIX}/share/examples/ipam
	${INSTALL_DATA} ${WRKSRC}/ipam.ini.md ${PREFIX}/share/examples/ipam
	${INSTALL_DATA} ${WRKSRC}/ipamctl.md ${PREFIX}/share/examples/ipam
	${INSTALL_DATA} ${WRKSRC}/contrib/update_zone.sh ${PREFIX}/share/examples/ipam

.include <bsd.port.mk>
