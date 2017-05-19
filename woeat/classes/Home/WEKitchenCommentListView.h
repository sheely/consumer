//
//  WEKitchenCommentListView.h
//  woeat
//
//  Created by liubin on 17/1/14.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEKitchenCommentListView : UIView

@property(nonatomic, assign) UIScrollView *parentScrollView;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSString *kitchenId;

- (BOOL)loadDataIfNeeded;
@end
