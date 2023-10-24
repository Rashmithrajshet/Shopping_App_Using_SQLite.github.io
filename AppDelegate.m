#import "AppDelegate.h"
#import "LoginController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    UINavigationController *navigationController=[[UINavigationController alloc]init];
    LoginController *viewControllerToPush=[[LoginController alloc]init];
    [navigationController pushViewController:viewControllerToPush animated:NO];
    self.window.rootViewController=navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end

