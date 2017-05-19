//
//  WEKitchenStoryDishCollectionCell.h
//  woeat
//
//  Created by liubin on 17/1/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEKitchenStoryDishCollectionCell : UICollectionViewCell
@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, weak) UILabel *titleLabel;

@end


@interface  WEKitchenStoryDishCollectionCellFooter : UICollectionReusableView
@property (nonatomic, weak) UIButton *button;
@end
