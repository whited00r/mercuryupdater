/*
	MercuryNavigationController.m
	This handles all the showing/hiding of various views I guess? Maybe not to be used.
	RootViewController is always the same I think, just the overview of modules.
*/
#import "MercuryNavigationController.h"

@implementation MercuryNavigationController
@synthesize mController; 
-(void)showModuleList{

}

-(void)showModuleForID:(NSString*)moduleID atY:(float)y{
	NSLog(@"Attempting to change to view for: %@, %@", moduleID, mController);

	MercuryModule *module = [mController.modules objectForKey:moduleID];
	if(module){
		NSLog(@"Found module! %@, %@", self.visibleViewController.view, module.viewController.view);
		//[[[[self.navigationController viewControllers] firstObject] view] addSubview:module.viewController.view];
		NSLog(@"Y in nav controller is :%f", y);
		module.viewController.view.alpha = 0.0; //Nasty hack? Makes it not glitch when showing.
		[self.visibleViewController.view addSubview:module.viewController.view];

		[module.viewController animateOpenFromY:y];
		currentModuleID = [module valueForKey:@"moduleID"];
	}
}

-(void)showModuleForID:(NSString*)moduleID{
	NSLog(@"Attempting to change to view for: %@, %@", moduleID, mController);

	MercuryModule *module = [mController.modules objectForKey:moduleID];
	if(module){
		NSLog(@"Found module! %@, %@", self.visibleViewController.view, module.viewController.view);
		//[[[[self.navigationController viewControllers] firstObject] view] addSubview:module.viewController.view];
		[module.viewController directOpen];
		[self.visibleViewController.view addSubview:module.viewController.view];
		currentModuleID = [module valueForKey:@"moduleID"];

	}
}


-(void)closedModule{
	currentModuleID = nil;
}

-(void)showInstallationScreenForModuleID:(NSString*)moduleID{

}
@end