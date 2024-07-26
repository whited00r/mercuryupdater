#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface ModuleEntryCell : UITableViewCell{
	bool animatingNameOut;
	bool animateNameIn;
	bool _updatesAvailable;
	int _numberOfUpdates;
	NSString *_moduleID;

}

@property (strong, nonatomic) UILabel* moduleName;
@property (strong, nonatomic) UILabel* moduleVersion;
@property (strong, nonatomic) UIImageView* versionBlob;
@property (strong, nonatomic) UIImageView* divider;
@property (strong, nonatomic) UIImageView* icon;
@property (strong, nonatomic) UIImageView* iconUnderlay;
@property (strong, nonatomic) UIImageView* iconDivider;
@property (nonatomic, assign) NSString* moduleID;
@property (nonatomic, assign) bool updatesAvailable;
@property (nonatomic, assign) int numberOfUpdates;
//@property (strong, nonatomic) UILabel* priceValue;


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
@end