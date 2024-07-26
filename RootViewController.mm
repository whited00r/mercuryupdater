#import "RootViewController.h"

#define debug FALSE
#define useStaticBackground TRUE

@interface UIImage (Tint)

- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor alpha:(float)alpha;

@end

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

@implementation RootViewController
@synthesize mController;
- (void)loadView {
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];


//NSMutableArray *modulesList = [[NSMutableArray alloc] init];
NSFileManager *fileManager= [NSFileManager defaultManager];
	self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]] autorelease];
	//self.view.backgroundColor = [UIColor colorWithPatternImage:[self backgroundImage]];//[UIColor colorWithPatternImage:[[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:200.0f green:200.0f blue:200.0f alpha:0.6f] alpha:0.9]];
	self.view.backgroundColor = [UIColor whiteColor];
UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
   
    backgroundImage.image = [[self blurredBackgroundImage] tintedImageUsingColor:[UIColor colorWithRed:60.0f green:30.0f blue:30.0f alpha:0.4f] alpha:1];
    //backgroundImage.contentMode = UIViewContentModeTopLeft; 
   // backgroundImage.clipsToBounds = YES;
    [self.view addSubview:backgroundImage];
    [backgroundImage release];

    UIView *backgroundTint = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundTint.backgroundColor = [UIColor blackColor];
    backgroundTint.alpha = 0.6;
    [self.view addSubview:backgroundTint];
    [backgroundTint release];

	modulesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40)];
  modulesTableView.backgroundColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.0f];
    modulesTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    modulesTableView.dataSource = self;
    modulesTableView.delegate = self;
    [modulesTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   	[modulesTableView reloadData];

    [self.view addSubview:modulesTableView];
    [modulesTableView release];
    //TODO: If the number of modules is only 1, then just jump straight to that module rather than showing an overview list of all modules.
[pool drain];
}


-(void)viewDidLoad{
		CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
screenWidth = screenFrame.size.width;
//Bonus height.
screenHeight = screenFrame.size.height;
  if(debug) NSLog(@"ScreenWidth: %f", screenWidth);
  modulesTableView.frame = CGRectMake(0, 40, screenWidth, screenHeight - 40);

   
}

-(void)reloadData{
  
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//if(debug) NSLog(@"Moduleslist count is: %@", mController);
        return mController.modulesList.count;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
   return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";

    NSDictionary *cellDict = [mController.modulesList objectAtIndex:indexPath.row]; //FIXME: put error handling in to make sure we have this!

    ModuleEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[ModuleEntryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.backgroundView = [[UIView alloc] init];
    [cell.backgroundView setBackgroundColor:[UIColor clearColor]];
    //[[[cell contentView] subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if(debug) NSLog(@"Loading up: %@", cellDict);
    cell.moduleName.text = [cellDict objectForKey:@"displayName"];
    if([cellDict objectForKey:@"identifier"]){
      cell.moduleID = [[cellDict objectForKey:@"identifier"] copy];
    }
    else{
      cell.moduleID = @"default";
    }
    if([[cellDict objectForKey:@"updatesAvailable"] intValue] > 0){
      cell.updatesAvailable = true;
      cell.numberOfUpdates = [[cellDict objectForKey:@"updatesAvailable"] intValue];
    }

    cell.moduleVersion.text = [NSString stringWithFormat:@"v%@",[cellDict objectForKey:@"version"]];
    [cell loadUp];
    if(debug) NSLog(@"Cell is: %@", cell);

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       NSDictionary *cellDict = [mController.modulesList objectAtIndex:indexPath.row]; //FIXME: put error handling in to make sure we have this!
       [modulesTableView deselectRowAtIndexPath:indexPath animated:YES];
        /*
        [UIView animateWithDuration:0.3
                      delay:0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                   
                   [modulesTableView cellForRowAtIndexPath:indexPath].transform=CGAffineTransformMakeScale(1.05, 1.05);
           
                 }
                 completion:^(BOOL finished){

                  [UIView animateWithDuration:0.3
                      delay:0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                   
                   [modulesTableView cellForRowAtIndexPath:indexPath].transform=CGAffineTransformMakeScale(0.95, 0.95);
           
                 }
                 completion:^(BOOL finished){
                  [UIView animateWithDuration:0.3
                      delay:0
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                   [modulesTableView cellForRowAtIndexPath:indexPath].transform=CGAffineTransformMakeScale(1.0, 1.0);
                 } completion:nil];
                 }];
                 }];
                 */
  ModuleEntryCell *cell = [modulesTableView cellForRowAtIndexPath:indexPath];
  CGRect rect = [cell convertRect:cell.frame toView:self.view];
  if(debug) NSLog(@"Cell is :%@", cell);
  if(debug) NSLog(@"Rect y is: %f", rect.origin.y);
 [self.navigationController showModuleForID:[cellDict objectForKey:@"identifier"] atY:rect.origin.y];
//[self.navigationController showModuleForID:[cellDict objectForKey:@"identifier"]];
       if(debug) NSLog(@"Touched %@, %f", [cellDict objectForKey:@"identifier"], rect.origin.y);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView_ {
  
   
   //Nasty nasty nasty hack to get the blurred background to sort of "show through" as the divider between cells.
  for (NSIndexPath *indexPath in [modulesTableView indexPathsForVisibleRows]) {
    //Do something with your indexPath. Maybe you want to get your cell,
    // like this:
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ModuleEntryCell *cell = [modulesTableView cellForRowAtIndexPath:indexPath];
    CGRect rect = [modulesTableView convertRect:[modulesTableView rectForRowAtIndexPath:indexPath] toView:[modulesTableView superview]];
    cell.divider.layer.contentsRect = CGRectMake(0.0, (rect.origin.y + (cell.contentView.frame.size.height - 6.5))/ [modulesTableView superview].frame.size.height, 1, 1);
    cell.versionBlob.layer.contentsRect = CGRectMake(0.0, (rect.origin.y + (cell.contentView.frame.size.height - 6.5))/ [modulesTableView superview].frame.size.height, 1, 1);
    cell.iconUnderlay.layer.contentsRect = CGRectMake(0.0, (rect.origin.y + (cell.contentView.frame.size.height - 8))/ [modulesTableView superview].frame.size.height, 1, 1);   
    cell.iconDivider.layer.contentsRect = CGRectMake(0.0, (rect.origin.y + (cell.contentView.frame.size.height - 10))/ [modulesTableView superview].frame.size.height, 1, 1);   
     
     // if(debug) NSLog(@"Y is: %f", rect.origin.y / [modulesTableView superview].frame.size.height);
}
}

-(void)dealloc{
	
	[super dealloc];
}

-(UIImage *)blurredBackgroundImage{
    if(useStaticBackground){
      if(screenWidth > 400){
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
