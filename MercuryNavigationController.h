/*
	MercuryNavigationController.h
	This handles all the showing/hiding of various views I guess? Maybe not to be used.
*/

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "MercuryController.h"

@interface MercuryNavigationController : UINavigationController{ // Why make this a UINavigationController? 
	NSString *currentModuleID;
	id <MercuryControllerDelegate> mController;
} 

@property (nonatomic, assign) id <MercuryControllerDelegate> mController;

-(void)showModuleList;
-(void)showModuleForID:(NSString*)moduleID; //Used to jump straight into showing a module.
-(void)showInstallationScreenForModuleID:(NSString*)moduleID;
-(void)showModuleForID:(NSString*)moduleID atY:(float)y;
@end