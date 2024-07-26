#import "UIView+ToolTip.h"


@implementation UIView (ToolTip)



-(void)pregenToolTipForText:(NSString*)text liveBlur:(bool)liveBlur{
  if(!self.toolTipLabel){
    NSLog(@"no toolTipLabel");
    self.toolTipLabel = [[UILabel alloc] init];
      self.toolTipLabel.frame = CGRectMake(10,0,40, 0);
      self.toolTipLabel.alpha = 0.9;
      self.toolTipLabel.text = text;
      self.toolTipLabel.textColor = [UIColor whiteColor];
      self.toolTipLabel.backgroundColor = [UIColor clearColor];
      self.toolTipLabel.font = [UIFont boldSystemFontOfSize:18.0];
      
  }

  if(!self.toolTipBlurredBackground){
    CGSize labelSize = [text sizeWithFont:self.toolTipLabel.font 
                        constrainedToSize:CGSizeMake(320, 40)
                        lineBreakMode:self.toolTipLabel.lineBreakMode];
    self.toolTipLabel.frame = CGRectMake(10,0,labelSize.width, 40);
    NSLog(@"labelSize.width is :%f", labelSize.width);
    float yOffset = self.frame.origin.y - 60;
    float xOffset = (self.frame.origin.x - ((labelSize.width + 20) / 2)) + (self.frame.size.width / 2);
    if(xOffset + labelSize.width + 20 > self.superview.frame.size.width){
      xOffset = self.superview.frame.size.width - (labelSize.width + 30);
    }
    if(xOffset < 0){
      xOffset = 0;
    }

    if(yOffset < 0){
      yOffset = 0;
    }
    if(yOffset + 40 > self.superview.frame.size.height){
      yOffset = self.superview.frame.size.height - 50;
    }
    self.toolTipBlurredBackground = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, yOffset, labelSize.width + 20 , 40)]; //Center it above the button. Probably need an option for above, below, and on either side as well to be honest. This works for now though. Could automatically detect the right side if needed I guess.
      
    UIGraphicsBeginImageContext(self.superview.frame.size); //Maybe make this scaled down to do it quicker, but at less quality?

    [self.superview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();

      self.toolTipBlurredBackground.image = [screenShotimage fastBlurWithQuality:4 interpolation:4 blurRadius:15];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
      UIGraphicsEndImageContext();
     
      self.toolTipBlurredBackground.contentMode = UIViewContentModeTopLeft; 
      self.toolTipBlurredBackground.clipsToBounds = YES;
      self.toolTipBlurredBackground.layer.cornerRadius = 10;
      self.toolTipBlurredBackground.layer.masksToBounds = YES;
      self.toolTipBlurredBackground.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
      [self.toolTipBlurredBackground addSubview:self.toolTipLabel];
      self.toolTipBlurredBackground.alpha = 0.0;
      self.toolTipBlurredBackground.hidden = TRUE;
      [self.superview addSubview:self.toolTipBlurredBackground];
  
  }
  //ITS LIVE EVERY TIME GUYS OKAY
  if(liveBlur){
    UIGraphicsBeginImageContext(self.superview.frame.size); //Maybe make this scaled down to do it quicker, but at less quality?

    [self.superview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();

      self.toolTipBlurredBackground.image = [screenShotimage fastBlurWithQuality:4 interpolation:4 blurRadius:15];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
      UIGraphicsEndImageContext();
    }
}

-(void)genToolTipBackground{
  if(self.toolTipBlurredBackground){
     UIGraphicsBeginImageContext(self.superview.frame.size); //Maybe make this scaled down to do it quicker, but at less quality?

    [self.superview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();

      self.toolTipBlurredBackground.image = [screenShotimage fastBlurWithQuality:4 interpolation:4 blurRadius:15];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
      UIGraphicsEndImageContext();
      self.toolTipBlurredBackground.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
  }
}

-(void)setToolTipYOffset:(float)yOffset{ //Could probably condense these into the initilization code, but hey whatever.
  if(self.toolTipBlurredBackground){
    CGRect origFrame = self.toolTipBlurredBackground.frame;
    self.toolTipBlurredBackground.frame = CGRectMake(origFrame.origin.x, self.frame.origin.y - yOffset, origFrame.size.width, origFrame.size.height);
    self.toolTipBlurredBackground.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
  }
}

-(void)setToolTipXOffset:(float)xOffset{
  if(self.toolTipBlurredBackground){
    CGRect origFrame = self.toolTipBlurredBackground.frame;
    self.toolTipBlurredBackground.frame = CGRectMake(self.frame.origin.y - xOffset, origFrame.origin.y, origFrame.size.width, origFrame.size.height);
    self.toolTipBlurredBackground.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
  }
}

- (void)setToolTipLabel:(id)object {
     objc_setAssociatedObject(self, @selector(toolTiplabel), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)toolTipLabel {
    return objc_getAssociatedObject(self, @selector(toolTiplabel));
}

- (void)setToolTipBlurredBackground:(id)object {
     objc_setAssociatedObject(self, @selector(toolTipBlurredBackground), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)toolTipBlurredBackground {
    return objc_getAssociatedObject(self, @selector(toolTipBlurredBackground));
}

-(void)showToolTip{
  NSLog(@"ShowToolTip called");
  self.toolTipBlurredBackground.hidden = FALSE;

[UIView animateWithDuration:0.25
                delay:0.0
                options:UIViewAnimationCurveEaseIn
                animations:^{
                    self.toolTipBlurredBackground.alpha = 1.0;
                  
                  }
              completion:nil]; 
}

-(void)hideToolTip{
[UIView animateWithDuration:0.25
                delay:0.0
                options:UIViewAnimationCurveEaseIn
                animations:^{

                    self.toolTipBlurredBackground.alpha = 0.0;
                  
                  }
              completion:^(BOOL finished){
                self.toolTipBlurredBackground.hidden = TRUE;
              }]; 
}

-(bool)showingToolTip{
  if(self.toolTipBlurredBackground){
    return !self.toolTipBlurredBackground.hidden;
  }
  else{
    return false;
  }
}

@end


@implementation UIButton (ToolTip)


-(void)pregenToolTipForText:(NSString*)text liveBlur:(bool)liveBlur{
  if(!self.toolTipLabel){
    NSLog(@"no toolTipLabel");
    self.toolTipLabel = [[UILabel alloc] init];
      self.toolTipLabel.frame = CGRectMake(10,0,40, 0);
      self.toolTipLabel.alpha = 0.9;
      self.toolTipLabel.text = text;
      self.toolTipLabel.textColor = [UIColor whiteColor];
      self.toolTipLabel.backgroundColor = [UIColor clearColor];
      self.toolTipLabel.font = [UIFont boldSystemFontOfSize:18.0];
      
  }

  if(!self.toolTipBlurredBackground){
    CGSize labelSize = [text sizeWithFont:self.toolTipLabel.font 
                        constrainedToSize:CGSizeMake(320, 40)
                        lineBreakMode:self.toolTipLabel.lineBreakMode];
    self.toolTipLabel.frame = CGRectMake(10,0,labelSize.width, 40);
    NSLog(@"labelSize.width is :%f", labelSize.width);
    float yOffset = self.frame.origin.y - 60;
    float xOffset = (self.frame.origin.x - ((labelSize.width + 20) / 2)) + (self.frame.size.width / 2);
    if(xOffset + labelSize.width + 20 > self.superview.frame.size.width){
      xOffset = self.superview.frame.size.width - (labelSize.width + 30);
    }
    if(xOffset < 0){
      xOffset = 0;
    }

    if(yOffset < 0){
      yOffset = 0;
    }
    if(yOffset + 40 > self.superview.frame.size.height){
      yOffset = self.superview.frame.size.height - 50;
    }
    self.toolTipBlurredBackground = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, yOffset, labelSize.width + 20 , 40)]; //Center it above the button. Probably need an option for above, below, and on either side as well to be honest. This works for now though. Could automatically detect the right side if needed I guess.
     
    UIGraphicsBeginImageContext(self.superview.frame.size); //Maybe make this scaled down to do it quicker, but at less quality?

    [self.superview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();

      self.toolTipBlurredBackground.image = [screenShotimage fastBlurWithQuality:4 interpolation:4 blurRadius:15];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
      UIGraphicsEndImageContext();
     
      self.toolTipBlurredBackground.contentMode = UIViewContentModeTopLeft; 
      self.toolTipBlurredBackground.clipsToBounds = YES;
      self.toolTipBlurredBackground.layer.cornerRadius = 10;
      self.toolTipBlurredBackground.layer.masksToBounds = YES;
      self.toolTipBlurredBackground.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
      [self.toolTipBlurredBackground addSubview:self.toolTipLabel];
      self.toolTipBlurredBackground.alpha = 0.0;
      self.toolTipBlurredBackground.hidden = TRUE;
      [self.superview addSubview:self.toolTipBlurredBackground];
  
  }
  //ITS LIVE EVERY TIME GUYS OKAY
  if(liveBlur){
    UIGraphicsBeginImageContext(self.superview.frame.size); //Maybe make this scaled down to do it quicker, but at less quality?

    [self.superview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();

      self.toolTipBlurredBackground.image = [screenShotimage fastBlurWithQuality:4 interpolation:4 blurRadius:15];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
      UIGraphicsEndImageContext();
    }
}

-(void)setToolTipYOffset:(float)yOffset{ //Could probably condense these into the initilization code, but hey whatever.
  if(self.toolTipBlurredBackground){
    CGRect origFrame = self.toolTipBlurredBackground.frame;
    self.toolTipBlurredBackground.frame = CGRectMake(origFrame.origin.x, self.frame.origin.y - yOffset, origFrame.size.width, origFrame.size.height);
    self.toolTipBlurredBackground.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
  }
}

-(void)setToolTipXOffset:(float)xOffset{
  if(self.toolTipBlurredBackground){
    CGRect origFrame = self.toolTipBlurredBackground.frame;
    self.toolTipBlurredBackground.frame = CGRectMake(self.frame.origin.y - xOffset, origFrame.origin.y, origFrame.size.width, origFrame.size.height);
    self.toolTipBlurredBackground.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
  }
}

- (void)setToolTipLabel:(id)object {
     objc_setAssociatedObject(self, @selector(toolTiplabel), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)toolTipLabel {
    return objc_getAssociatedObject(self, @selector(toolTiplabel));
}

- (void)setToolTipBlurredBackground:(id)object {
     objc_setAssociatedObject(self, @selector(toolTipBlurredBackground), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)toolTipBlurredBackground {
    return objc_getAssociatedObject(self, @selector(toolTipBlurredBackground));
}

-(void)showToolTip{
  NSLog(@"ShowToolTip called");
  self.toolTipBlurredBackground.hidden = FALSE;

[UIView animateWithDuration:0.25
                delay:0.0
                options:UIViewAnimationCurveEaseIn
                animations:^{
                    self.toolTipBlurredBackground.alpha = 1.0;
                  
                  }
              completion:nil]; 
}

-(void)hideToolTip{
[UIView animateWithDuration:0.25
                delay:0.0
                options:UIViewAnimationCurveEaseIn
                animations:^{

                    self.toolTipBlurredBackground.alpha = 0.0;
                  
                  }
              completion:^(BOOL finished){
                self.toolTipBlurredBackground.hidden = TRUE;
              }]; 
}

-(bool)showingToolTip{
  if(self.toolTipBlurredBackground){
    return !self.toolTipBlurredBackground.hidden;
  }
  else{
    return false;
  }
}

@end

