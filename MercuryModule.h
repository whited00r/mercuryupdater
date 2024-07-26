/*
MercuryModuleController.h
Grayd00r

This houses the backend for each individual module. 
ModuleController <-> ModuleViewController <-> ModuleView

So we can reuse the any component without actually needing to re-implement other things, and can put the update view and such in one single application.



*/

#import <Foundation/Foundation.h>
#import <Foundation/NSTask.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import "MercuryController.h"
#import "MercuryControllerDelegate.h"

#import "ModuleViewControllerProtocol.h"
#import "ModuleViewController.h"
#import "MercuryNavigationController.h"

@class ModuleViewController, MercuryNavigationController; //Not entirely sure why this works, but it does and lets it compile. Circular dependencies and such?
@interface MercuryModule : NSObject{
	NSMutableDictionary *moduleDict; //The dictionary that has the information of the currently installed module setup.
	NSMutableDictionary *onlineModuleDict; //The dictionary from online. Only load this up if there is one.
	NSMutableDictionary *updatesDict; //This holds the combined installed and updates dicts, only holding those that actually have an update.
	NSMutableArray *updatesList;
	NSMutableArray *localComponentsList;
	BOOL updateAvailable;
	NSString *moduleID;
	//ModuleViewController *viewController;
	id <MercuryControllerDelegate> _mController;
	ModuleViewController *_viewController;
	MercuryNavigationController *_navController;
}
@property (nonatomic, assign) id <MercuryControllerDelegate> mController;
@property (nonatomic, assign) ModuleViewController *viewController;
@property (nonatomic, assign) MercuryNavigationController *navController;

-(MercuryModule*)initWithID:(NSString*)id;

-(void)loadUp;
-(void)checkForUpdates;
-(void)reload;
-(void)installUpdates;
-(void)showUpdateScreen;
-(void)handleMessage:(NSDictionary*)message;
-(void)updatesCompleted;


@end