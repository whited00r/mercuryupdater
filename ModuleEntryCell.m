#import "ModuleEntryCell.h"
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

@implementation ModuleEntryCell
@synthesize moduleID, updatesAvailable, numberOfUpdates;
-(id)initWithStyle:(UITableViewStyle*)UITableViewCellStyleDefault reuseIdentifier:(NSString*)cellIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if(self){
    // Create & position UI elements
   // self.moduleID = [[NSString alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];

    self.moduleName = [[UILabel alloc] init];
    self.moduleName.frame = CGRectMake(60,0,200, 50);
    self.moduleName.alpha = 0.9;
    self.moduleName.textColor = [UIColor whiteColor];
    self.moduleName.backgroundColor = [UIColor clearColor];
    self.moduleName.font = [UIFont boldSystemFontOfSize:22.0];
    [self.contentView addSubview:self.moduleName];


    self.versionBlob = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 60, 10, 50, 30)];
   
    self.versionBlob.image = [self blurredBackgroundImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
    self.versionBlob.contentMode = UIViewContentModeTopLeft; 
    self.versionBlob.clipsToBounds = YES;
    self.versionBlob.layer.cornerRadius = 10;
    self.versionBlob.layer.masksToBounds = YES;
    self.versionBlob.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
    [self.contentView addSubview:self.versionBlob];

    self.moduleVersion = [[UILabel alloc] init];
    self.moduleVersion.alpha = 0.9;
    self.moduleVersion.frame = CGRectMake(self.contentView.frame.size.width - 60, 10, 50, 30);
    self.moduleVersion.textColor = [UIColor whiteColor];
    self.moduleVersion.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.20];
    self.moduleVersion.layer.cornerRadius = 10;
    self.moduleVersion.layer.masksToBounds = YES;
    self.moduleVersion.font = [UIFont italicSystemFontOfSize:14.0];
    self.moduleVersion.textAlignment = UITextAlignmentCenter;

    [self.contentView addSubview:self.moduleVersion];

    self.iconDivider = [[UIImageView alloc] initWithFrame:CGRectMake(54, 10, 1, 30)]; //This is the actual icon underlay
    self.iconDivider.image = [self blurredBackgroundImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
    self.iconDivider.contentMode = UIViewContentModeTopLeft; 
    self.iconDivider.clipsToBounds = YES;
    //self.iconDivider.layer.cornerRadius = 10;
    self.iconDivider.layer.masksToBounds = YES;
    self.iconDivider.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
    [self.contentView addSubview:self.iconDivider];


    //self.iconUnderlay = [[UIImageView alloc] initWithFrame:CGRectMake(54, 10, 1, 30)]; //Well, it is more of a divider between the icon and the module name label now.
    self.iconUnderlay = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)]; //This is the actual icon underlay
    self.iconUnderlay.image = [self blurredBackgroundImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
    self.iconUnderlay.contentMode = UIViewContentModeTopLeft; 
    self.iconUnderlay.clipsToBounds = YES;
    self.iconUnderlay.layer.cornerRadius = 5;
    self.iconUnderlay.layer.masksToBounds = YES;
    self.iconUnderlay.layer.contentsRect = CGRectMake(0.0, 0.0, 1, 1);
    [self.contentView addSubview:self.iconUnderlay];

    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(17, 12, 26, 26)];
   
   // self.icon.image = [self iconImage];//[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:250.0f green:250.0f blue:250.0f alpha:0.3f] alpha:0.6];
    //self.icon.clipsToBounds = YES;
    //self.icon.layer.cornerRadius = 10;
    [self.contentView addSubview:self.icon];


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
      self.icon.image = [self iconImage]; //Can't be bothered to debug why it doesn't compile when I use a custom initilization method
      if(self.updatesAvailable){
         self.moduleVersion.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:130.0f alpha:0.40];
      }
      else{
         self.moduleVersion.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.20];
      }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:true];

   
    if(highlighted){

         animatingNameOut = TRUE;
         [UIView animateWithDuration:0.3
                      delay:0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                
                  // self.moduleName.frame = CGRectMake(70,0,190, 50);
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
                   
                  // self.moduleName.frame = CGRectMake(60,0,200, 50);
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
                   
                  // self.moduleName.frame = CGRectMake(60,0,200, 50);
                   self.transform=CGAffineTransformMakeScale(1.0, 1.0);
                  // self.icon.transform=CGAffineTransformMakeScale(1.0, 1.0);
           
                 }
                 completion:nil]; 
        }
        else{
            animateNameIn = TRUE;
        }
    }


    NSLog (@"setHighlighted:%@ animated:%@", (highlighted?@"YES":@"NO"), (animated?@"YES":@"NO"));
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
       [super touchesEnded:touches withEvent:event];



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
    //bool exists = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/Icons/%@.png", self.moduleID]];
    NSFileManager *fileManager= [NSFileManager defaultManager];
   // NSLog(@"Checking %@\nfor image for %@", [fileManager contentsOfDirectoryAtPath:@"/var/mobile/Library/Mercury/Icons" error:nil], [NSString stringWithFormat:@"/var/mobile/Library/Mercury/Icons/%@.png", self.moduleID]);
if([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/Icons/%@.png", self.moduleID]]){
    //NSLog(@"Found!");
  return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Mercury/Icons/%@.png", self.moduleID]]; //Flags?
}
else{
    //NSLog(@"Not found :('%@'",[NSString stringWithFormat:@"/var/mobile/Library/Mercury/Icons/%@.png", self.moduleID]);
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