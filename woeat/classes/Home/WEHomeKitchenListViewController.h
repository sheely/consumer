//
//  WEHomeKitchenListViewController.h
//  woeat
//
//  Created by liubin on 16/10/14.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WEPullDownRefreshTableView.h"

@interface WEHomeKitchenListViewController : UIViewController

@property(nonatomic, weak) NSMutableArray *dataArray;
@property(nonatomic, weak) UITableView *tableView;
@end
