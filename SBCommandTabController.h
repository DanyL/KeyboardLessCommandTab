@interface SBCommandTabController : NSObject

@property(readonly, nonatomic) BOOL isVisible;

+ (SBCommandTabController *)sharedInstance;
- (void)viewController:(UIViewController *)viewController selectedApplicationWithBundleID:(NSString *)bundleId;
- (void)_activateWithForwardDirection:(BOOL)direction;
- (void)dismiss;

@end
