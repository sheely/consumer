//
//  WECustomNavButtonViewController.m
//  woeat
//
//  Created by liubin on 16/10/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WECustomNavButtonViewController.h"
#import "WEUtil.h"
#import "WEImageButton.h"

@interface WECustomNavButton : WEImageButton
{
}
@end
@implementation WECustomNavButton
@end


@interface WECustomNavButtonViewController ()
@property(nonatomic, weak) UINavigationController *parentNavController;
@end

@implementation WECustomNavButtonViewController

#if 1
- (UIButton *)addLeftNavButton:(NSString *)title target:(id)target selector:(SEL)sel
{
    _parentNavController = self.navigationController;

    WECustomNavButton *leftButton = [[WECustomNavButton alloc] initWithImage:nil title:title];
    leftButton.label.font = [UIFont systemFontOfSize:17];
    [self.navigationController.navigationBar addSubview:leftButton];
    [leftButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(17, 13, 50, 20);
    return leftButton;
}

- (UIButton *)addRightNavButton:(NSString *)title image:(NSString *)imageName target:(id)target selector:(SEL)sel
{
    _parentNavController = self.navigationController;
    
    UIImage *img = nil;
    if (imageName) {
        img = [UIImage imageNamed:imageName];
    }
    WECustomNavButton *rightButton = [[WECustomNavButton alloc] initWithImage:img title:title];
    [self.navigationController.navigationBar addSubview:rightButton];
    [rightButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    float width = 55;
    //float rightMargin = 15;
    //rightButton.frame = CGRectMake([WEUtil getScreenWidth]-width-rightMargin, 10, width, 25);
    rightButton.frame = CGRectMake([WEUtil getScreenWidth]-width, 0, width, 43);
   
//    UIView *superView = self.navigationController.navigationBar;
//    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(superView.centerY);
//        make.right.equalTo(superView.right);
//        make.width.equalTo(50);
//        make.height.equalTo(superView.height);
//    }];

    return rightButton;
}

- (void)removeButtons
{
    UINavigationController *nav = self.navigationController;
    if (!nav) {
        nav = _parentNavController;
    }
    for(UIView *v in nav.navigationBar.subviews) {
        if ([v isKindOfClass:[WECustomNavButton class]]) {
            [v removeFromSuperview];
        }
    }
}


#else

- (UIButton *)addLeftNavButton:(NSString *)title target:(id)target selector:(SEL)sel
{
    CustomNavButton *leftButton = [CustomNavButton buttonWithType:UIButtonTypeCustom];
    [leftButton setTitle:title forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.navigationController.navigationBar addSubview:leftButton];
    [leftButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(17, 13, 50, 20);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = item;
    return leftButton;
}

- (UIButton *)addRightNavButton:(NSString *)title target:(id)target selector:(SEL)sel
{
    CustomNavButton *rightButton = [CustomNavButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:title forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.navigationController.navigationBar addSubview:rightButton];
    [rightButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake([Util getScreenWidth]-60, 13, 50, 20);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
    return rightButton;
}

- (void)removeButtons
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    return;
}

#endif

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeButtons];
}
@end
