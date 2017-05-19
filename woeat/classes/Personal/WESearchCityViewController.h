//
//  WESearchCityViewController.h
//  woeat
//
//  Created by liubin on 16/12/22.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WECity;
@class WEState;

@protocol WESearchCityViewControllerDelegate <NSObject>
@optional
- (void)userSelecteState:(WEState *)state;
- (void)userSelecteCity:(WECity *)city;
@end

@interface WESearchCityViewController : UIViewController

@property(nonatomic, assign) int stateId;
@property(nonatomic, weak) id<WESearchCityViewControllerDelegate> searchDelegate;
@end
