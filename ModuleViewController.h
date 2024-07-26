#import <Foundation/Foundation.h>
#import <Foundation/NSTask.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>

#import "ModuleView.h"
#import "MercuryModuleProtocol.h"

#import "MercuryControllerDelegate.h"
#import "MercuryNavigationController.h"
#import "MercuryModule.h"
#import "UIImage+LiveBlur.h"
#import "ComponentEntryCell.h"

@class MercuryModule;
@interface ModuleViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
	id <MercuryControllerDelegate> mController;
	MercuryModule *_module;
	bool _hasSnapshot;
	float screenWidth;
	float screenHeight;
	float lastOpenedY;
	ModuleView *moduleView;
}
@property (nonatomic, assign) id <MercuryControllerDelegate> mController;
@property (nonatomic, assign) MercuryModule *module;
@property (strong, nonatomic) UIImage *blurredTableView;
@property (nonatomic, assign) bool isInstalling;

@property (nonatomic, assign) bool hasSnapshot;
-(void)animateOpenFromY:(float)y;
-(void)directOpen;
-(void)reload;
@end



@interface ComponentHeaderView : UIView{
}
@property (strong, nonatomic) UIImageView *blurredSnapshotView;
@property (nonatomic, assign) ModuleViewController *viewController;
@end
