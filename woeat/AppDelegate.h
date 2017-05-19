//
//  AppDelegate.h
//  woeat
//
//  Created by liubin on 16/10/11.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)setRootToMainTabController:(UIViewController *)originController;
- (void)setRootToLoginController;

- (void)selectRootController;
@end

