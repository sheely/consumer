//
//  WEHomeSearchCell.h
//  woeat
//
//  Created by liubin on 17/1/11.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDishDelegate <NSObject>

- (void)searchDishTapped:(NSString *)itemId kitchen:(NSString *)kitchenId;

@end

@class WEModelWildSearchKitchenList;
@interface WEHomeSearchCell : UITableViewCell

@property(nonatomic, assign) BOOL isFirstCell;
@property(nonatomic, assign) id<SearchDishDelegate> dishDelegate;

- (void)setData:(WEModelWildSearchKitchenList *)data;
+ (float)getHeightWithData:(WEModelWildSearchKitchenList *)data;
@end
