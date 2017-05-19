//
//  WEMainTabBarController.m
//  woeat
//
//  Created by liubin on 16/10/11.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEMainTabBarController.h"
#import "WEMainHomePageViewController.h"
#import "WEMainDiscoverViewController.h"
#import "WEMainOrderViewController.h"
#import "WEPersonalCenterViewController.h"
#import "RDVTabBarItem.h"
#import "WEUtil.h"
#import "WEBaseNavigationController.h"

static WEMainTabBarController *sTabBarController = nil;

@interface WEMainTabBarController ()

@end

@implementation WEMainTabBarController

+ (instancetype)sharedInstance
{
    return sTabBarController;
}

- (instancetype)init
{
    self = [super init];
    if (self){
        WEMainHomePageViewController *c1=[[WEMainHomePageViewController alloc]init];
        WEBaseNavigationController *nav1 = [[WEBaseNavigationController alloc] initWithRootViewController:c1];
        c1.title=@"首页";
        
//        WEMainDiscoverViewController *c2=[[WEMainDiscoverViewController alloc]init];
//        WEBaseNavigationController *nav2 = [[WEBaseNavigationController alloc] initWithRootViewController:c2];
//        c2.title=@"发现";
        
        WEMainOrderViewController *c3=[[WEMainOrderViewController alloc]init];
        WEBaseNavigationController *nav3 = [[WEBaseNavigationController alloc] initWithRootViewController:c3];
        c3.title=@"订单";
        
        WEPersonalCenterViewController *c4=[[WEPersonalCenterViewController alloc]init];
        WEBaseNavigationController *nav4 = [[WEBaseNavigationController alloc] initWithRootViewController:c4];
        c4.title=@"我的";
        
        //self.viewControllers=@[nav1, nav2, nav3, nav4];
        self.viewControllers=@[nav1, nav3, nav4];
        
        [self setupTabBar];
    }
    
    sTabBarController = self;
    return self;
}

- (void)setupTabBar
{
    
    //    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    //    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    //NSArray *tabBarItemImages = @[@"tab_icon_home", @"tab_icon_discover", @"tab_icon_order", @"tab_icon_setting"];
    NSArray *tabBarItemImages = @[@"bottom_tab_icon_home", @"bottom_tab_icon_order", @"bottom_tab_icon_setting"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        //[item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        item.unselectedTitleAttributes = @{
                                           NSFontAttributeName: [UIFont systemFontOfSize:10],
                                           NSForegroundColorAttributeName: [UIColor colorWithRed:169/255.0
                                                                                           green:169/255.0
                                                                                            blue:169/255.0
                                                                                           alpha:1.0],
                                           };
        item.selectedTitleAttributes = @{
                                         NSFontAttributeName: [UIFont systemFontOfSize:10],
                                         NSForegroundColorAttributeName: [UIColor colorWithRed:47/255.0
                                                                                         green:185/255.0
                                                                                          blue:147/255.0
                                                                                         alpha:1.0],
                                         };
        if (index == 0) {
            item.titlePositionAdjustment = UIOffsetMake(0, 0);
        } else {
            item.titlePositionAdjustment = UIOffsetMake(0, 2);
        }
        
        if (index == 0) {
            item.imagePositionAdjustment = UIOffsetMake(0, -1);
        } else {
            item.imagePositionAdjustment = UIOffsetMake(0, 0);
        }
        
        
        index++;
    }
    self.tabBar.backgroundView.backgroundColor = [UIColor colorWithRed:255/255.0
                                                                 green:255/255.0
                                                                  blue:255/255.0
                                                                 alpha:1.0];
    CGRect r = CGRectMake(0, 0, [WEUtil getScreenWidth], 1);
    UIView *line = [[UIView alloc] initWithFrame:r];
    line.backgroundColor = [UIColor colorWithRed:232/255.0
                                           green:232/255.0
                                            blue:232/255.0
                                           alpha:1.0];
    [self.tabBar.backgroundView addSubview:line];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
