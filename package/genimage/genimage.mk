################################################################################
#
# genimage
#
################################################################################

GENIMAGE_VERSION = abc1c32378debaccdfb63c711de56f3a1becb84b
GENIMAGE_SITE = $(call github,pengutronix,genimage,$(GENIMAGE_VERSION))
HOST_GENIMAGE_DEPENDENCIES = host-pkgconf host-libconfuse
# fetching from git
GENIMAGE_AUTORECONF = YES
GENIMAGE_LICENSE = GPL-2.0
GENIMAGE_LICENSE_FILES = COPYING

$(eval $(host-autotools-package))
