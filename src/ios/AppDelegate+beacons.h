#import "AppDelegate.h"

@interface AppDelegate (beacons) CDVPlugin<CLLocationManagerDelegate>
  
  @property (retain) CLLocationManager *locationManager;

- (BOOL) xxx_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end
