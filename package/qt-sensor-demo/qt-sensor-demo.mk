################################################################################
#
# qt-sensor-demo
#
################################################################################

QT_SENSOR_DEMO_SITE = $(TOPDIR)/../qt-sensor-demo
QT_SENSOR_DEMO_SITE_METHOD = local

QT_SENSOR_DEMO_DEPENDENCIES = qt5base

define QT_SENSOR_DEMO_CONFIGURE_CMDS
	(cd $(@D); $(QT5_QMAKE))
endef

define QT_SENSOR_DEMO_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT_SENSOR_DEMO_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/qt-sensor-demo $(TARGET_DIR)/usr/bin/qt-sensor-demo

endef

$(eval $(generic-package))
