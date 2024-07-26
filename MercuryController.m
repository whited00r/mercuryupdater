#import "MercuryController.h"
#import <Foundation/NSDistributedNotificationCenter.h>
@implementation MercuryController
@synthesize modulesList, modules;
-(id)init{
	self = [super init];
	if(self){

	}
	return self;
}

-(void)loadUp{
	[[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"com.greyd00r.mercury.guiNotification" object:nil];
		NSLog(@"MercuryGUI - Starting up MercuryController");
		self.modulesList = [[NSMutableArray alloc] init];
		self.modules = [[NSMutableDictionary alloc] init];
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSFileManager *fileManager= [NSFileManager defaultManager];
		NSArray* moduleFiles = [[fileManager contentsOfDirectoryAtPath:@"/var/mobile/Library/Mercury" error:nil] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.plist'"]];
		//NSLog(@"List: %@", modulesList);
		for(NSString *modulePath in moduleFiles){
			NSDictionary *module = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/%@",modulePath]];		
			//NSLog(@"Found module: %@", module);
			[self.modulesList addObject:[module mutableCopy]];
			MercuryModule *mModule = [[MercuryModule alloc] initWithID:[module objectForKey:@"identifier"]];
			mModule.navController = self.navController;
			mModule.mController = self;
			[self.modules setObject:mModule forKey:[module objectForKey:@"identifier"]];
			[module release];
		}
		[pool drain]; 
		NSLog(@"MercuryGUI - MercuryController - Modules count is: %d", self.modulesList.count);
}

-(void)handleNotification:(NSNotification*)notification{

	
    NSLog(@"got event %@", notification);
    if([notification valueForKey:@"userInfo"]){
    	NSLog(@"Notification has userInfo");
    	NSDictionary *userInfo = [notification valueForKey:@"userInfo"];
    	if([userInfo objectForKey:@"notificationType"]){
    		NSLog(@"UserInfo has notification type of %@", [userInfo objectForKey:@"notificationType"]);
    		if([[userInfo objectForKey:@"notificationType"] isEqualToString:@"updateNotification"]){
    			NSLog(@"UserInfo notification type was updateNotification");
    			if([userInfo objectForKey:@"identifier"]){
    				NSLog(@"UserInfo has identifier of: %@", [userInfo objectForKey:@"identifer"]);
    				if([self.modules objectForKey:[userInfo objectForKey:@"identifier"]]){
    					NSLog(@"We have a module by that identifier! Time to reload it?");
    					MercuryModule *module = [self.modules objectForKey:[userInfo objectForKey:@"identifier"]];
    					[module reload];
    					//[module handleMessage:userInfo];
    				}
    			}
    		} //End of update notification





    		if([[userInfo objectForKey:@"notificationType"] isEqualToString:@"updatesDone"]){

    			NSLog(@"UserInfo notification type was updatesDone");
    			if([userInfo objectForKey:@"identifier"]){
    				NSLog(@"UserInfo has identifier of: %@", [userInfo objectForKey:@"identifer"]);
    				if([self.modules objectForKey:[userInfo objectForKey:@"identifier"]]){
    					NSLog(@"We have a module by that identifier! Time to reload it?");
    					MercuryModule *module = [self.modules objectForKey:[userInfo objectForKey:@"identifier"]];
    					[module reload];
    					[module updatesCompleted];
    					//[module handleMessage:userInfo];
    				}
    			}
    		}//End of updatesDone notification (the install of updates)

			if([userInfo objectForKey:@"identifier"]){
    				NSLog(@"UserInfo has identifier of: %@", [userInfo objectForKey:@"identifer"]);
    				if([self.modules objectForKey:[userInfo objectForKey:@"identifier"]]){
    					NSLog(@"We have a module by that identifier! Time to send the message to it?");
    					MercuryModule *module = [self.modules objectForKey:[userInfo objectForKey:@"identifier"]];
    					[module handleMessage:userInfo];
    				}
    			}
    	}
    }

}

-(void)sendAction:(NSDictionary*)action{
	NSLog(@"MercuryController - sendAction: %@", action);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSMutableArray * args = [[NSMutableArray alloc] init]; //Eh?
	
	if([action objectForKey:@"moduleID"]){
		[args addObject:@"-m"];
		[args addObject:[action objectForKey:@"moduleID"]];
	}
	if([action objectForKey:@"action"]){
		if([[action objectForKey:@"action"] isEqualToString:@"checkUpdates"]){
			[args addObject:@"-c"];
		}
		if([[action objectForKey:@"action"] isEqualToString:@"installUpdates"]){
			[args addObject:@"-i"];
		}
		if([[action objectForKey:@"action"] isEqualToString:@"restartDevice"]){
			[args addObject:@"-r"];
		}
		if([[action objectForKey:@"action"] isEqualToString:@"rebootDevice"]){
			[args addObject:@"-p"];
		}
	}
	
	NSLog(@"Args is %@", args);
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:@"/usr/bin/Mercury"];
	[task setArguments:args];
	[task launch];
	[task release];
	[args release];
	[pool drain];
}

-(void)dealloc{
NSLog(@"MercuryGUI - Releasing MercuryController");
[[NSDistributedNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"com.greyd00r.mercury.guiNotification"
                                                  object:nil];
[modulesList release];
	[super dealloc];
}

@end