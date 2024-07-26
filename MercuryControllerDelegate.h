
@protocol MercuryControllerDelegate
-(void)loadUp;
-(void)sendAction:(NSDictionary*)action;
-(void)handleNotification:(NSNotification*)notification;
@property (nonatomic, assign) NSMutableArray *modulesList; //The list of dicts for each module
@property (nonatomic, assign) NSMutableDictionary *modules; //Contains the modules objects
@end