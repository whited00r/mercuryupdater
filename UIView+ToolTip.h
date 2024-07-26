#import <Foundation/Foundation.h>
#import <Foundation/NSTask.h>
#import <UIKit/UIKit.h>
#import <CoreFoundation/CoreFoundation.h>
#import <objc/runtime.h>
#import "UIImage+LiveBlur.h"
#import "ComponentEntryCell.h"
#import <UIKit/UITableViewCellContentView.h>
/*
UIView+ToolTip
Grayd00r 2015 
Very very very very rudimentary category to allow for showing tooltips above UIViews. 
*/

@interface UIView (ToolTip)
-(void)pregenToolTipForText:(NSString*)text;
-(void)showToolTip;
-(void)hideToolTip;
-(bool)showingToolTip;

@property (strong, nonatomic) UILabel* toolTipLabel;
@property (strong, nonatomic) UIImageView *toolTipBlurredBackground;
@end


@interface UIButton (ToolTip)
-(void)pregenToolTipForText:(NSString*)text liveBlur:(BOOL)liveBlur;
-(void)showToolTip;
-(void)hideToolTip;
-(bool)showingToolTip;

@property (strong, nonatomic) UILabel* toolTipLabel;
@property (strong, nonatomic) UIImageView *toolTipBlurredBackground;
@end

/*
@interface UITableViewCellContentView (ToolTip)
-(void)pregenToolTipForText:(NSString*)text liveBlur:(BOOL)liveBlur;
-(void)setToolTipYOffset:(float)yOffset;
-(void)setToolTipXOffset:(float)xOffset;
-(void)showToolTip;
-(void)hideToolTip;
-(bool)showingToolTip;

@property (strong, nonatomic) UILabel* toolTipLabel;
@property (strong, nonatomic) UIImageView *toolTipBlurredBackground;
@end
*/