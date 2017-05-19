//
//  WECardTypeCheckView.m
//  woeat
//
//  Created by liubin on 17/3/16.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WECardTypeCheckView.h"

#define TAG_START_BUTTON  100
#define TAG_START_CIRCLE  200

#define HEIGHT  45
#define WIDTH  70


@interface WECardTypeCheckView()
{
    int _selectIndex;
}

@end

@implementation WECardTypeCheckView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView *superView = self;
        
        UIButton *button = [UIButton new];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView.top);
            make.bottom.equalTo(superView.bottom);
            make.left.equalTo(superView.left);
            make.width.equalTo(WIDTH);
        }];
        UIButton *visaButton = button;
        button.tag = TAG_START_BUTTON;
        
        UIImageView *circle = [UIImageView new];
        circle.image = [UIImage imageNamed:@"circle2_select"];
        [superView addSubview:circle];
        [circle makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button.left);
            make.centerY.equalTo(button.centerY);
            make.width.equalTo(15);
            make.height.equalTo(15);
        }];
        circle.tag = TAG_START_CIRCLE;
        
        
        UIImageView *card = [UIImageView new];
        card.image = [UIImage imageNamed:@"visa_logo"];
        CGSize size = card.image.size;
        float width = size.width * HEIGHT / size.height;
        [superView addSubview:card];
        [card makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.top);
            make.bottom.equalTo(button.bottom);
            make.left.equalTo(circle.right).offset(12);
            make.width.equalTo(width);
        }];

        button = [UIButton new];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:button];
        [button makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView.top);
            make.bottom.equalTo(superView.bottom);
            make.left.equalTo(visaButton.right).offset(50);
            make.width.equalTo(WIDTH);
        }];
        button.tag = TAG_START_BUTTON+1;
        
        circle = [UIImageView new];
        circle.image = [UIImage imageNamed:@"circle2_normal"];
        [superView addSubview:circle];
        [circle makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button.left);
            make.centerY.equalTo(button.centerY);
            make.width.equalTo(15);
            make.height.equalTo(15);
        }];
        circle.tag = TAG_START_CIRCLE+1;
        
        card = [UIImageView new];
        card.image = [UIImage imageNamed:@"master_logo"];
        size = card.image.size;
        width = size.width * HEIGHT / size.height;
        [superView addSubview:card];
        [card makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.top);
            make.bottom.equalTo(button.bottom);
            make.left.equalTo(circle.right).offset(12);
            make.width.equalTo(width);
        }];
    }
    
    return self;
    
}

- (float)getHeight
{
    return HEIGHT;
}

- (void)buttonTapped:(UIButton *)button
{
    if (button.tag == TAG_START_BUTTON) {
        _selectIndex = 0;
        UIImageView *imgView = (UIImageView *)[self viewWithTag:TAG_START_CIRCLE];
        imgView.image = [UIImage imageNamed:@"circle2_select"];
        
        imgView = (UIImageView *)[self viewWithTag:TAG_START_CIRCLE+1];
        imgView.image = [UIImage imageNamed:@"circle2_normal"];

    } else if (button.tag == TAG_START_BUTTON+1) {
        _selectIndex = 1;
        UIImageView *imgView = (UIImageView *)[self viewWithTag:TAG_START_CIRCLE];
        imgView.image = [UIImage imageNamed:@"circle2_normal"];
        
        imgView = (UIImageView *)[self viewWithTag:TAG_START_CIRCLE+1];
        imgView.image = [UIImage imageNamed:@"circle2_select"];
        
    }
    
}

- (int)getSelectedIndex
{
    return _selectIndex;
}

@end
