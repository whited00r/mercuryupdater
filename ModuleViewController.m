/*
MercuryModuleViewController.m
Grayd00r

This houses the backend for each individual module. 
ModuleController <-> ModuleViewController <-> ModuleView

So we can reuse the any component without actually needing to re-implement other things, and can put the update view and such in one single application.


*/


#import "ModuleViewController.h"
#define debug TRUE
#define useStaticBackground TRUE


@implementation ComponentHeaderView : UIView
-(id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if(self){
		
		self.blurredSnapshotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		//self.blurredSnapshotView.image = [self blurredBackgroundImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
    	self.blurredSnapshotView.contentMode = UIViewContentModeTopLeft; 
    	self.blurredSnapshotView.backgroundColor = [UIColor clearColor];
    	self.blurredSnapshotView.clipsToBounds = YES;
    	//self.iconDivider.layer.cornerRadius = 10;
    	self.blurredSnapshotView.layer.masksToBounds = YES;
    	self.blurredSnapshotView.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
    	self.blurredSnapshotView.alpha = 1.0;
    	self.blurredSnapshotView.userInteractionEnabled = FALSE;
    	[self addSubview:self.blurredSnapshotView];
	}
	return self;
}

-(void)createSnapshotOfView:(UIScrollView*)view{
//if(!self.viewController.hasSnapshot){
	//self.frame = CGRectMake([[UIScreen mainScreen] applicationFrame].size.width, 0,self.frame.size.width, [[UIScreen mainScreen] applicationFrame].size.height);
	//Step 2: Hide the blurredSnapshotView so we don't snapshot that if it is visible for some reason
	self.blurredSnapshotView.alpha = 0.0;

	/*
    moduleView.versionBlob.frame = CGRectMake(self.view.frame.size.width - 60, 10, 50, 30);
 	moduleView.moduleVersion.frame = CGRectMake(self.view.frame.size.width - 60, 10, 50, 30);
	moduleView.iconDivider.frame = CGRectMake(54, 10, 1, 30);
 	moduleView.iconUnderlay.frame = CGRectMake(15, 10, 30, 30);
   	moduleView.icon.frame = CGRectMake(17, 12, 26, 26);
   	moduleView.moduleName.frame = CGRectMake(60,0,200, 50);
   	*/
   	//Step 3: make the view we are going to snapshot completely visible, but it is now offscreen so it doesn't matter and we can snapshot it.
   	self.alpha = 0.0;
   	

   	//Step 4: Create the snapshot of the view. It should know what to do with it.

 UIGraphicsBeginImageContextWithOptions(view.contentSize, NO, 0.0);
    {
    CGPoint savedContentOffset = view.contentOffset;
        CGRect savedFrame = view.frame;

        view.contentOffset = CGPointZero;
        view.frame = CGRectMake(0, 0, view.contentSize.width, view.contentSize.height);

        [view.layer renderInContext: UIGraphicsGetCurrentContext()];     
        UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();

    self.viewController.blurredTableView = [[screenShotimage fastBlurWithQuality:4 interpolation:4 blurRadius:15] copy];
    NSLog(@"Snapshot image is :%@" , self.viewController.blurredTableView);

        view.contentOffset = savedContentOffset;
        view.frame = savedFrame;
     }
     UIGraphicsEndImageContext();
   	//Step 5: Hide the contentView and other views we need to hide
   
	self.alpha = 1.0;
	//Step 6: Make the snapshot view visible, and the frame back on-screen.  (but the whole view containing the snapshot and everything else isn't visible right now)
	self.blurredSnapshotView.alpha = 1.0;
	//self.frame = CGRectMake(0, 0,self.frame.size.width, self.frame.size.width);
	    	self.blurredSnapshotView.clipsToBounds = YES;
    	self.blurredSnapshotView.layer.masksToBounds = YES;
    	self.blurredSnapshotView.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
   	self.viewController.hasSnapshot = TRUE;
   //	 [UIImagePNGRepresentation(self.viewController.blurredTableView) writeToFile: @"/tmp/test.png" atomically: YES];
 //}
    NSLog(@"Snapshot image is :%@" , self.viewController.blurredTableView);
self.blurredSnapshotView.image = self.viewController.blurredTableView;
}

@end

@implementation ModuleViewController
@synthesize hasSnapshot, isInstalling;

- (void)loadView {
	//[super loadView];
	CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
	screenWidth = screenFrame.size.width;
	//Bonus height.
	screenHeight = screenFrame.size.height;
	moduleView = [[ModuleView alloc] initWithFrame:screenFrame];
	self.view = moduleView;
	self.view.frame = CGRectMake(0,0,screenFrame.size.width, 0);
	self.view.alpha = 0.0;
	moduleView.viewController = self;
	if(debug) NSLog(@"Self module is :%@", self.module);
	moduleView.moduleDict = [self.module valueForKey:@"moduleDict"];
  moduleView.onlineDict = [self.module valueForKey:@"onlineModuleDict"];
	[moduleView loadUp];

    if(debug) NSLog(@"ModuleViewController - LoadView called");

}

-(void)viewDidLoad{
CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
screenWidth = screenFrame.size.width;
//Bonus height.
screenHeight = screenFrame.size.height;
  if(debug) NSLog(@"ScreenWidth: %f", screenWidth);

}

-(void)restartPressed{
  [self.module restart];
}


-(void)reload{
  moduleView.moduleDict = [self.module valueForKey:@"moduleDict"];
  moduleView.onlineDict = [self.module valueForKey:@"onlineModuleDict"];
  [moduleView loadUp];
}

-(void)closePressed{

	[UIView animateWithDuration:0.25
                delay:0.0
                options:UIViewAnimationCurveEaseIn
              	animations:^{
              	
					//self.view.frame = CGRectMake(0,0, self.view.frame.size.width, [[UIScreen mainScreen] applicationFrame].size.height);
        			moduleView.blurredSnapshotView.alpha = 1.0;
        			/*
    				moduleView.versionBlob.frame = CGRectMake(self.view.frame.size.width - 60, 10, 50, 30);
 					moduleView.moduleVersion.frame = CGRectMake(self.view.frame.size.width - 60, 10, 50, 30);
					moduleView.iconDivider.frame = CGRectMake(54, 10, 1, 30);
 					moduleView.iconUnderlay.frame = CGRectMake(15, 10, 30, 30);
   					moduleView.icon.frame = CGRectMake(17, 12, 26, 26);
   					moduleView.moduleName.frame = CGRectMake(60,0,200, 50);
					*/
              }
              completion:^(BOOL finished){
              	moduleView.contentView.alpha = 0.0;
              	[UIView animateWithDuration:0.25
                delay:0
                options:nil
              	animations:^{
              		moduleView.alpha = 0.0;
              		
					//self.view.transform=CGAffineTransformMakeScale(1.1, 1.1);
					//self.view.frame = CGRectMake(0,0,self.view.frame.size.width, [[UIScreen mainScreen] applicationFrame].size.height);
					//moduleView.blurredSnapshotView.alpha = 0.0;
					/*
        			moduleView.versionBlob.frame = CGRectMake(self.view.frame.size.width - 60, 40, 50, 30);
 					moduleView.moduleVersion.frame = CGRectMake(self.view.frame.size.width - 60, 40, 50, 30);
					moduleView.iconDivider.frame = CGRectMake(54, 40, 1, 30);
 					moduleView.iconUnderlay.frame = CGRectMake(15, 40, 30, 30);
   					moduleView.icon.frame = CGRectMake(17, 42, 26, 26);
   					moduleView.moduleName.frame = CGRectMake(60,30,200, 50);
   					*/
   					moduleView.closeButton.alpha = 1.0;
   					//self.view.center = CGPointMake(CGRectGetMidX([[UIScreen mainScreen] applicationFrame]), CGRectGetMidY([[UIScreen mainScreen] applicationFrame]));
              }
              completion:^(BOOL finished){
              	  	[self.view removeFromSuperview];
              }]; 
            
              }]; 

	[self.module.navController closedModule];
}

-(void)changelogPressed{
  if([moduleView.moduleDict objectForKey:@"changelogURL"]){
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[moduleView.moduleDict objectForKey:@"changelogURL"]]];
  }
}

-(void)installPressed{
  NSLog(@"ModuleViewController - installPressed");
  NSString *updateText = @"";
  if(moduleView.installView.updatesToInstall > 1){
    updateText = [NSString stringWithFormat:NSLocalizedString(@"INSTALL_UPDATE_ALERT_BODY", nil), [moduleView.moduleDict objectForKey:@"updatesAvailable"], [moduleView.moduleDict objectForKey:@"displayName"]];
  }
  else{
    updateText = [NSString stringWithFormat:NSLocalizedString(@"INSTALL_1UPDATE_ALERT_BODY", nil), [moduleView.moduleDict objectForKey:@"updatesAvailable"], [moduleView.moduleDict objectForKey:@"displayName"]];
  }
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"INSTALL_UPDATE_ALERT_TITLE", nil), [moduleView.moduleDict objectForKey:@"displayName"]]
                          message:updateText
                          delegate:self 
                          cancelButtonTitle:NSLocalizedString(@"INSTALL_UPDATE_ALERT_CANCEL", nil)
                          otherButtonTitles:NSLocalizedString(@"INSTALL_UPDATE_ALERT_OKAY", nil), nil];
  [moduleView.installView setAnimationWait:0.8 length:1.4 alpha:0.4];
 [moduleView showInstallScreen];

[alert show];
[alert release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
      //cancel clicked ...do your action
       [moduleView hideInstallScreen];
    }else{
            self.isInstalling = TRUE;
             [moduleView.installView setAnimationWait:0.4 length:1.0 alpha:0.0];
             [moduleView.installView startUpdates];
             [UIApplication sharedApplication].idleTimerDisabled = TRUE;
              [self.module installUpdates]; 
    }
}

-(void)updatesCompleted{
 [moduleView.installView setAnimationWait:1.0 length:1.8 alpha:0.0];
[moduleView.installView updatesCompleted];
}

-(void)installScreenRequestedClose{
   self.isInstalling = FALSE;
   [UIApplication sharedApplication].idleTimerDisabled = FALSE;
  [moduleView hideInstallScreen];
}


- (void)runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    [view.layer removeAllAnimations];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;

    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)stopRefreshAnimation{
  [moduleView.refreshButton.layer removeAllAnimations];
}

-(void)refreshPressed{
  [self runSpinAnimationOnView:moduleView.refreshButton duration:1.75 rotations:1 repeat:HUGE_VALF];
  [self.module checkForUpdates];
}


-(void)installLogMessage:(NSDictionary*)message{
  if(self.isInstalling){
    [moduleView.installView handleLogMessage:message];
  }
}

-(void)animateOpenFromY:(float)y{ //Opens it up from that point on the screen.
	if(debug) NSLog(@"Y is now: %f", y);
	//self.view.transform=CGAffineTransformMakeScale(1.0, 1.0);


	[moduleView createSnapshot];
   	
         [UIView animateWithDuration:0.25
                delay:0.0
                options:UIViewAnimationCurveEaseIn
              	animations:^{
              		//Step 7: Make the view visible. This means the snapshot view will in effect be animated in
              		moduleView.alpha = 1.0;
					//self.view.transform=CGAffineTransformMakeScale(1.1, 1.1);
					//self.view.frame = CGRectMake(0,0,self.view.frame.size.width, [[UIScreen mainScreen] applicationFrame].size.height);
					//moduleView.blurredSnapshotView.alpha = 0.0;
					/*
        			moduleView.versionBlob.frame = CGRectMake(self.view.frame.size.width - 60, 40, 50, 30);
 					moduleView.moduleVersion.frame = CGRectMake(self.view.frame.size.width - 60, 40, 50, 30);
					moduleView.iconDivider.frame = CGRectMake(54, 40, 1, 30);
 					moduleView.iconUnderlay.frame = CGRectMake(15, 40, 30, 30);
   					moduleView.icon.frame = CGRectMake(17, 42, 26, 26);
   					moduleView.moduleName.frame = CGRectMake(60,30,200, 50);
   					*/
   					moduleView.closeButton.alpha = 1.0;
   					//self.view.center = CGPointMake(CGRectGetMidX([[UIScreen mainScreen] applicationFrame]), CGRectGetMidY([[UIScreen mainScreen] applicationFrame]));
              }
              completion:^(BOOL finished){
             	//Step 8: make the content view visible without animation. This is underneath the snapshot view though, so we don't see it come into view
              	moduleView.contentView.alpha = 1.0;
              	[UIView animateWithDuration:0.3
                delay:0
                options:nil
              	animations:^{
              		//Step 9: animate the snapshot view alpha down, so it looks like the contentView blurs into view.
              		moduleView.blurredSnapshotView.alpha = 0.0;
              		
			}
              completion:^(BOOL finished){
              	
              }]; 
              }]; 

         

         lastOpenedY = y;
        

}


-(void)directOpen{ //No animation and it doesn't care where the starting point is.
	self.view.frame = CGRectMake(0,0,self.view.frame.size.width, [[UIScreen mainScreen] applicationFrame].size.height);
	lastOpenedY = [[UIScreen mainScreen] applicationFrame].size.height / 2;
	moduleView.closeButton.alpha = 1.0;
 		moduleView.blurredSnapshotView.alpha = 0.0;
              		moduleView.contentView.alpha = 1.0;
	/*
	moduleView.versionBlob.frame = CGRectMake(self.view.frame.size.width - 60, 40, 50, 30);
	moduleView.moduleVersion.frame = CGRectMake(self.view.frame.size.width - 60, 40, 50, 30);
	moduleView.iconDivider.frame = CGRectMake(54, 40, 1, 30);
	moduleView.iconUnderlay.frame = CGRectMake(15, 40, 30, 30);
	moduleView.icon.frame = CGRectMake(17, 42, 26, 26);
	*/
	moduleView.moduleName.frame = CGRectMake(60,30,200, 50);
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//if(debug) NSLog(@"Moduleslist count is: %@", mController);
		if(section == 0){
			if([[[self.module valueForKey:@"moduleDict"] objectForKey:@"updatesAvailable"] intValue] > 0){
				return [[self.module valueForKey:@"updatesList"] count];
			}
			else{
				if([self.module valueForKey:@"localComponentsList"]){
					return [[self.module valueForKey:@"localComponentsList"] count];
				}
				else{
					return 0;
				}
			}
        	
    	}
    	if(section == 1){
    		if([self.module valueForKey:@"localComponentsList"]){
    			if(debug) NSLog(@"localComponentsList count is :%i", [[self.module valueForKey:@"localComponentsList"] count]);
				return [[self.module valueForKey:@"localComponentsList"] count];
			}
			else{
				return 0;
			}
    	}
	 	return 0;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if([self.module valueForKey:@"updatesDict"])
    if([[[self.module valueForKey:@"moduleDict"] objectForKey:@"updatesAvailable"] intValue] > 0 && [[self.module valueForKey:@"moduleDict"] objectForKey:@"components"]){
    	return 2;
	}
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    NSDictionary *cellDict = nil;
    NSString *componentID = @"default";
      NSLog(@"ModuleViewCOntroller - cellForRowAtIndexPath - update count is %i", [[[self.module valueForKey:@"moduleDict"] objectForKey:@"updatesAvailable"] intValue]);
    if(indexPath.section == 0 && [[[self.module valueForKey:@"moduleDict"] objectForKey:@"updatesAvailable"] intValue] > 0){
    	if(debug) NSLog(@"IndexPath.section is :%i - IndexPath.row is :%i for updatesDict", indexPath.section, indexPath.row);
    	cellDict = [[self.module valueForKey:@"updatesDict"] objectForKey:[[self.module valueForKey:@"updatesList"] objectAtIndex:indexPath.row]]; //FIXME: put error handling in to make sure we have this!
		componentID = [[self.module valueForKey:@"updatesList"] objectAtIndex:indexPath.row];
	}

	if(indexPath.section == 0 && [[[self.module valueForKey:@"moduleDict"] objectForKey:@"updatesAvailable"] intValue] <= 0){
		if(debug) NSLog(@"IndexPath.section is :%i - IndexPath.row is :%i for localComponentsList", indexPath.section, indexPath.row);
		cellDict = [[[self.module valueForKey:@"moduleDict"] objectForKey:@"components"] objectForKey:[[self.module valueForKey:@"localComponentsList"] objectAtIndex:indexPath.row]]; //FIXME: put error handling in to make sure we have this!
		componentID = [[self.module valueForKey:@"localComponentsList"] objectAtIndex:indexPath.row];
	}
    if(indexPath.section == 1){
    	if(debug) NSLog(@"IndexPath.section is :%i - IndexPath.row is :%i for localComponentsList", indexPath.section, indexPath.row);
    	cellDict = [[[self.module valueForKey:@"moduleDict"] objectForKey:@"components"] objectForKey:[[self.module valueForKey:@"localComponentsList"] objectAtIndex:indexPath.row]]; //FIXME: put error handling in to make sure we have this!
		componentID = [[self.module valueForKey:@"localComponentsList"] objectAtIndex:indexPath.row];
	}	

    ComponentEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil)
        cell = [[ComponentEntryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.backgroundView = [[UIView alloc] init];
    [cell.backgroundView setBackgroundColor:[UIColor clearColor]];
    //[[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if(debug) NSLog(@"Loading up: %@", cellDict);
    cell.componentName.text = [cellDict objectForKey:@"displayName"];
    cell.componentTitle = [[cellDict objectForKey:@"displayName"] copy];
    cell.componentID = componentID;
    if([cellDict objectForKey:@"updatesAvailable"]){
      cell.updatesAvailable = [[cellDict objectForKey:@"updatesAvailable"] boolValue];
      
    }
    else{
      cell.updatesAvailable = FALSE;
    }
    if([cellDict objectForKey:@"isObsolete"]){
    	cell.isObsolete = [[cellDict objectForKey:@"isObsolete"] boolValue];
    }
    else{
      cell.isObsolete = FALSE;
    }

    cell.componentVersion.text = [NSString stringWithFormat:@"v%@",[cellDict objectForKey:@"version"]];
    [cell loadUp];
    if(debug) NSLog(@"Cell is: %@", cell);

    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{

  NSLog(@"ModuleViewController - HeaderViewInSection - update count is %i", [[[self.module valueForKey:@"moduleDict"] objectForKey:@"updatesAvailable"] intValue]);
	//TODO/FIXME: Could use a custom subclass here to allow for it to have a blurred background to be adjusted in the scroll method.
  ComponentHeaderView *headerView = [[[ComponentHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];
  headerView.tag = 4892 + section;
  headerView.viewController = self;
  //[headerView createSnapshotOfView:tableView];
  headerView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.9];
  UILabel *sectionName = [[[UILabel alloc] init] autorelease];
  sectionName.frame = CGRectMake(15,0,200, 30);
  sectionName.alpha = 0.9;
  sectionName.textColor = [UIColor whiteColor];
  sectionName.backgroundColor = [UIColor clearColor];
  sectionName.font = [UIFont boldSystemFontOfSize:20.0];
  [headerView addSubview:sectionName];
  NSString *sectionTitle;
  if (section == 0){
     if([[[self.module valueForKey:@"moduleDict"] objectForKey:@"updatesAvailable"] intValue] > 0){
				sectionTitle = NSLocalizedString(@"MODULE_UPDATES_SECTION_TITLE", nil);
        headerView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.25f alpha:0.90];
			}
			else{
				if([self.module valueForKey:@"localComponentsList"]){
					sectionTitle = NSLocalizedString(@"MODULE_INSTALLED_SECTION_TITLE", nil);
					
				}
				else{
					sectionTitle = @"";
				}
			}
  }
  else{
     sectionTitle = NSLocalizedString(@"MODULE_INSTALLED_SECTION_TITLE", nil);
     
  }
  sectionName.text = sectionTitle;
  return headerView;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       //NSDictionary *cellDict = [mController.modulesList objectAtIndex:indexPath.row]; //FIXME: put error handling in to make sure we have this!
       [tableView deselectRowAtIndexPath:indexPath animated:YES];
        /*
        [UIView animateWithDuration:0.3
                      delay:0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                   
                   [componentsTableView cellForRowAtIndexPath:indexPath].transform=CGAffineTransformMakeScale(1.05, 1.05);
           
                 }
                 completion:^(BOOL finished){

                  [UIView animateWithDuration:0.3
                      delay:0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                   
                   [componentsTableView cellForRowAtIndexPath:indexPath].transform=CGAffineTransformMakeScale(0.95, 0.95);
           
                 }
                 completion:^(BOOL finished){
                  [UIView animateWithDuration:0.3
                      delay:0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                   [componentsTableView cellForRowAtIndexPath:indexPath].transform=CGAffineTransformMakeScale(1.0, 1.0);
                 } completion:nil];
                 }];
                 }];
                 */
  ComponentEntryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  	//NSString *alertString = NSLocalizedString(@"COMPONENT_ALERT_BODY_TEXT", nil);
//alertString = [NSString stringWithFormat:alertString, cell.componentID];
//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:cell.componentTitle message:alertString delegate:self cancelButtonTitle:NSLocalizedString(@"CLOSE_COMPONENT_ALERT_LABEL", nil) otherButtonTitles:nil];
            
//[alert show];
//[alert release];
  //CGRect rect = [cell convertRect:cell.frame toView:self.view];
 // if(debug) NSLog(@"Cell is :%@", cell);
  //if(debug) NSLog(@"Rect y is: %f", rect.origin.y);
 //[self.navigationController showModuleForID:[cellDict objectForKey:@"identifier"] atY:rect.origin.y];
//[self.navigationController showModuleForID:[cellDict objectForKey:@"identifier"]];
    //   if(debug) NSLog(@"Touched %@, %f", [cellDict objectForKey:@"identifier"], rect.origin.y);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView_ {
  
    
   //Nasty nasty nasty hack to get the blurred background to sort of "show through" as the divider between cells.
  for (NSIndexPath *indexPath in [scrollView_ indexPathsForVisibleRows]) {
    //Do something with your indexPath. Maybe you want to get your cell,
    // like this:
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    /*
    ComponentHeaderView *headerView = [scrollView_  viewWithTag:4892+indexPath.section];
   
    //CGRect headerRect = [scrollView_ convertRect:[scrollView_ rectForHeaderInSection:indexPath.section] toView:scrollView_];
    //headerView.blurredSnapshotView.layer.contentsRect = CGRectMake(0.0, (headerRect.origin.y) / scrollView_.frame.size.height, 1, 1);
    float contentOffset = 0;
    if(indexPath.section == 0){
   		contentOffset = 1 - (scrollView_.frame.size.height - scrollView_.contentOffset.y) / scrollView_.frame.size.height;
   	}
   	else{
   		contentOffset = 1 - ((scrollView_.frame.size.height + (headerView.frame.origin.y - scrollView_.contentOffset.y)) - (scrollView_.contentOffset.y)) / (scrollView_.frame.size.height + (headerView.frame.origin.y - scrollView_.contentOffset.y));
   	}
   	if(contentOffset > 1){
   		contentOffset = 1;
   	}
   	if(contentOffset < 0){
   		contentOffset = 0;
   	}

   	headerView.blurredSnapshotView.layer.contentsRect = CGRectMake(0.0, contentOffset, 1, 1);
    NSLog(@"HeaderRect %i is :%f Contents rect offset is :%f", indexPath.section, (scrollView_.contentOffset.y + (headerView.frame.origin.y - scrollView_.contentOffset.y)), contentOffset);
 	if(!self.hasSnapshot){
 	
    	self.hasSnapshot = TRUE;
     //[headerView createSnapshotOfView:scrollView_]; //Make this after the second section has loaded, hopefully this works?

 	}
 	*/
    ComponentEntryCell *cell = [scrollView_ cellForRowAtIndexPath:indexPath];
    CGRect rect = [scrollView_ convertRect:[scrollView_ rectForRowAtIndexPath:indexPath] toView:[scrollView_ superview]];
    cell.divider.layer.contentsRect = CGRectMake(0.0, (rect.origin.y + (cell.contentView.frame.size.height - 6.5))/ [scrollView_ superview].frame.size.height, 1, 1);
    cell.versionBlob.layer.contentsRect = CGRectMake(0.0, (rect.origin.y + (cell.contentView.frame.size.height - 6.5))/ [scrollView_ superview].frame.size.height, 1, 1);
     // if(debug) NSLog(@"Y is: %f", rect.origin.y / [componentsTableView superview].frame.size.height);
}
}

-(void)dealloc{
	[self.view release];
	[super dealloc];
}
@end