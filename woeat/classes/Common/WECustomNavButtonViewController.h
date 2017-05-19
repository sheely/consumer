//
//  WECustomNavButtonViewController.h
//  woeat
//
//  Created by liubin on 16/10/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WECustomNavButtonViewController : UIViewController

- (UIButton *)addLeftNavButton:(NSString *)title target:(id)target selector:(SEL)sel;
- (UIButton *)addRightNavButton:(NSString *)title image:(NSString *)imageName target:(id)target selector:(SEL)sel;

@end
