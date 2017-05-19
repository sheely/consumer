//
//  WEKitchenStoryDishCollectionCell.m
//  woeat
//
//  Created by liubin on 17/1/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WEKitchenStoryDishCollectionCell.h"

#define COLLECTION_CELL_IMAGE_INSET 2
#define COLLECTION_CELL_WIDTH  70
#define COLLECTION_CELL_HEIGHT 100



@implementation WEKitchenStoryDishCollectionCell
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
            make.height.equalTo(COLLECTION_CELL_WIDTH);
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
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [superView addSubview:titleLabel];
        [titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgBg.bottom).offset(5);
            make.left.equalTo(imgBg.left).offset(0);
            make.right.equalTo(imgBg.right).offset(0);
            make.bottom.equalTo(superView.bottom).offset(0);
        }];
        _titleLabel = titleLabel;
        
    }
    return self;
}

@end


@implementation WEKitchenStoryDishCollectionCellFooter

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *superView = self;
        
        UIButton *button = [UIButton new];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [superView addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView.top).offset(0);
            make.left.equalTo(superView.left).offset(0);
            make.right.equalTo(superView.right).offset(0);
            make.bottom.equalTo(superView.bottom).offset(0);
        }];
        _button = button;
        
    }
    return self;
}

@end

