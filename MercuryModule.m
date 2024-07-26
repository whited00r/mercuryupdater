/*
MercuryModuleController.m
Grayd00r

This houses the backend for each individual module. 
ModuleController <-> ModuleViewController <-> ModuleView

So we can reuse the any component without actually needing to re-implement other things, and can put the update view and such in one single application.



*/

#import "MercuryModule.h"
#import "ModuleView.h"
@implementation MercuryModule
@synthesize mController; 

-(MercuryModule*)initWithID:(NSString*)identifier{

	self = [super init];
    if (self) {
        //Set up custom objects and such.
       	moduleID = identifier;
       	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSFileManager *fileManager= [NSFileManager defaultManager];
		if([fileManager fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/%@.plist",moduleID]]){
			moduleDict = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/%@.plist",moduleID]];
			if(!moduleDict == nil && ![moduleDict count] == 0){
				if([moduleDict objectForKey:@"components"]){
					localComponentsList = [[[moduleDict objectForKey:@"components"] allKeys] mutableCopy];
					NSLog(@"localComponentsList is :%@", localComponentsList);
				}
			}
			else{
				NSLog(@"MercuryApp - MercuryModule - error: Module file for %@ is invalid", identifier);
				return nil;
			}
		}
		else{
			NSLog(@"MercuryApp - MercuryModule - error: Unable to find the module file for %@", identifier);
			return nil; //Bad?
		}

		if([fileManager fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/Online/%@.plist",moduleID]]){
			onlineModuleDict = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/Online/%@.plist",moduleID]];
			if(!onlineModuleDict == nil && ![onlineModuleDict count] == 0){
				[self generateUpdatesList];
			}
			else{
				NSLog(@"MercuryApp - MercuryModule - error: Online module file for %@ is invalid", identifier);
			}
		}
		else{
			NSLog(@"MercuryApp - MercuryModule - error: Unable to find online dictionary for %@. Did you make sure to set the permissions for the Mercury/Online folder to the same as the Mercury folder itself?", moduleID);
		}
		self.viewController = [[ModuleViewController alloc] init];
		self.viewController.module = self;
		[self.viewController.view createSnapshot];
		[pool drain];
    }
    return self;
}


-(void)loadUp{

}

-(void)checkForUpdates{
	NSLog(@"MercuryModule - checkForUpdates");
	if(moduleID){
		NSLog(@"MercuryModule - checkForUpdates - Has module id, sending off action to %@!", mController);
		NSMutableDictionary *action = [[NSMutableDictionary alloc] init];
		[action setObject:moduleID forKey:@"moduleID"];
		[action setObject:@"checkUpdates" forKey:@"action"];
		[self.mController sendAction:action];
		[action release];
	}
}

-(void)generateUpdatesList{
	if(!onlineModuleDict == nil && ![onlineModuleDict count] == 0){
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];


	if(updatesDict) [updatesDict release];
	updatesDict = nil;
	if(updatesList) [updatesList release];
	updatesList = nil;
	updatesDict = [[NSMutableDictionary alloc] init];

	
	NSLog(@"MercuryModule %@ update list generation", moduleID);
	if([onlineModuleDict objectForKey:@"components"] && [moduleDict objectForKey:@"components"]){
		NSLog(@"- OnlineDict and moduleDict have components");
		for(NSString *componentID in [onlineModuleDict objectForKey:@"components"]){
			NSLog(@"-- Checking status of component %@", componentID);
			NSMutableDictionary *component = [[onlineModuleDict objectForKey:@"components"] objectForKey:componentID];
			[component setObject:[NSNumber numberWithBool:FALSE] forKey:@"isObsolete"];
			if([[moduleDict objectForKey:@"components"] objectForKey:componentID]){
				NSLog(@"--- moduleDict components has the module %@", componentID);
				if([[[[onlineModuleDict objectForKey:@"components"] objectForKey:componentID] objectForKey:@"version"] floatValue] > [[[[moduleDict objectForKey:@"components"] objectForKey:componentID] objectForKey:@"version"] floatValue]){
					NSLog(@"---- moduleDict component %@ is out of date, adding to updatesDict!", componentID);
					[component setObject:[NSNumber numberWithBool:TRUE] forKey:@"updatesAvailable"];
					[updatesDict setObject:component forKey:componentID];
				}
			}
			else{
				NSLog(@"--- moduleDict components does not have the module %@, so there is an update available here. Adding to updatesDict", componentID);
				[component setObject:[NSNumber numberWithBool:TRUE] forKey:@"updatesAvailable"];
				[component setObject:[NSNumber numberWithBool:TRUE] forKey:@"isNewComponent"];
				[updatesDict setObject:component forKey:componentID];
			}
			
		}

		for(NSString *componentID in [moduleDict objectForKey:@"components"]){
			NSLog(@"-- Checking to see if component %@ is obsolte", componentID);
			NSMutableDictionary *component = [[moduleDict objectForKey:@"components"] objectForKey:componentID];
		
			if(![[onlineModuleDict objectForKey:@"components"] objectForKey:componentID]){ //This component is not online, so we have to remove this one.
				NSLog(@"--- Component %@ was obsolte, adding to update dict for removal in next udpate", componentID);
				[component setObject:[NSNumber numberWithBool:TRUE] forKey:@"isObsolete"];
				[updatesDict setObject:component forKey:componentID];
			}

			
		}
	}

	if(![onlineModuleDict objectForKey:@"components"] && [moduleDict objectForKey:@"components"]){ //No online components, but there are local ones to be removed for whatever reason
		NSLog(@"- OnlineDict does not have components, but moduleDict does. Setting all as obsolete and adding to updatesDict for removal on next upgrade");
		for(NSString *componentID in [moduleDict objectForKey:@"components"]){
			NSLog(@"--- Component %@ was obsolte, adding to update dict for removal in next udpate", componentID);
			NSMutableDictionary *component = [[moduleDict objectForKey:@"components"] objectForKey:componentID];
			[component setObject:[NSNumber numberWithBool:TRUE] forKey:@"isObsolete"];
			[updatesDict setObject:component forKey:componentID];
		}
	}
	if(updatesDict){
		updatesList = [[updatesDict allKeys] mutableCopy];
		/* //used to remove the duplicate entries for installed vs updates in the module view. Uncomment if it looks better eh? Maybe have an indicator for installed version vs update available
		if(localComponentsList){
			for(NSString *componentID in updatesList){
				if(localComponentsList containsObject:componentID]){
					NSLog(@"About to remove component %@ from localComponentsList because it is in the updatesList", componentID);
					[localComponentsList removeObjectAtIndex:[localComponentsList indexOfObject:componentID]];
				}
			}
		}
		*/
	}

	[pool drain];
	}
	else{
		NSLog(@"MercuryApp - MercuryModule - error: Online module file for %@ is invalid", moduleID);
	}
}

-(void)reload{
	if(moduleDict) [moduleDict release];
	moduleDict = nil;
	if(onlineModuleDict) [onlineModuleDict release];
	onlineModuleDict = nil;
	if(localComponentsList) [localComponentsList release];
	localComponentsList = nil;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSFileManager *fileManager= [NSFileManager defaultManager];
		if([fileManager fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/%@.plist",moduleID]]){
			moduleDict = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/%@.plist",moduleID]];
			if(!moduleDict == nil && ![moduleDict count] == 0){
				if([moduleDict objectForKey:@"components"]){
					localComponentsList = [[[moduleDict objectForKey:@"components"] allKeys] mutableCopy];
					NSLog(@"localComponentsList is :%@", localComponentsList);
				}
			}
			else{
				NSLog(@"MercuryApp - MercuryModule - error: Module file for %@ is invalid", moduleID);
				
			}
		}
		else{
			NSLog(@"MercuryApp - MercuryModule - error: Unable to find the module file for %@", moduleID);
			//return nil; //Bad?
		}
		if([fileManager fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/Online/%@.plist",moduleID]]){
			onlineModuleDict = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/Online/%@.plist",moduleID]];
			if(!onlineModuleDict == nil && ![onlineModuleDict count] == 0){
				[self generateUpdatesList];
			}
			else{
				NSLog(@"MercuryApp - MercuryModule - error: Online module file for %@ is invalid", moduleID);
			}
		}
		else{
			NSLog(@"MercuryApp - MercuryModule - error: Unable to find online dictionary for %@. Did you make sure to set the permissions for the Mercury/Online folder to the same as the Mercury folder itself?", moduleID);
		}

		[self.viewController reload];
		[pool drain];
    
}

-(void)installUpdates{
	NSLog(@"MercuryModule - installUpdates");
	if(moduleID){
		NSLog(@"MercuryModule - installUpdates - Has module id, sending off action to %@!", mController);
		NSMutableDictionary *action = [[NSMutableDictionary alloc] init];
		[action setObject:moduleID forKey:@"moduleID"];
		[action setObject:@"installUpdates" forKey:@"action"];
		[self.mController sendAction:action];
		[action release];
	}
}

-(void)showUpdateScreen{

}

-(void)restart{
		NSMutableDictionary *action = [[NSMutableDictionary alloc] init];
		[action setObject:@"rebootDevice" forKey:@"action"];
		[self.mController sendAction:action];
		[action release];
}

-(void)handleMessage:(NSDictionary*)message{
bool handledMessage = false;
if([message objectForKey:@"notificationType"]){
    NSLog(@"UserInfo has notification type of %@", [message objectForKey:@"notificationType"]);
    if([[message objectForKey:@"notificationType"] isEqualToString:@"updateNotification"] || [[message objectForKey:@"notificationType"] isEqualToString:@"updatesDone"]){
    	[self.viewController stopRefreshAnimation];
    	handledMessage = TRUE;
    }
    if([[message objectForKey:@"notificationType"] isEqualToString:@"downloadError"] || [[message objectForKey:@"notificationType"] isEqualToString:@"downloadStart"] || [[message objectForKey:@"notificationType"] isEqualToString:@"downloadPass"] || [[message objectForKey:@"notificationType"] isEqualToString:@"installStart"] || [[message objectForKey:@"notificationType"] isEqualToString:@"installPass"] || [[message objectForKey:@"notificationType"] isEqualToString:@"installError"]){
    	handledMessage = TRUE;
    	[self.viewController installLogMessage:message];
    }

    if([[message objectForKey:@"notificationType"] isEqualToString:@"errorCheckingUpdates"]){
    	handledMessage = TRUE;
    	[self.viewController stopRefreshAnimation];

    	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"ERROR_CHECKING_UPDATES_TITLE", nil)]
                          message:[NSString stringWithFormat:NSLocalizedString(@"ERROR_CHECKING_UPDATES_BODY", nil), [moduleDict objectForKey:@"displayName"]]
                          delegate:nil 
                          cancelButtonTitle:NSLocalizedString(@"POPUP_ALERT_CLOSE", nil)
                          otherButtonTitles:nil];

		[alert show];
		[alert release];
		if(self.viewController.isInstalling){
			[self.viewController installScreenRequestedClose];
		}

    }

    if([[message objectForKey:@"notificationType"] isEqualToString:@"installerNotification"]){
    	handledMessage = TRUE;
    	[self.viewController installScreenRequestedClose];
    	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"INSTALLER_UPDATE_TITLE", nil)]
                          message:[NSString stringWithFormat:NSLocalizedString(@"INSTALLER_UPDATE_BODY", nil), [onlineModuleDict objectForKey:@"requiredInstallerVersion"]]
                          delegate:nil 
                          cancelButtonTitle:NSLocalizedString(@"POPUP_ALERT_CLOSE", nil)
                          otherButtonTitles:nil];

		[alert show];
		[alert release];

    }

    if([[message objectForKey:@"notificationType"] isEqualToString:@"errorStartingMercury"]){
    	handledMessage = TRUE;
    	[self.viewController installScreenRequestedClose];
    	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"MERCURY_ERROR_STARTING_TITLE", nil)]
                          message:[NSString stringWithFormat:NSLocalizedString(@"MERCURY_ERROR_STARTING_BODY", nil)]
                          delegate:nil 
                          cancelButtonTitle:NSLocalizedString(@"POPUP_ALERT_CLOSE", nil)
                          otherButtonTitles:nil];

		[alert show];
		[alert release];

    }
}


if(!handledMessage){

	  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"UNHANDLED_MESSAGE_TITLE", nil), [moduleDict objectForKey:@"displayName"]]
                          message:[NSString stringWithFormat:@"Debug info:\n%@", message]
                          delegate:nil 
                          cancelButtonTitle:NSLocalizedString(@"POPUP_ALERT_CLOSE", nil)
                          otherButtonTitles:nil];

[alert show];
[alert release];
}
}

-(void)updatesCompleted{
	[self.viewController updatesCompleted];
}

-(ModuleView*)modueView{
	return self.viewController.view;
}

-(void)dealloc{
	[self.viewController release];

	[super dealloc];
}

@end