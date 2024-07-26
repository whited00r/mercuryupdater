GO_EASY_ON_ME = 1
THEOS_DEVICE_IP = 192.168.1.19
include $(THEOS)/makefiles/common.mk
ARCHS= armv7

APPLICATION_NAME = MercuryUpdater
MercuryUpdater_FILES = main.m MercuryUpdaterApplication.mm RootViewController.mm MercuryModule.m MercuryNavigationController.m ModuleViewController.m ModuleView.m MercuryController.m ModuleEntryCell.m UIImage+Resize.m UIImage+StackBlur.m UIImage+LiveBlur.m ComponentEntryCell.m UIView+ToolTip.m ModuleInstallView.m
MercuryUpdater_FRAMEWORKS = UIKit CoreGraphics Foundation CoreFoundation QuartzCore Accelerate

include $(THEOS_MAKE_PATH)/application.mk
