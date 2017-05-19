//
//  AppDelegate.m
//  woeat
//
//  Created by liubin on 16/10/11.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "AppDelegate.h"
#import "WELoginViewController.h"
#import "IQKeyboardManager.h"
#import "WEMainTabBarController.h"
#import "WEIntroViewController.h"
#import "RNCachingURLProtocol.h"
#import "WEBaseNavigationController.h"
#import "WEGlobalData.h"
#import "WEToken.h"
#import "WEIntroDownload.h"
#import "WEIntroViewController.h"
#import "WELocationManager.h"
#import "UmengStat.h"  
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)addWindowAnimation
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:1.0];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:@"rootControllerAnim"];
}


- (void)removeWindowAnimation
{
    [[UIApplication sharedApplication].keyWindow.layer removeAnimationForKey:@"rootControllerAnim"];
}

- (void)setRootToMainTabController:(UIViewController *)originController
{
    if (!originController) {
        WEMainTabBarController *tb = [WEMainTabBarController new];
        self.window.rootViewController = tb;
        [self.window addSubview:tb.view];
        [self.window makeKeyAndVisible];
        return;
    }
    
    [self addWindowAnimation];
    
    [originController.view removeFromSuperview];
    [self performSelector:@selector(removeWindowAnimation) withObject:nil afterDelay:3.0];

    WEMainTabBarController *tb = [WEMainTabBarController new];
    
    [UIView transitionFromView:originController.view
                        toView:tb.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished)
     {
         self.window.rootViewController = tb;
         [self.window addSubview:tb.view];
         [originController.view removeFromSuperview];
     }];
    
    
    [self.window makeKeyAndVisible];
}

- (void)setRootToLoginController
{
    WELoginViewController *c1=[[WELoginViewController alloc]init];
    WEBaseNavigationController *nav1 = [[WEBaseNavigationController alloc] initWithRootViewController:c1];
    nav1.navigationBar.hidden = NO;
    self.window.rootViewController=nav1;
    [self.window addSubview:nav1.view];
    [self.window makeKeyAndVisible];
}

- (void)setRootToIntroController:(NSArray *)imageArray
{
    WEIntroViewController *c1 = [[WEIntroViewController alloc] initWithImageArray:imageArray];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:c1];
    nav1.navigationBar.hidden = YES;
    self.window.rootViewController=nav1;
    [self.window addSubview:nav1.view];
    [self.window makeKeyAndVisible];
}

- (void)selectRootController
{
    NSArray *array = [WEIntroDownload getDispayImagePathArray];
    if (array.count) {
        [self setRootToIntroController:array];
        return;
    }
    
    NSString *token = [WEToken getToken];
    if (token.length) {
        [self setRootToMainTabController:nil];
    } else {
        [self setRootToLoginController];
    }
}

- (void)setNav
{
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barTintColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    bar.tintColor = DARK_ORANGE_COLOR;
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    bar.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];

    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary: [[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateNormal]];
    [attributes setValue:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    //[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
      //                                                   forBarMetrics:UIBarMetricsDefault];
    
//    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor clearColor]} forState:UIControlStateNormal];
    
    //[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Fabric with:@[[Crashlytics class]]];
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_PHONE];
    if (phone.length) {
        [CrashlyticsKit setUserIdentifier:phone];
    }
    
    
#if URL_CACHING
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
#endif
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[WELocationManager sharedInstance] startLocation];
    
    [self setNav];
    [self selectRootController];
    [self setupUmeng];
   
    return YES;
}

- (void)setupUmeng {
    [UmengStat initWithAppKey:UMENG_APP_KEY];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [WEGlobalData quitBackground];
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    // 关闭横屏
    return UIInterfaceOrientationMaskPortrait;
}
@end
