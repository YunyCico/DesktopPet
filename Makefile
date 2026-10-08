export ARCHS = arm64
export TARGET = iphone:clang:latest:16.0
export SYSROOT = iphone
THEOS_PACKAGE_SCHEME ?= rootless
export THEOS_PACKAGE_SCHEME

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DesktopPet
DesktopPet_FILES = Tweak.xm
DesktopPet_CFLAGS = -fobjc-arc
DesktopPet_FRAMEWORKS = UIKit CoreGraphics QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload"
