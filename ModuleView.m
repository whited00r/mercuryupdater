#import "ModuleView.h"

#define useStaticBackground TRUE
@implementation ModuleView
//@synthesize viewController;

-(id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if(self){ 

		hasSnapshot = FALSE;
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = TRUE;
		CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
		screenHeight = screenFrame.size.height;
		screenWidth = screenFrame.size.width;

		self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,screenWidth, screenHeight)];
		self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
		[self addSubview:self.contentView];

		backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		backgroundImage.image = [self blurredBackgroundImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
    	backgroundImage.contentMode = UIViewContentModeTopLeft; 
    	backgroundImage.backgroundColor = [UIColor clearColor];
    	backgroundImage.clipsToBounds = YES;
    	//self.iconDivider.layer.cornerRadius = 10;
    	backgroundImage.layer.masksToBounds = YES;
    	backgroundImage.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
    	backgroundImage.alpha = 0.3;
    	[self.contentView addSubview:backgroundImage];

    UIImageView *bottomUnderlay = [[UIImageView alloc] initWithFrame:CGRectMake(0,screenHeight - 60, screenWidth, 60)];
    bottomUnderlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [self.contentView addSubview:bottomUnderlay];
    [bottomUnderlay release];


   self.lastUpdateCheckLabel = [[UILabel alloc] init];
    self.lastUpdateCheckLabel.frame = CGRectMake((screenWidth / 2) - 100, screenHeight - 55, 200, 50);
    self.lastUpdateCheckLabel.alpha = 1;
    self.lastUpdateCheckLabel.textColor = [UIColor whiteColor];
    self.lastUpdateCheckLabel.backgroundColor = [UIColor clearColor];
    self.lastUpdateCheckLabel.textAlignment = UITextAlignmentCenter;
  NSString *lastUpdateCheckLabelString = NSLocalizedString(@"UPDATE_LAST_CHECKED_NEVER", nil);
   // lastUpdateCheckLabelString = [NSString stringWithFormat: lastUpdateCheckLabelString, , [self.onlineDict objectForKey:@"versionCodeName"]];
    
    self.lastUpdateCheckLabel.text = lastUpdateCheckLabelString;
    self.lastUpdateCheckLabel.font = [UIFont italicSystemFontOfSize:16.0];
    [self.contentView addSubview:self.lastUpdateCheckLabel];


self.closeButton = [[UIButton alloc] init];
self.closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];

self.closeButton.frame = CGRectMake((screenWidth / 2) - 20, 0, 40, 25);

[self.closeButton setTitle:@"" forState:UIControlStateNormal];

[self.closeButton setBackgroundImage:[[UIImage imageNamed:@"ArrowDown.png"] tintedImageUsingColor:[UIColor whiteColor] alpha:1.0]
                            forState:UIControlStateNormal];


[self.closeButton addTarget:self action:@selector(closePressed:) forControlEvents:UIControlEventTouchUpInside];

[self.contentView addSubview:self.closeButton];


self.installUpdatesButton = [[UIButton alloc] init];
self.installUpdatesButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];

self.installUpdatesButton.frame = CGRectMake((screenWidth / 2) - 100, screenHeight - 155, 200, 50);

[self.installUpdatesButton setTitle:@"Install" forState:UIControlStateNormal];
    	//self.installUpdatesButton.clipsToBounds = YES;
    	//self.installUpdatesButton.layer.cornerRadius = 10;
    	//self.installUpdatesButton.layer.masksToBounds = YES;
    	//self.installUpdatesButton.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);

[self.installUpdatesButton setBackgroundImage:[UIImage imageNamed:@"InstallButtonNormal"]
                            forState:UIControlStateNormal];

[self.installUpdatesButton setBackgroundImage:[UIImage imageNamed:@"InstallButtonPressed"]
                            forState:UIControlStateHighlighted];



[self.installUpdatesButton addTarget:self action:@selector(installPressed:) forControlEvents:UIControlEventTouchUpInside]; 

[self.contentView addSubview:self.installUpdatesButton];


self.refreshButton = [[UIButton alloc] init];
self.refreshButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];

self.refreshButton.frame = CGRectMake(self.lastUpdateCheckLabel.frame.origin.x - 50, screenHeight - 50, 40, 40);

[self.refreshButton setTitle:nil forState:UIControlStateNormal];
[self.refreshButton setBackgroundImage:[[UIImage imageNamed:@"Refresh"] tintedImageUsingColor:[UIColor whiteColor] alpha:1.0]
                            forState:UIControlStateNormal];
[self.refreshButton setBackgroundImage:[[UIImage imageNamed:@"Refresh"] tintedImageUsingColor:[UIColor grayColor] alpha:1.0]
                            forState:UIControlStateHighlighted];
[self.refreshButton addTarget:self action:@selector(refreshPressedDown:) forControlEvents:UIControlEventTouchDown];
[self.refreshButton addTarget:self action:@selector(refreshReleased:) forControlEvents:UIControlEventTouchDragOutside];
[self.refreshButton addTarget:self action:@selector(refreshPressed:) forControlEvents:UIControlEventTouchUpInside];

[self.contentView addSubview:self.refreshButton];




self.componentsButton = [[UIButton alloc] init];
self.componentsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];

self.componentsButton.frame = CGRectMake(self.lastUpdateCheckLabel.frame.origin.x + self.lastUpdateCheckLabel.frame.size.width + 10, screenHeight - 50, 40, 40);

[self.componentsButton setTitle:nil forState:UIControlStateNormal];
[self.componentsButton setBackgroundImage:[[UIImage imageNamed:@"Components"] tintedImageUsingColor:[UIColor whiteColor] alpha:1.0]
                            forState:UIControlStateNormal];
[self.componentsButton setBackgroundImage:[[UIImage imageNamed:@"Components"] tintedImageUsingColor:[UIColor grayColor] alpha:1.0]
                            forState:UIControlStateHighlighted];
[self.componentsButton addTarget:self action:@selector(componentsPressedDown:) forControlEvents:UIControlEventTouchDown];
[self.componentsButton addTarget:self action:@selector(componentsReleased:) forControlEvents:UIControlEventTouchDragOutside];
[self.componentsButton addTarget:self action:@selector(componentsPressed:) forControlEvents:UIControlEventTouchUpInside];

[self.contentView addSubview:self.componentsButton];


self.changelogButton = [[UIButton alloc] init];
self.changelogButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];

self.changelogButton.frame = CGRectMake(screenWidth - 30, 120, 25, 25);

[self.changelogButton setTitle:nil forState:UIControlStateNormal];
[self.changelogButton setBackgroundImage:[[UIImage imageNamed:@"Changelog_v7"] tintedImageUsingColor:[UIColor whiteColor] alpha:1.0]
                            forState:UIControlStateNormal];
[self.changelogButton setBackgroundImage:[[UIImage imageNamed:@"Changelog_v7"] tintedImageUsingColor:[UIColor grayColor] alpha:1.0]
                            forState:UIControlStateHighlighted];
[self.changelogButton addTarget:self action:@selector(changelogPressedDown:) forControlEvents:UIControlEventTouchDown];
[self.changelogButton addTarget:self action:@selector(changelogReleased:) forControlEvents:UIControlEventTouchDragOutside];
[self.changelogButton addTarget:self action:@selector(changelogPressed:) forControlEvents:UIControlEventTouchUpInside];

[self.contentView addSubview:self.changelogButton];



	   self.moduleName = [[UILabel alloc] init];
    self.moduleName.frame = CGRectMake(70,20,screenWidth - 70, 40);
    self.moduleName.alpha = 0.9;
    self.moduleName.textColor = [UIColor whiteColor];
    self.moduleName.backgroundColor = [UIColor clearColor];
    self.moduleName.font = [UIFont boldSystemFontOfSize:28.0];
    self.moduleName.textAlignment = UITextAlignmentLeft;
    [self.contentView addSubview:self.moduleName];


    self.versionBlob = [[UIImageView alloc] initWithFrame:CGRectMake(60, 35, screenWidth - 80, 30)];//[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, 25, 50, 30)];
   
    self.versionBlob.image = [self blurredBackgroundImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
    self.versionBlob.contentMode = UIViewContentModeTopLeft; 
    self.versionBlob.clipsToBounds = YES;
    self.versionBlob.layer.cornerRadius = 10;
    self.versionBlob.layer.masksToBounds = YES;
    self.versionBlob.alpha = 0.0;
    self.versionBlob.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
    [self.contentView addSubview:self.versionBlob];

    self.moduleVersion = [[UILabel alloc] init];
    self.moduleVersion.alpha = 0.9;
    self.moduleVersion.frame = CGRectMake(75, 50, screenWidth - 70, 30);
    self.moduleVersion.textColor = [UIColor whiteColor];
    self.moduleVersion.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0]; //Why not clearColor? Too lazy to change it back if I decide I want something below it.
    self.moduleVersion.layer.cornerRadius = 10;
    self.moduleVersion.layer.masksToBounds = YES;
    self.moduleVersion.font = [UIFont italicSystemFontOfSize:14.0];
    self.moduleVersion.textAlignment = UITextAlignmentLeft;

    [self.contentView addSubview:self.moduleVersion];
 
    self.iconDivider = [[UIImageView alloc] initWithFrame:CGRectMake(60, 20, 5, 55)]; //This is the actual icon underlay
    self.iconDivider.image = [self blurredBackgroundImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
    self.iconDivider.contentMode = UIViewContentModeTopLeft; 
    self.iconDivider.clipsToBounds = YES;
    //self.iconDivider.layer.cornerRadius = 10;
    self.iconDivider.layer.masksToBounds = YES;
    self.iconDivider.alpha = 0.6;
    self.iconDivider.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
    [self.contentView addSubview:self.iconDivider];


  
   

    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 40, 40)];
   
   // self.icon.image = [self iconImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
    //self.icon.clipsToBounds = YES;
    //self.icon.layer.cornerRadius = 10;
    [self.contentView addSubview:self.icon];

    self.updateNameLabel = [[UILabel alloc] init];
    self.updateNameLabel.frame = CGRectMake(0,80,screenWidth, 30);
    self.updateNameLabel.alpha = 1;
    self.updateNameLabel.textColor = [UIColor whiteColor];
    self.updateNameLabel.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.50];
    self.updateNameLabel.textAlignment = UITextAlignmentCenter;
    self.updateNameLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [self.contentView addSubview:self.updateNameLabel];


 


    self.divider = [[UIImageView alloc] initWithFrame:CGRectMake(0,80, screenWidth, 0.5)];
    self.divider.image = [self blurredBackgroundImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:200.0f green:200.0f blue:200.0f alpha:0.6f] alpha:0.9];
    self.divider.contentMode = UIViewContentModeTopLeft; 
    self.divider.clipsToBounds = YES;
    self.divider.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
    [self.contentView addSubview:self.divider];

    self.changeDescView = [[UITextView alloc] init];  
    self.changeDescView.text = @"Nothing to see here... :)";
    self.changeDescView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.30];
    self.changeDescView.textColor = [UIColor whiteColor];
    self.changeDescView.font = [UIFont italicSystemFontOfSize:14.0];
    self.changeDescView.frame = CGRectMake(0, 110, screenWidth - 40, screenHeight - 370);

    self.changeDescView.editable = NO;

    [self.contentView addSubview:self.changeDescView];
  

	  componentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, screenHeight - 260, screenWidth, (screenHeight - (screenHeight - 200)))];
  	componentsTableView.backgroundColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.0f];
    componentsTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    componentsTableView.dataSource = self.viewController;
    componentsTableView.delegate = self.viewController;
    componentsTableView.alpha = 0.0;
    [componentsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   	[componentsTableView reloadData];

    [self.contentView addSubview:componentsTableView];
    showingComponents = FALSE;



    UIImageView *bottomDividerUnderlay = [[UIImageView alloc] initWithFrame:CGRectMake(0,screenHeight - 60, screenWidth, 0.5)];
    bottomDividerUnderlay.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottomDividerUnderlay];
    [bottomDividerUnderlay release];

    UIImageView *bottomDividerView = [[UIImageView alloc] initWithFrame:CGRectMake(0,screenHeight - 60, screenWidth, 0.5)];
    bottomDividerView.image = [self blurredBackgroundImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:200.0f green:200.0f blue:200.0f alpha:0.6f] alpha:0.9];
    bottomDividerView.contentMode = UIViewContentModeTopLeft; 
    bottomDividerView.clipsToBounds = YES;
    bottomDividerView.alpha = 0.8;
    bottomDividerView.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
    [self.contentView addSubview:bottomDividerView];
    [bottomDividerView release];

		
    self.blurredSnapshotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
		//self.blurredSnapshotView.image = [self blurredBackgroundImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
    	//self.blurredSnapshotView.contentMode = UIViewContentModeTopLeft; 
    	self.blurredSnapshotView.backgroundColor = [UIColor clearColor];
    	self.blurredSnapshotView.clipsToBounds = YES;
    	//self.iconDivider.layer.cornerRadius = 10;
    	self.blurredSnapshotView.layer.masksToBounds = YES;
    	//self.blurredSnapshotView.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
    	self.blurredSnapshotView.alpha = 0.0;
    	self.blurredSnapshotView.userInteractionEnabled = FALSE;
    	[self addSubview:self.blurredSnapshotView];


      self.installView = [[ModuleInstallView alloc] initWithFrame:CGRectMake(0,0,screenWidth,screenHeight)];
      self.installView.alpha = 0;
      self.installView.viewController = self.viewController;

      [self addSubview:self.installView];

	}
	return self;
}

-(void)viewDidLoad{
	NSLog(@"Module view didLoad");
		//[componentsTableView reloadData];

}

-(void)loadUp{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	    componentsTableView.dataSource = self.viewController;
    componentsTableView.delegate = self.viewController;
	[componentsTableView reloadData];
	//self.backgroundColor = [UIColor greenColor];
	NSLog(@"ModuleView laying out subviews");
	self.moduleName.text = [self.moduleDict objectForKey:@"displayName"];
    if([self.moduleDict objectForKey:@"versionCodeName"]){
    
        self.moduleVersion.text = [NSString stringWithFormat:@"v%@ - %@", [self.moduleDict objectForKey:@"version"], [self.moduleDict objectForKey:@"versionCodeName"]];
    
    }
    else{
	   self.moduleVersion.text = [NSString stringWithFormat:@"v%@",[self.moduleDict objectForKey:@"version"]];
    }

	self.icon.image = [self iconImage];
    self.installView.viewController = self.viewController;
    self.installView.iconImage = [self iconImage];
  

	NSString *myString = NSLocalizedString(@"INSTALL_BUTTON_LABEL", nil);
myString = [NSString stringWithFormat: myString, [self.moduleDict objectForKey:@"updatesAvailable"]];
NSLog(@"String is :%@", myString);
if([self.onlineDict objectForKey:@"description"]){
  self.changeDescView.text = [self.onlineDict objectForKey:@"description"];
  }

if(self.onlineDict){ //This should exist if it is even there?
  if([self.onlineDict objectForKey:@"versionCodeName"]){
    NSString *codeNamelabelString = NSLocalizedString(@"UPDATE_LABEL_WITH_CODE_NAME", nil);
    codeNamelabelString = [NSString stringWithFormat: codeNamelabelString, [self.onlineDict objectForKey:@"version"], [self.onlineDict objectForKey:@"versionCodeName"]];
    self.updateNameLabel.text = codeNamelabelString;
  }
  else{
    NSString *updateLabelString = NSLocalizedString(@"UPDATE_LABEL", nil);
    updateLabelString = [NSString stringWithFormat: updateLabelString, [self.onlineDict objectForKey:@"version"]];
    self.updateNameLabel.text = updateLabelString;
  }
  if([self.onlineDict objectForKey:@"lastChecked"]){
      NSString *lastUpdateCheckLabelString = NSLocalizedString(@"UPDATE_LAST_CHECKED", nil);
      lastUpdateCheckLabelString = [NSString stringWithFormat:lastUpdateCheckLabelString, [self.onlineDict objectForKey:@"lastChecked"]];
      self.lastUpdateCheckLabel.numberOfLines = 2;
      self.lastUpdateCheckLabel.text = lastUpdateCheckLabelString;
  }
}



      if([[self.moduleDict objectForKey:@"updatesAvailable"] intValue] > 0){
         //self.moduleVersion.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:130.0f alpha:0.40];
         self.updateNameLabel.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.25f alpha:0.90];
         self.installUpdatesButton.alpha = 1.0;
         self.installView.updatesToInstall = [[self.moduleDict objectForKey:@"updatesAvailable"] intValue];
         self.installView.installedUpdates = 0;
         self.installView.failedUpdates = 0;
         if(self.installView.updatesToInstall > 1){
         [self.installUpdatesButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"INSTALL_BUTTON_LABEL", nil), [self.moduleDict objectForKey:@"updatesAvailable"]] forState:UIControlStateNormal];
        }
        else{
            [self.installUpdatesButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"1INSTALL_BUTTON_LABEL", nil), [self.moduleDict objectForKey:@"updatesAvailable"]] forState:UIControlStateNormal];
        }
      }
      else{
        self.updateNameLabel.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.50];
         //self.moduleVersion.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.20];
         self.installUpdatesButton.alpha = 0.0;
      }
  [self.installView loadUp];
[pool drain];
     // [self createSnapshot];
}


-(void)closePressed:(id)sender{
	//hasSnapshot = FALSE;
	[self.viewController closePressed];
}

-(void)changelogPressedDown:(UIButton*)sender{
  //hasSnapshot = FALSE;

  if(![self.changelogButton showingToolTip]){
    //[self.changelogButton pregenToolTipForText:@"Changelog" liveBlur:false];
    //[self.changelogButton setToolTipYOffset:0]; //These are kind of broken I think... Anyway I put code in now in the actual loading up method to calculate where it should be to at the very least stay on screen always.
    //[self.changelogButton setToolTipXOffset:0];
    //[self.changelogButton showToolTip];
  }
 // [self.viewController changelogPressed];
}

-(void)changelogReleased:(UIButton*)sender{
  //hasSnapshot = FALSE;

  if([self.changelogButton showingToolTip]){
     //[self.changelogButton performSelector:@selector(hideToolTip) withObject:nil afterDelay:1.5];
  }
 // [self.viewController changelogPressed];
}

-(void)changelogPressed:(UIButton*)sender{
  //hasSnapshot = FALSE;

  if([self.changelogButton showingToolTip]){
     //[self.changelogButton performSelector:@selector(hideToolTip) withObject:nil afterDelay:1.5];
  }
  [self.viewController changelogPressed];
}



-(void)refreshPressedDown:(UIButton*)sender{
  //hasSnapshot = FALSE;

  if(![self.refreshButton showingToolTip]){
    //[self.refreshButton pregenToolTipForText:@"Refresh" liveBlur:false];
    //[self.refreshButton showToolTip];
  }
 // [self.viewController changelogPressed];
}

-(void)refreshReleased:(UIButton*)sender{
  //hasSnapshot = FALSE;

  if([self.refreshButton showingToolTip]){
     //[self.refreshButton performSelector:@selector(hideToolTip) withObject:nil afterDelay:1.5];
  }
 // [self.viewController changelogPressed];
}

-(void)refreshPressed:(UIButton*)sender{
  //hasSnapshot = FALSE;

  if([self.refreshButton showingToolTip]){
    // [self.refreshButton performSelector:@selector(hideToolTip) withObject:nil afterDelay:1.5];
  }
  [self.viewController refreshPressed];
}


-(void)componentsPressedDown:(UIButton*)sender{
  //hasSnapshot = FALSE;

  if(![self.componentsButton showingToolTip]){
   // [self.componentsButton pregenToolTipForText:@"Components" liveBlur:false];
   // [self.componentsButton showToolTip];
  }
 // [self.viewController changelogPressed];
}

-(void)componentsReleased:(UIButton*)sender{
  //hasSnapshot = FALSE;

  if([self.componentsButton showingToolTip]){
     //[self.componentsButton performSelector:@selector(hideToolTip) withObject:nil afterDelay:1.5];
  }
 // [self.viewController changelogPressed];
}

-(void)componentsPressed:(UIButton*)sender{
  //hasSnapshot = FALSE;

  if([self.componentsButton showingToolTip]){
     //[self.componentsButton performSelector:@selector(hideToolTip) withObject:nil afterDelay:1.5];
  }

  if(!showingComponents){
    [UIView animateWithDuration:0.4
                delay:0.0
                options:UIViewAnimationCurveEaseIn
                animations:^{
              componentsTableView.alpha = 1.0;
              if([[self.moduleDict objectForKey:@"updatesAvailable"] intValue] > 0){
                self.installUpdatesButton.alpha = 0.0;
              }
              [self.componentsButton setBackgroundImage:[[UIImage imageNamed:@"Components"] tintedImageUsingColor:[UIColor grayColor] alpha:1.0]
                            forState:UIControlStateNormal];
[self.componentsButton setBackgroundImage:[[UIImage imageNamed:@"Components"] tintedImageUsingColor:[UIColor whiteColor] alpha:1.0]
                            forState:UIControlStateHighlighted];
              }
              completion:^(BOOL finished){
                showingComponents = TRUE;
              }];
  }
  else{

    [UIView animateWithDuration:0.4
                delay:0.0
                options:UIViewAnimationCurveEaseIn
                animations:^{
              componentsTableView.alpha = 0.0;
              if([[self.moduleDict objectForKey:@"updatesAvailable"] intValue] > 0){
                self.installUpdatesButton.alpha = 1.0;
              }
[self.componentsButton setBackgroundImage:[[UIImage imageNamed:@"Components"] tintedImageUsingColor:[UIColor whiteColor] alpha:1.0]
                            forState:UIControlStateNormal];
[self.componentsButton setBackgroundImage:[[UIImage imageNamed:@"Components"] tintedImageUsingColor:[UIColor grayColor] alpha:1.0]
                            forState:UIControlStateHighlighted];
              }
              completion:^(BOOL finished){
                showingComponents = FALSE;
              }];
  
  }
  

}




-(void)installPressed:(id)sender{
	hasSnapshot = FALSE;
	[self.viewController installPressed];
}


-(void)showInstallScreen{
 self.blurredSnapshotView.userInteractionEnabled = TRUE;

  [self.installView clearScreen];
  [self.installView startAnimation];

       [UIView animateWithDuration:0.25
                delay:0.0
                options:UIViewAnimationCurveEaseIn
                animations:^{
                self.blurredSnapshotView.alpha = 1.0;

               // moduleView.blurredSnapshotView.transform=CGAffineTransformMakeScale(1.2, 1.2);
             }
              completion:nil];
[UIView animateWithDuration:0.25
                delay:0.1
                options:UIViewAnimationCurveEaseIn
                animations:^{
                self.blurredSnapshotView.transform=CGAffineTransformMakeScale(1.2, 1.2);
                self.installView.alpha = 1.0;
             }
              completion:nil];
}


-(void)hideInstallScreen{
  [self.installView stopAnimation];

  [UIView animateWithDuration:0.4
                delay:0.1
                options:UIViewAnimationCurveEaseIn
                animations:^{
                self.blurredSnapshotView.alpha = 0.0;
              
               // moduleView.blurredSnapshotView.transform=CGAffineTransformMakeScale(1.2, 1.2);
             }
              completion:nil];
[UIView animateWithDuration:0.25
                delay:0.0
                options:UIViewAnimationCurveEaseIn
                animations:^{
                self.blurredSnapshotView.transform=CGAffineTransformMakeScale(1.0, 1.0);
                self.installView.alpha = 0.0;
             }
              completion:^(BOOL finished){
                  [self.installView clearScreen];
              }];

         self.blurredSnapshotView.userInteractionEnabled = FALSE;
}

-(bool)createSnapshot{
	if(!hasSnapshot){
	self.frame = CGRectMake([[UIScreen mainScreen] applicationFrame].size.width, 0,self.frame.size.width, [[UIScreen mainScreen] applicationFrame].size.height);
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
   	self.alpha = 1.0;
   	//(Step 3 includes all subviews)
   	self.contentView.alpha = 1.0;
   	self.closeButton.alpha = 1.0;

   	//Step 4: Create the snapshot of the view. It should know what to do with it.
	UIGraphicsBeginImageContext(self.frame.size); //Maybe make this scaled down to do it quicker, but at less quality?
//Set it to visible
[self.layer renderInContext:UIGraphicsGetCurrentContext()];
UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();

    self.blurredSnapshotImage = [screenShotimage fastBlurWithQuality:4 interpolation:4 blurRadius:15];
    self.blurredSnapshotView.alpha = 0.0;
    self.blurredSnapshotView.image = self.blurredSnapshotImage;
 
    NSLog(@"Snapshot image is :%@" , screenShotimage);
    UIGraphicsEndImageContext();

   	//Step 5: Hide the contentView and other views we need to hide
   	self.contentView.alpha = 0.0;
	self.alpha = 0.0;
	//Step 6: Make the snapshot view visible, and the frame back on-screen.  (but the whole view containing the snapshot and everything else isn't visible right now)
	self.blurredSnapshotView.alpha = 1.0;
	self.frame = CGRectMake(0, 0,self.frame.size.width, [[UIScreen mainScreen] applicationFrame].size.height);
	
   	
   	self.closeButton.alpha = 1.0;
   	hasSnapshot = TRUE;
}
    
    return true;
}

-(void)layoutSubviews{
	

	[super layoutSubviews];
    self.divider.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
    self.iconDivider.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
    [self.installView genUnderlay];
	
}


-(UIImage*)iconImage{
    //bool exists = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/Icons/%@.png", self.moduleID]];
    NSFileManager *fileManager= [NSFileManager defaultManager];
   // NSLog(@"Checking %@\nfor image for %@", [fileManager contentsOfDirectoryAtPath:@"/var/mobile/Library/Mercury/Icons" error:nil], [NSString stringWithFormat:@"/var/mobile/Library/Mercury/Icons/%@.png", self.moduleID]);
if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/Icons/%@.png", [self.moduleDict objectForKey:@"identifier"]]]){
    //NSLog(@"Found!");
  return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/Icons/%@.png", [self.moduleDict objectForKey:@"identifier"]]]; //Flags?
}
else{
    //NSLog(@"Not found :('%@'",[NSString stringWithFormat:@"/var/mobile/Library/Mercury/Icons/%@.png", self.moduleID]);
  return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Applications/MercuryUpdater.app/icon.png"]]; //Flags?
}
}

-(UIImage *)blurredBackgroundImage{
    if(useStaticBackground){
      if(screenWidth > 400){
        return [UIImage imageNamed:@"iPad_Background.png"];
      }
      else{
        return [UIImage imageNamed:@"iPod_Background.png"];
      }
  }
if([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/SpringBoard/HomeBackgroundBlurred.png"]){
  return [UIImage imageWithContentsOfFile:@"/var/mobile/Library/SpringBoard/HomeBackgroundBlurred.png"]; //Flags?
}
else{
  return [self backgroundImage]; //Flags?
}
}

-(UIImage *)backgroundImage{
if([[NSFileManager defaultManager] fileExistsAtPath:@"/var/mobile/Library/SpringBoard/HomeBackground.cpbitmap"]){
    return [UIImage imageWithContentsOfCPBitmapFile:@"/var/mobile/Library/SpringBoard/HomeBackground.cpbitmap" flags:nil]; //Flags?
}
else{
    return [UIImage imageWithContentsOfCPBitmapFile:@"/var/mobile/Library/SpringBoard/LockBackground.cpbitmap" flags:nil]; //Flags?
}
}

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {

    CGImageRef maskRef = maskImage.CGImage; 

    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
        CGImageGetHeight(maskRef),
        CGImageGetBitsPerComponent(maskRef),
        CGImageGetBitsPerPixel(maskRef),
        CGImageGetBytesPerRow(maskRef),
        CGImageGetDataProvider(maskRef), NULL, false);

    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];

    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);

    // returns new image with mask applied
    return maskedImage;
}


-(void)dealloc{
	[self.contentView release];
  [self.changeDescView release];
	[super dealloc];
}
@end