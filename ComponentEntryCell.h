#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
//#import "UIView+ToolTip.h"
@interface ComponentEntryCell : UITableViewCell{
	bool animatingNameOut;
	bool animateNameIn;
	bool _updatesAvailable;
	bool _isObsolete;
	int _onlineVersion;
	NSString *_componentID;
	NSString *_componentTitle;

}

@property (strong, nonatomic) UILabel* componentName;
@property (strong, nonatomic) UILabel* componentVersion;
@property (strong, nonatomic) UIImageView* versionBlob;
@property (strong, nonatomic) UIImageView* divider;
@property (nonatomic, assign) NSString* componentID;
@property (nonatomic, assign) NSString* componentTitle;
@property (nonatomic, assign) bool updatesAvailable;
@property (nonatomic, assign) bool isObsolete;
@property (nonatomic, assign) int onlineVersion;


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end