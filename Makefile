include theos/makefiles/common.mk

TWEAK_NAME = KeyboardLessCommandTab
KeyboardLessCommandTab_FILES = Tweak.xmi
KeyboardLessCommandTab_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
