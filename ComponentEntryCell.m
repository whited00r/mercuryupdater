#import "ComponentEntryCell.h"
#define useStaticBackground TRUE

@interface UIImage (Tint)

- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor alpha:(float)alpha;

@end


/*

TODO/FIXME:
When an update is available ([moduleDict objectForKey:@"updateAvailable"]) set a small indicator dot next to the cell or indicate it somehow else.

*/

@implementation UIImage (Tint)

- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor alpha:(float)alpha {
  UIGraphicsBeginImageContext(self.size);
  CGRect drawRect = CGRectMake(0, 0, self.size.width, self.size.height);
  [self drawInRect:drawRect blendMode:kCGBlendModeNormal alpha:alpha];

  [tintColor set];
  UIRectFillUsingBlendMode(drawRect, kCGBlendModeColor);

  [self drawInRect:drawRect blendMode:kCGBlendModeDestinationIn alpha:1.0f];
  UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return tintedImage;
}

@end

@implementation ComponentEntryCell
@synthesize componentID, updatesAvailable, isObsolete, componentTitle;
-(id)initWithStyle:(UITableViewStyle*)UITableViewCellStyleDefault reuseIdentifier:(NSString*)cellIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if(self){
    // Create & position UI elements
   // self.componentID = [[NSString alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];

    self.componentName = [[UILabel alloc] init];
    self.componentName.frame = CGRectMake(15,0,200, 50);
    self.componentName.alpha = 0.9;
    self.componentName.textColor = [UIColor whiteColor];
    self.componentName.backgroundColor = [UIColor clearColor];
    self.componentName.font = [UIFont systemFontOfSize:18.0];
    [self.contentView addSubview:self.componentName];


    self.versionBlob = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 60, 10, 50, 30)];
   
    self.versionBlob.image = [self blurredBackgroundImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
    self.versionBlob.contentMode = UIViewContentModeTopLeft; 
    //self.versionBlob.clipsToBounds = YES;
    //self.versionBlob.layer.cornerRadius = 10;
    self.versionBlob.layer.masksToBounds = YES;
    self.versionBlob.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
    [self.contentView addSubview:self.versionBlob];

    self.componentVersion = [[UILabel alloc] init];
    self.componentVersion.alpha = 0.9;
    self.componentVersion.frame = CGRectMake(self.contentView.frame.size.width - 60, 10, 50, 30);
    self.componentVersion.textColor = [UIColor whiteColor];
    self.componentVersion.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.20];
    //self.componentVersion.layer.cornerRadius = 10;
    //self.componentVersion.layer.masksToBounds = YES;
    self.componentVersion.font = [UIFont italicSystemFontOfSize:14.0];
    self.componentVersion.textAlignment = UITextAlignmentCenter;

    [self.contentView addSubview:self.componentVersion];

    

    UIImageView *bgColorView = [[UIImageView alloc] init];
    bgColorView.image = [self blurredBackgroundImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:200.0f green:200.0f blue:200.0f alpha:0.6f] alpha:0.9];
    bgColorView.contentMode = UIViewContentModeTopLeft; 
    bgColorView.clipsToBounds = YES;
    bgColorView.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
    [self setSelectedBackgroundView:bgColorView];

    self.divider = [[UIImageView alloc] initWithFrame:CGRectMake(15,self.contentView.frame.size.height - 0.5, self.contentView.frame.size.width - 15, 0.5)];
   
    self.divider.image = [self blurredBackgroundImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:200.0f green:200.0f blue:200.0f alpha:0.6f] alpha:0.9];
    self.divider.contentMode = UIViewContentModeTopLeft; 
    self.divider.clipsToBounds = YES;
    self.divider.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
    [self.contentView addSubview:self.divider];
   // [divider release];
    }
    

    return self;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];

  if(![self.contentView showingToolTip]){
    [self.contentView pregenToolTipForText:self.componentID liveBlur:false];
    [self.contentView setToolTipYOffset:5]; 
    [self.contentView setToolTipXOffset:15];
    [self.contentView showToolTip];
  }
    /*
    [UIView animateWithDuration:0.3
                      delay:0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                   
                   self.transform=CGAffineTransformMakeScale(1.05, 1.05);
                   //self.backgroundColor = [UIColor colorWithPatternImage:[self blurredBackgroundImage]];
           
                 }
                 completion:nil];
*/


}

-(void)loadUp{
      
      if(self.updatesAvailable && !self.isObsolete){
         self.componentVersion.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:130.0f alpha:0.40];
      }
      if(!self.updatesAvailable && !self.isObsolete){
         self.componentVersion.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.20];
      }

      if(self.isObsolete){
        self.componentVersion.backgroundColor = [UIColor colorWithRed:130.0f green:0.0f blue:0.0f alpha:0.40];
      }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:true];

   /*
    if(highlighted){

         animatingNameOut = TRUE;
         [UIView animateWithDuration:0.3
                      delay:0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                
                  // self.componentName.frame = CGRectMake(70,0,190, 50);
                   self.transform=CGAffineTransformMakeScale(1.1, 1.1);
                  // self.icon.transform=CGAffineTransformMakeScale(1.05, 1.05);
           
                 }
                 completion:^(BOOL finished){
                    animatingNameOut = FALSE;
                    if(animateNameIn){
                        [UIView animateWithDuration:0.3
                      delay:0.1
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                   
                  // self.componentName.frame = CGRectMake(60,0,200, 50);
                   self.transform=CGAffineTransformMakeScale(1.0, 1.0);
                  // self.icon.transform=CGAffineTransformMakeScale(1.0, 1.0);
           
                 }
                 completion:^(BOOL finished){
                    animateNameIn = FALSE;
                 }]; 
                    }
                 }]; 

    }
    else{
        
        if(!animatingNameOut){
            [UIView animateWithDuration:0.3
                      delay:0.1
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                   
                  // self.componentName.frame = CGRectMake(60,0,200, 50);
                   self.transform=CGAffineTransformMakeScale(1.0, 1.0);
                  // self.icon.transform=CGAffineTransformMakeScale(1.0, 1.0);
           
                 }
                 completion:nil]; 
        }
        else{
            animateNameIn = TRUE;
        }
    }

*/
    NSLog (@"setHighlighted:%@ animated:%@", (highlighted?@"YES":@"NO"), (animated?@"YES":@"NO"));
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
       [super touchesEnded:touches withEvent:event];
 

  if([self.contentView showingToolTip]){
     [self.contentView performSelector:@selector(hideToolTip) withObject:nil afterDelay:1.5];
  }

/*
[UIView animateWithDuration:0.3
                      delay:0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                   
                   self.transform=CGAffineTransformMakeScale(1.05, 1.05);
           
                 }
                 completion:^(BOOL finished){
[UIView animateWithDuration:0.3
                      delay:0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                   
                   self.transform=CGAffineTransformMakeScale(0.95, 0.95);
           
                 }
                 completion:^(BOOL finished){
                  [UIView animateWithDuration:0.3
                      delay:0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                     self.transform=CGAffineTransformMakeScale(1.0, 1.0);
                 } completion:nil];
                 }];
                 }];
*/
}


-(UIImage*)iconImage{
    //bool exists = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/Icons/%@.png", self.componentID]];
    NSFileManager *fileManager= [NSFileManager defaultManager];
   // NSLog(@"Checking %@\nfor image for %@", [fileManager contentsOfDirectoryAtPath:@"/var/mobile/Library/Mercury/Icons" error:nil], [NSString stringWithFormat:@"/var/mobile/Library/Mercury/Icons/%@.png", self.componentID]);
if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/Icons/%@.png", self.componentID]]){
    //NSLog(@"Found!");
  return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/Icons/%@.png", self.componentID]]; //Flags?
}
else{
    //NSLog(@"Not found :('%@'",[NSString stringWithFormat:@"/var/mobile/Library/Mercury/Icons/%@.png", self.componentID]);
  return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Applications/MercuryUpdater.app/icon.png"]]; //Flags?
}
}

-(UIImage *)blurredBackgroundImage{
    if(useStaticBackground){
      if([[UIScreen mainScreen] applicationFrame].size.width > 400){
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
@end