#import "ModuleInstallView.h"
#define KNORMAL  "\x1B[0m"
#define KRED  "\x1B[31m"
#define REDLog(fmt, ...) NSLog((@"%s" fmt @"%s"),KRED,##__VA_ARGS__,KNORMAL)
@implementation ModuleInstallView
-(id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if(self){ 
		hasUnderlay = FALSE;
		self.backgroundColor = [UIColor clearColor];
 animationLength = 0.8;
    animationDelay = 0.4;
    animationAlpha = 0.0;
    showingLogView = FALSE;

	blurredIconUnderlay = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, frame.size.width, frame.size.height)];
  	//blurredIconUnderlay.contentMode = UIViewContentModeTopLeft; 
   //	blurredIconUnderlay.clipsToBounds = YES;
	//blurredIconUnderlay.layer.masksToBounds = YES;
	//blurredIconUnderlay.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
	[self addSubview:blurredIconUnderlay];



    iconView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width / 2) - 75 , 40, 150, 150)];//[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, 25, 50, 30)];
   
    [self addSubview:iconView];


closeButton = [[UIButton alloc] init];
closeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];

closeButton.frame = CGRectMake((self.frame.size.width / 2) - 20, 0, 40, 25);

[closeButton setTitle:@"" forState:UIControlStateNormal];

[closeButton setBackgroundImage:[[UIImage imageNamed:@"ArrowDown.png"] tintedImageUsingColor:[UIColor whiteColor] alpha:1.0]
                            forState:UIControlStateNormal];


[closeButton addTarget:self action:@selector(closePressed:) forControlEvents:UIControlEventTouchUpInside];
closeButton.alpha = 0.0;
[self addSubview:closeButton];


    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake((self.frame.size.width / 2) - 120, self.frame.size.height - 50, 240, 40)];
    progressView.progress = 0.0f;
    [self addSubview:progressView];


    

restartButton = [[UIButton alloc] init];
restartButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
restartButton.alpha = 0.0;
restartButton.frame = CGRectMake((self.frame.size.width / 2) - 120, self.frame.size.height - 70, 240, 60);

 [restartButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"RESTART_BUTTON_LABEL", nil)] forState:UIControlStateNormal];
      
        //restartButton.clipsToBounds = YES;
        //restartButton.layer.cornerRadius = 10;
        //restartButton.layer.masksToBounds = YES;
        //restartButton.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);

[restartButton setBackgroundImage:[UIImage imageNamed:@"InstallButtonNormal"]
                            forState:UIControlStateNormal];

[restartButton setBackgroundImage:[UIImage imageNamed:@"InstallButtonPressed"]
                            forState:UIControlStateHighlighted];



[restartButton addTarget:self action:@selector(restartPressed:) forControlEvents:UIControlEventTouchUpInside]; 

[self addSubview:restartButton];



       progressLabel = [[UILabel alloc] init];
    progressLabel.frame = CGRectMake(0, self.frame.size.height - 240, self.frame.size.width, 40);
    progressLabel.alpha = 0.0;
    progressLabel.textColor = [UIColor whiteColor];
    progressLabel.backgroundColor = [UIColor clearColor];
    progressLabel.font = [UIFont boldSystemFontOfSize:16.0];
    progressLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:progressLabel];






hideLogButton = [[UIButton alloc] init];
hideLogButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
hideLogButton.alpha = 0.0;
hideLogButton.frame = CGRectMake(self.frame.size.width - 50, self.frame.size.height - 290, 40, 25);

[hideLogButton setTitle:nil forState:UIControlStateNormal];
[hideLogButton setBackgroundImage:[[UIImage imageNamed:@"ArrowDown"] tintedImageUsingColor:[UIColor whiteColor] alpha:1.0]
                            forState:UIControlStateNormal];
[hideLogButton setBackgroundImage:[[UIImage imageNamed:@"ArrowDown"] tintedImageUsingColor:[UIColor grayColor] alpha:1.0]
                            forState:UIControlStateHighlighted];

[hideLogButton addTarget:self action:@selector(installLogPressed:) forControlEvents:UIControlEventTouchUpInside];
hideLogButton.transform = CGAffineTransformMakeRotation(180 * M_PI / 180.0);
[self addSubview:hideLogButton];

showLogButton = [[UIButton alloc] init];
showLogButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
showLogButton.alpha = 0.0;
showLogButton.frame = CGRectMake((self.frame.size.width / 2) - 25, self.frame.size.height - 160, 50, 50);

[showLogButton setTitle:nil forState:UIControlStateNormal];
[showLogButton setBackgroundImage:[[UIImage imageNamed:@"Changelog_v7"] tintedImageUsingColor:[UIColor whiteColor] alpha:1.0]
                            forState:UIControlStateNormal];
[showLogButton setBackgroundImage:[[UIImage imageNamed:@"Changelog_v7"] tintedImageUsingColor:[UIColor grayColor] alpha:1.0]
                            forState:UIControlStateHighlighted];

[showLogButton addTarget:self action:@selector(installLogPressed:) forControlEvents:UIControlEventTouchUpInside];

[self addSubview:showLogButton];

    errorLabel = [[UILabel alloc] init];
    errorLabel.frame = CGRectMake(30, 12, 25, 25);
    errorLabel.alpha = 0.0;
    errorLabel.textColor = [UIColor whiteColor];
    errorLabel.backgroundColor = [UIColor redColor];
    errorLabel.font = [UIFont boldSystemFontOfSize:15.0];
    errorLabel.textAlignment = UITextAlignmentCenter;
    errorLabel.layer.cornerRadius = 5;
    errorLabel.layer.masksToBounds = YES;
    [showLogButton addSubview:errorLabel];



    installLogView = [[UITextView alloc] init];  
    installLogView.text = @"";
    installLogView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.50];//[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.30];
    installLogView.textColor = [UIColor whiteColor];
    installLogView.font = [UIFont italicSystemFontOfSize:14.0];
    installLogView.frame = CGRectMake(0, self.frame.size.height - 260, self.frame.size.width, 180);

    installLogView.editable = NO;
    installLogView.alpha = 0.0;

    [self addSubview:installLogView];


	}
	return self;

}


-(void)loadUp{
	iconView.image = self.iconImage;
	lastLogID = @"nothing";
	NSLog(@"Loaded up installView with image: %@", iconView.image);

	//blurredIconUnderlay.image = [self.iconImage fastBlurWithQuality:4 interpolation:4 blurRadius:15];

}

-(void)genUnderlay{
	if(!hasUnderlay){

	CGRect origRect = self.frame;
	self.frame = CGRectMake(origRect.size.width, 0, origRect.size.width, origRect.size.height);
	self.alpha = 1.0;
    closeButton.alpha = 0.0;
    restartButton.alpha = 0.0;
    installLogView.alpha = 0.0;
    progressLabel.alpha = 0.0f;
    showLogButton.alpha = 0.0;
	progressView.alpha = 0.0; //We only want to make one view visible now. That's the icon view. otherrwise the whole screen pulses underneath and that doesn't quite look as clean perhaps?
 	UIGraphicsBeginImageContext(self.superview.frame.size); //Maybe make this scaled down to do it quicker, but at less quality?

    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();

      blurredIconUnderlay.image = [screenShotimage fastBlurWithQuality:4 interpolation:4 blurRadius:15];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
      UIGraphicsEndImageContext();
   	//blurredIconUnderlay.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
   		self.alpha = 0.0;
   		progressView.alpha = 1.0;
   		self.frame = origRect;
   		hasUnderlay = TRUE;
	}
}




-(void)startAnimation{
	NSLog(@"Starting animation for installView!");
	//TODO/FIXME: Make this animation feel more organic.  Possibly heart-beat type animation or random length/delay within a certain degree at any rate so it's never too fast or too slow.
blurredIconUnderlay.alpha = 1.0;
closeButton.alpha = 0.0;
restartButton.alpha = 0.0;
progressView.alpha = 0.0;
showLogButton.alpha = 0.0;
progressLabel.alpha = 0.0f;
showingLogView = FALSE;
[blurredIconUnderlay.layer removeAllAnimations];
[UIView animateWithDuration:1.4
                      delay:0.8
                    options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                 animations:^{
                         blurredIconUnderlay.alpha = 0.5;
                 }
                 completion:^(BOOL fin) {
           
                 }];
}

-(void)startUpdates{
      progressLabel.text = NSLocalizedString(@"PROGRESS_LABEL_CHECKING_UPDATES", nil);        
    if(!progressLabel.alpha > 0.0 && !showingLogView){      
           [UIView animateWithDuration:0.3      
                              delay:0       
                            options:nil     
                         animations:^{      
                                 progressLabel.alpha = 1.0;     
                                 showLogButton.alpha = 1.0;     
                         }      
                         completion:^(BOOL fin) {       
                         }];        
       }
       
    [blurredIconUnderlay.layer removeAllAnimations];
        [UIView animateWithDuration:0.3
                      delay:0
                    options:nil
                 animations:^{
                         progressView.alpha = 1.0;
                 }
                 completion:^(BOOL fin) {
                 }];

        [UIView animateWithDuration:animationLength
                      delay:animationDelay
                    options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                 animations:^{
                         blurredIconUnderlay.alpha = animationAlpha;
                 }
                 completion:^(BOOL fin) {
           
                 }];
}

-(void)setAnimationWait:(float)wait length:(float)length alpha:(float)alpha{
    //animationLength = length;
    //animationDelay = wait;
    //animationAlpha = alpha;

}

-(void)stopAnimation{
	NSLog(@"Stopping animation for installView");
    shouldAnimate = FALSE;
	[blurredIconUnderlay.layer removeAllAnimations];
}

-(void)closePressed:(id)sender{
	[self.viewController installScreenRequestedClose];
}

-(void)restartPressed:(id)sender{
    [self.viewController restartPressed];
}

-(void)installLogPressed:(id)sender{
    [self showLogView:!showingLogView]; //Should always give the opposite of what it currently is?
}

-(void)clearScreen{
	progressView.progress = 0.0f;
	installLogView.alpha = 0.0f;
    restartButton.alpha = 0.0f;
    closeButton.alpha = 0.0f;
    progressLabel.alpha = 0.0f;
    hideLogButton.alpha = 0.0;
    showLogButton.alpha = 1.0;
    errorLabel.alpha = 0.0;
    errorLabel.text = @"";
[showLogButton setBackgroundImage:[[UIImage imageNamed:@"Changelog_v7"] tintedImageUsingColor:[UIColor whiteColor] alpha:1.0]
                            forState:UIControlStateNormal];
[showLogButton setBackgroundImage:[[UIImage imageNamed:@"Changelog_v7"] tintedImageUsingColor:[UIColor grayColor] alpha:1.0]
                            forState:UIControlStateHighlighted];
	installLogView.text = @"";
}


-(void)updatesCompleted{
    [UIView transitionWithView:progressLabel duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
     progressLabel.text = [NSString stringWithFormat:@"%@", NSLocalizedString(@"PROGRESS_VIEW_DONE_INSTALLING", nil)];
  } completion:nil];
        
                
	[UIView animateWithDuration:0.3
                      delay:0
                    options:nil
                 animations:^{
	                     closeButton.alpha = 1.0;
                         progressView.alpha = 0.0;
                         restartButton.alpha = 1.0;

                 }
                 completion:^(BOOL fin) {
                 }];

blurredIconUnderlay.alpha = 1.0;
[blurredIconUnderlay.layer removeAllAnimations];
[UIView animateWithDuration:1.4
                      delay:0.8
                    options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                 animations:^{
                         blurredIconUnderlay.alpha = 0.5;
                 }
                 completion:^(BOOL fin) {
           
                 }];

}

-(void)showLogView:(bool)show{
    if(show){
        if(!showingLogView){
            showingLogView = TRUE;
            installLogView.frame = CGRectMake(0, self.frame.size.height - 260, self.frame.size.width, 0);
            installLogView.alpha = 1.0;
            [UIView animateWithDuration:0.3
                              delay:0
                            options:nil
                         animations:^{
                                hideLogButton.alpha = 1.0;
                                showLogButton.alpha = 0.0;
                                progressLabel.alpha = 0.0f;
                                installLogView.frame = CGRectMake(0, self.frame.size.height - 260, self.frame.size.width, 180);
                         }
                         completion:^(BOOL fin) {
                         }];

        }
    }
    else{
        if(showingLogView){
            showingLogView = FALSE;
            //installLogView.frame = CGRectMake(0, self.frame.size.height - 260, self.frame.size.width, 0);
            [UIView animateWithDuration:0.3
                              delay:0
                            options:nil
                         animations:^{
                                hideLogButton.alpha = 0.0;
                                showLogButton.alpha = 1.0;
                                progressLabel.alpha = 1.0f;
                                installLogView.frame = CGRectMake(0, self.frame.size.height - 260, self.frame.size.width, 0);
                         }
                         completion:^(BOOL fin) {
                            installLogView.alpha = 0.0;
                         }];
        }
    }
}

-(void)handleLogMessage:(NSDictionary*)message{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
NSLog(@"ModuleInstallView handleLogMessage:%@", message);
NSString *logText = [NSString stringWithFormat:@"%@",installLogView.text];
 NSString *newProgressText = progressLabel.text; //Please work?
	if([message objectForKey:@"componentID"]){
           
    		if(![[message objectForKey:@"componentID"] isEqualToString:lastLogID]){
    			logText = [NSString stringWithFormat:@"%@\n\n-------------\n\n", logText];
    			logText = [NSString stringWithFormat:@"%@%@ (%@)\n",logText, [message objectForKey:@"componentName"], [message objectForKey:@"componentID"]];

    		}
    		if([[message objectForKey:@"notificationType"] isEqualToString:@"downloadStart"]){

                newProgressText = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"INSTALL_LOG_START_DOWNLOADING", nil), [message objectForKey:@"componentName"]];
            }
            if([[message objectForKey:@"notificationType"] isEqualToString:@"installStart"]){
                newProgressText = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"INSTALL_LOG_START_INSTALLING", nil), [message objectForKey:@"componentName"]];
            }
    		lastLogID = [[message objectForKey:@"componentID"] copy];
    	}
    	else{
    		if([message objectForKey:@"identifier"]){
    		if(![[message objectForKey:@"identifier"] isEqualToString:lastLogID]){
    			logText = [NSString stringWithFormat:@"%@\n\n-------------\n", logText];
    			logText = [NSString stringWithFormat:@"%@%@ (%@)\n",logText, [message objectForKey:@"displayName"], [message objectForKey:@"identifier"]];

    		
    		}
            if([[message objectForKey:@"notificationType"] isEqualToString:@"downloadStart"]){
                newProgressText = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"INSTALL_LOG_START_DOWNLOADING", nil), [message objectForKey:@"displayName"]];
            }
            if([[message objectForKey:@"notificationType"] isEqualToString:@"installStart"]){
                newProgressText = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"INSTALL_LOG_START_INSTALLING", nil), [message objectForKey:@"displayName"]];
            }
    		lastLogID = [[message objectForKey:@"identifier"] copy];
    		}
    	}
        [UIView transitionWithView:progressLabel duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            progressLabel.text = newProgressText;
        } completion:nil];

if(!progressLabel.alpha > 0.0 && !showingLogView){
           [UIView animateWithDuration:0.3
                              delay:0
                            options:nil
                         animations:^{
                                 progressLabel.alpha = 1.0;
                                 showLogButton.alpha = 1.0;
                         }
                         completion:^(BOOL fin) {
                         }];
       }
if([message objectForKey:@"notificationType"]){
	NSLog(@"Message has notification type");

if([[message objectForKey:@"notificationType"] isEqualToString:@"downloadStart"]){
    
    	logText = [NSString stringWithFormat:@"%@%@\n",logText, NSLocalizedString(@"INSTALL_LOG_START_DOWNLOADING", nil)];
    	
    	
            [UIView animateWithDuration:0.3
                      delay:0
                    options:nil
                 animations:^{
                        installLogView.text = logText;
                 }
                 completion:^(BOOL fin) {
                 }];
    	//installLogView.text = [NSString stringWithFormat:@"%@\n\n-------------\n", logText];

}

if([[message objectForKey:@"notificationType"] isEqualToString:@"downloadPass"]){
    
    	logText = [NSString stringWithFormat:@"%@%@\n",logText, NSLocalizedString(@"INSTALL_LOG_PASS_DOWNLOADING", nil)];
    
    	         [UIView animateWithDuration:0.3
                      delay:0
                    options:nil
                 animations:^{
                        installLogView.text = logText;
                 }
                 completion:^(BOOL fin) {
                 }];
    	//installLogView.text = [NSString stringWithFormat:@"%@\n\n-------------\n", logText];
    	//FIXME: do something when the file downloads here... Maybe something on the progressview so it includes download times too?
}

    if([[message objectForKey:@"notificationType"] isEqualToString:@"downloadError"]){
    
    	logText = [NSString stringWithFormat:@"%@%@\n",logText, NSLocalizedString(@"INSTALL_LOG_ERROR_DOWNLOADING", nil)];
    	[showLogButton setBackgroundImage:[[UIImage imageNamed:@"Changelog_v7"] tintedImageUsingColor:[UIColor redColor] alpha:1.0]
                            forState:UIControlStateNormal];
        [showLogButton setBackgroundImage:[[UIImage imageNamed:@"Changelog_v7"] tintedImageUsingColor:[UIColor orangeColor] alpha:1.0]
                            forState:UIControlStateHighlighted];
    	         [UIView animateWithDuration:0.3
                      delay:0
                    options:nil
                 animations:^{
                        installLogView.text = logText;
                        errorLabel.alpha = 1.0;
                 }
                 completion:^(BOOL fin) {
                 }];
    	//installLogView.text = [NSString stringWithFormat:@"%@\n\n-------------\n", logText];
    	//self.updatesToInstall--;
    	self.failedUpdates++;
        [UIView transitionWithView:errorLabel duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            errorLabel.text = [NSString stringWithFormat:@"%i", self.failedUpdates];
        } completion:nil];
    	//self.installedUpdates++;
    	[self updateProgress];

    }


if([[message objectForKey:@"notificationType"] isEqualToString:@"installStart"]){
    
    	logText = [NSString stringWithFormat:@"%@%@\n",logText, NSLocalizedString(@"INSTALL_LOG_START_INSTALLING", nil)];
    	
	             [UIView animateWithDuration:0.3
                      delay:0
                    options:nil
                 animations:^{
                        installLogView.text = logText;
                 }
                 completion:^(BOOL fin) {
                 }];
    	//installLogView.text = [NSString stringWithFormat:@"%@\n\n-------------\n", logText];

}

if([[message objectForKey:@"notificationType"] isEqualToString:@"installPass"]){
    
    	logText = [NSString stringWithFormat:@"%@%@\n",logText, NSLocalizedString(@"INSTALL_LOG_PASS_INSTALLING", nil)];
    	
    	         [UIView animateWithDuration:0.3
                      delay:0
                    options:nil
                 animations:^{
                        installLogView.text = logText;
                 }
                 completion:^(BOOL fin) {
                 }];
    	//installLogView.text = [NSString stringWithFormat:@"%@\n\n-------------\n", logText];
    	//self.updatesToInstall--;
    	//self.failedUpdates++;
    	self.installedUpdates++;
    	[self updateProgress];
}

    if([[message objectForKey:@"notificationType"] isEqualToString:@"installError"]){
    
    	logText = [NSString stringWithFormat:@"%@%@\n",logText, NSLocalizedString(@"INSTALL_LOG_ERROR_INSTALLING", nil)];
    	[showLogButton setBackgroundImage:[[UIImage imageNamed:@"Changelog_v7"] tintedImageUsingColor:[UIColor redColor] alpha:1.0]
                            forState:UIControlStateNormal];
        [showLogButton setBackgroundImage:[[UIImage imageNamed:@"Changelog_v7"] tintedImageUsingColor:[UIColor orangeColor] alpha:1.0]
                            forState:UIControlStateHighlighted];
    	         [UIView animateWithDuration:0.3
                      delay:0
                    options:nil
                 animations:^{
                        installLogView.text = logText;
                        errorLabel.alpha = 1.0;
                 }
                 completion:^(BOOL fin) {
                 }];
    	//self.updatesToInstall--;
    	self.failedUpdates++;
        [UIView transitionWithView:errorLabel duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            errorLabel.text = [NSString stringWithFormat:@"%i", self.failedUpdates];
        } completion:nil];
    	//self.installedUpdates++;
    	[self updateProgress];

    }

    if(installLogView.text.length > 0){
    NSRange range = NSMakeRange(installLogView.text.length - 1, 1);
  [installLogView scrollRangeToVisible:range];
            
}
}
[pool drain];
}

-(void)updateProgress{
	float currentProgress = [progressView progress];
    int currentFinished = self.installedUpdates + self.failedUpdates;
    float newProgress = (float)currentFinished/(float)self.updatesToInstall;

	REDLog(@"Updates to install: %i, installedUpdates: %i, failedUpdates: %i, currentProgress: %f, newProgress is: %f, progress is: %i", self.updatesToInstall, self.installedUpdates, self.failedUpdates, currentProgress, newProgress, currentFinished);
    NSLog(@"NEWPROGRESSIS: %f", newProgress);
      //  if (currentProgress < 1) {
            progressView.progress = newProgress;
       // }

}

@end