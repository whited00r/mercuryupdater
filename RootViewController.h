#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MercuryModule.h"
#import "MercuryControllerDelegate.h"
#import "ModuleEntryCell.h"

@interface RootViewController: UIViewController <UITableViewDataSource,UITableViewDelegate>{
	UITableView *modulesTableView; //Lists the currently installed modules.
	id <MercuryControllerDelegate> mController;
	UIImageView *tableMaskView;
	float screenWidth;
	float screenHeight;
}
@property (nonatomic, assign) id <MercuryControllerDelegate> mController;
@end
