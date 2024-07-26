#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "UIImage+LiveBlur.h"

@class ModuleViewController;
@interface ModuleInstallView : UIView{
	UIImageView *iconView;
	UIImageView *blurredIconUnderlay;
	UITextView *installLogView;
	UIProgressView *progressView; //Divide total to install by this number
	UIButton *closeButton; //Top right or something.
	UIButton *restartButton; //Bottom center after install is done
	UIButton *showLogButton;
	UIButton *hideLogButton;
	UIButton *logButton;
	UILabel *progressLabel;
	UILabel *errorLabel;
	NSString *lastLogID;
	bool showingLog;
	bool hasUnderlay;
	bool shouldAnimate;
	float animationLength;
	float animationDelay;
	float animationAlpha;
	bool showingLogView;
}

@property (nonatomic, assign) int updatesToInstall;
@property (nonatomic, assign) int installedUpdates;
@property (nonatomic, assign) int failedUpdates;
@property (nonatomic, assign) ModuleViewController *viewController;
@property (nonatomic, assign) UIImage *iconImage;

-(void)loadUp;
-(void)startAnimation;
-(void)stopAnimation;
-(void)closePressed:(id)sender;
-(void)clearScreen;
-(void)restartPressed:(id)sender;
-(void)updatesCompleted;
-(void)handleLogMessage:(NSDictionary*)message;


@end