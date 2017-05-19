//
//  WEBankCardUpdateViewController.h
//  woeat
//
//  Created by liubin on 17/3/31.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WECustomNavButtonViewController.h"

@class WEModelGetMyCardListCardList;
@interface WEBankCardUpdateViewController : WECustomNavButtonViewController

@property(nonatomic, strong) WEModelGetMyCardListCardList *model;
@end
