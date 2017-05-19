//
//  WEPersonalCommentCell.h
//  woeat
//
//  Created by liubin on 17/1/3.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WEModelGetCommentListCommentList;
@interface WEPersonalCommentCell : UITableViewCell

-(void)setModel:(WEModelGetCommentListCommentList *)model;
+ (float)getHeightWithModel:(WEModelGetCommentListCommentList *)model;
@end
