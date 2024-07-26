/*
MercuryController.h
Grayd00r

This is the backend which communicates anything needed to the actual backbone of mercury (update checker, handling notifications, etc)


*/

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#import "MercuryModule.h"
#import "MercuryControllerDelegate.h"
#import "MercuryNavigationController.h"

@class MercuryNavigationController;
@interface MercuryController : NSObject <MercuryControllerDelegate>{
	NSMutableArray *_modulesList;
	NSMutableDictionary *_modules;
}
@property (nonatomic, assign) id messageHandler; //What handles the callbacks from this thing for the system type alerts?
@property (nonatomic, assign) NSMutableArray *modulesList;
@property (nonatomic, assign) NSMutableDictionary *modules;

@property (nonatomic, assign) MercuryNavigationController *navController;
-(void)loadUp;
-(void)sendAction:(NSDictionary*)action;
-(void)handleNotification:(NSNotification*)notification;


@end