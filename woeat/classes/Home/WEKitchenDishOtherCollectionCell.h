//
//  WEKitchenDishOtherCollectionCell.h
//  woeat
//
//  Created by liubin on 17/1/17.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEKitchenDishOtherCollectionCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *imgView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *amountLabel;
@property(nonatomic, strong) UIButton *addButton;
@end
