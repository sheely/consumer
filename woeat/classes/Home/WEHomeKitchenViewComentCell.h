//
//  WEHomeKitchenViewComentCell.h
//  woeat
//
//  Created by liubin on 16/10/23.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEModelGetCommentList.h"

@interface WEHomeKitchenViewComentCell : UITableViewCell


+ (float)getHeightWithModel:(WEModelGetCommentListCommentList *)model;


- (void)setModel:(WEModelGetCommentListCommentList *)model;
@end
