//
//  WEBaseNavigationController.m
//  woeat
//
//  Created by liubin on 16/11/15.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEBaseNavigationController.h"
#import "WEUtil.h"

#define BOTTOM_LINE_TAG  111222


@implementation WEBaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINavigationBar *bar = [self navigationBar];
    UIView *superView = bar;
    
    UIView *line = [UIView new];
    line.backgroundColor = DARK_ORANGE_COLOR;
    [superView addSubview:line];
    float height = bar.frame.size.height;
    line.frame = CGRectMake(0, height-2, [WEUtil getScreenWidth], 2);
    line.tag = BOTTOM_LINE_TAG;
}

+ (void)hideNavBarBottomLine:(UIViewController *)controller
{
    WEBaseNavigationController *nav = controller.navigationController;
    if ([nav isKindOfClass:[WEBaseNavigationController class]]) {
        UINavigationBar *bar = [nav navigationBar];
        UIView *line = [bar viewWithTag:BOTTOM_LINE_TAG];
        line.hidden = YES;
    }
}

+ (void)showNavBarBottomLine:(UIViewController *)controller
{
    WEBaseNavigationController *nav = controller.navigationController;
    if ([nav isKindOfClass:[WEBaseNavigationController class]]) {
        UINavigationBar *bar = [nav navigationBar];
        UIView *line = [bar viewWithTag:BOTTOM_LINE_TAG];
        line.hidden = NO;
    }
}

@end
