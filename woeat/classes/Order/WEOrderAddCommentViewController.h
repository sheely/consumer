//
//  WEOrderAddCommentViewController.h
//  woeat
//
//  Created by liubin on 16/11/17.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WECustomNavButtonViewController.h"

@class WEModelOrder;
@class WEModelGetConsumerKitchen;
@interface WEOrderAddCommentViewController : WECustomNavButtonViewController

@property(nonatomic, strong) WEModelOrder *order;
@property(nonatomic, strong) WEModelGetConsumerKitchen *kitchenInfo;
@end
