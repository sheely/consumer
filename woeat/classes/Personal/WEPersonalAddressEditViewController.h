//
//  WEPersonalAddressEditViewController.h
//  woeat
//
//  Created by liubin on 16/11/28.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WECustomNavButtonViewController.h"
#import "WEAddress.h"

@interface WEPersonalAddressEditViewController : WECustomNavButtonViewController

@property(nonatomic, strong) WEAddress *address;
@property(nonatomic, strong) UIViewController *parentController;
@end