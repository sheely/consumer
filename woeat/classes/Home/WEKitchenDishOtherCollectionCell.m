//
//  WEKitchenDishOtherCollectionCell.m
//  woeat
//
//  Created by liubin on 17/1/17.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WEKitchenDishOtherCollectionCell.h"


#define COLLECTION_CELL_IMAGE_INSET 2





@implementation WEKitchenDishOtherCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *superView = self.contentView;
        
        UIView *imgBg = [UIView new];
        imgBg.backgroundColor = [UIColor clearColor];
        imgBg.layer.borderWidth = 1;
        imgBg.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [superView addSubview:imgBg];
        [imgBg makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView.top);
            make.left.equalTo(superView.left);
            make.right.equalTo(superView.right);
            make.height.equalTo(self.width);
        }];
        
        float inset = COLLECTION_CELL_IMAGE_INSET;
        UIImageView *imgView = [UIImageView new];
        imgView.backgroundColor = [UIColor grayColor];
        [superView addSubview:imgView];
        [imgView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgBg.top).offset(inset);
            make.left.equalTo(imgBg.left).offset(inset);
            make.right.equalTo(imgBg.right).offset(-inset);
            make.bottom.equalTo(imgBg.bottom).offset(-inset);
        }];
        _imgView = imgView;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [superView addSubview:titleLabel];
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgBg.bottom).offset(5);
            make.left.equalTo(imgBg.left).offset(0);
            make.right.equalTo(superView.right).offset(-50);
            make.height.equalTo(titleLabel.font.pointSize+1);
        }];
        _nameLabel = titleLabel;
        
        UILabel *priceLabel = [UILabel new];
        priceLabel.textColor = DARK_ORANGE_COLOR;
        priceLabel.font = [UIFont systemFontOfSize:14];
        priceLabel.textAlignment = NSTextAlignmentRight;
        [superView addSubview:priceLabel];
        [priceLabel sizeToFit];
        [priceLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel.centerY).offset(0);
            make.right.equalTo(imgBg.right).offset(0);
        }];
        _priceLabel = priceLabel;
        
        UILabel *amountLabel = [UILabel new];
        amountLabel.textColor = [UIColor grayColor];
        amountLabel.font = [UIFont systemFontOfSize:14];
        amountLabel.textAlignment = NSTextAlignmentLeft;
        [superView addSubview:amountLabel];
        [amountLabel sizeToFit];
        [amountLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.bottom).offset(10);
            make.left.equalTo(_nameLabel.left);
        }];
        _amountLabel = amountLabel;
        
        UIImage *addImg = [UIImage imageNamed:@"icon_plus"];
        UIButton *addButton = [UIButton new];
        [addButton setBackgroundImage:addImg forState:UIControlStateNormal];
        [superView addSubview:addButton];
        [addButton makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_amountLabel.centerY);
            make.right.equalTo(_priceLabel.right);
            make.width.equalTo(addImg.size.width*0.8);
            make.height.equalTo(addImg.size.height*0.8);
        }];
        _addButton = addButton;
    }
    return self;
}

@end
