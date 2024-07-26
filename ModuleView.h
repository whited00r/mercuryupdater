/*
ModuleView.h

*/

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "UIImage+LiveBlur.h"
#import "ModuleInstallView.h"


@class ModuleViewController; //Ahhhh... Class can be used instead of #import when there are circular dependancies. Makes sense now I guess. 
@interface ModuleView : UIView{
	//id <UIViewController> viewController;
	UIImageView *backgroundImage;
	ModuleViewController *_viewController;
	UITableView *componentsTableView;
	bool hasSnapshot;
	bool showingComponents;
	float screenWidth;
	float screenHeight;
}

@property (nonatomic, assign) ModuleViewController *viewController;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) ModuleInstallView *installView;
@property (strong, nonatomic) UILabel* moduleName;
@property (strong, nonatomic) UILabel* moduleVersion;
@property (strong, nonatomic) UILabel* updateNameLabel;
@property (strong, nonatomic) UILabel* lastUpdateCheckLabel;
@property (strong, nonatomic) UIImageView* versionBlob;
@property (strong, nonatomic) UIImageView* icon;
@property (strong, nonatomic) UIImageView* iconUnderlay;
@property (strong, nonatomic) UIImageView* iconDivider;
@property (strong, nonatomic) UIImageView* divider;
@property (strong, nonatomic) UITextView* changeDescView;
@property (strong, nonatomic) UIImageView *blurredSnapshotView;
@property (strong, nonatomic) UIImage *blurredSnapshotImage;
@property (strong, nonatomic) UIImage *oldBlurredSnapshotImage;
@property (strong, nonatomic) NSDictionary* moduleDict;
@property (strong, nonatomic) NSDictionary* onlineDict;
@property (strong, nonatomic) UIButton* closeButton;
@property (strong, nonatomic) UIButton *installUpdatesButton;
@property (strong, nonatomic) UIButton *changelogButton;
@property (strong, nonatomic) UIButton *refreshButton;
@property (strong, nonatomic) UIButton *componentsButton;
@property (nonatomic, assign) NSString* moduleID;

-(void)layoutSubviews;
-(void)closePressed:(id)sender;
-(void)loadUp;
-(void)showInstallScreen;
-(void)hideInstallScreen;
-(UIImage *)blurredBackgroundImage;
-(UIImage *)backgroundImage;
@end