#import "RootViewController.h"
#import "MercuryModule.h"
#import "MercuryController.h"
#import "MercuryNavigationController.h"

@interface MercuryUpdaterApplication: UIApplication <UIApplicationDelegate> {
	UIWindow *_window;
	RootViewController *_viewController;
	MercuryController *mController;
}
@property (nonatomic, retain) UIWindow *window;
@property (strong, nonatomic) MercuryNavigationController *navController;
@end

@implementation MercuryUpdaterApplication
@synthesize window = _window;
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	mController = [[MercuryController alloc] init];
	
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	_viewController = [[RootViewController alloc] init];

	

	[_viewController setMController:mController];
	//[_window addSubview:_viewController.view];
	self.navController = [[MercuryNavigationController alloc] initWithRootViewController:_viewController];
	self.navController.navigationBar.hidden = YES;
	self.navController.mController = mController;
	mController.navController = self.navController;
	[mController loadUp];

    self.window.rootViewController = self.navController;

	[_window makeKeyAndVisible];
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackTranslucent];
}

- (void)dealloc {
	[_viewController release];
	[_window release];
	[mController release];
	[super dealloc];
}
@end

// vim:ft=objc
