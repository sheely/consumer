//
//  WEBankCardListCell.m
//  woeat
//
//  Created by liubin on 17/3/15.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WEBankCardListCell.h"



@interface WEBankCardListCell()
{
    UILabel *_name;
    UILabel *_cardNumber;
    UILabel *_defaultMark;
}

@end

@implementation WEBankCardListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = [UIColor clearColor];
    
    
    UIView *superView = self.contentView;
    
    float offsetX = 30;
    float top = 20;
    float bottom = 0;
    
    float radius = 23;
    UIView *shadowBg = [UIView new];
    shadowBg.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    shadowBg.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowBg.layer.shadowOffset = CGSizeMake(0,0.5);
    shadowBg.layer.shadowRadius = 0.5;
    shadowBg.layer.shadowOpacity = 0.5;
    shadowBg.clipsToBounds = NO;
    shadowBg.layer.cornerRadius = radius;
    [superView addSubview:shadowBg];
    [shadowBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(superView.top).offset(top);
        make.bottom.equalTo(superView.bottom).offset(-bottom-shadowBg.layer.shadowRadius);
    }];
    
    UIView *bg = [UIView new];
    bg.backgroundColor = UICOLOR(0xFE, 0x93, 0x37);
    bg.layer.cornerRadius = radius;
    bg.layer.masksToBounds=YES;
    bg.clipsToBounds = YES;
    [superView addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shadowBg.left);
        make.right.equalTo(shadowBg.right);
        make.top.equalTo(shadowBg.top);
        make.bottom.equalTo(shadowBg.bottom).offset(0);
    }];

    superView = bg;
    float bgHeight = CARD_CELL_HEIGHT - top - bottom;
    
    UILabel *name = [UILabel new];
    name.numberOfLines = 1;
    name.textAlignment = NSTextAlignmentCenter;
    name.font = [UIFont systemFontOfSize:20];
    name.textColor = [UIColor whiteColor];
    [superView addSubview:name];
    [name sizeToFit];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.top.equalTo(superView.top).offset(bgHeight*0.28);
    }];
    _name = name;
    
    UILabel *number = [UILabel new];
    number.numberOfLines = 1;
    number.textAlignment = NSTextAlignmentCenter;
    number.font = [UIFont systemFontOfSize:20];
    number.textColor = [UIColor whiteColor];
    [superView addSubview:number];
    [number sizeToFit];
    [number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.top.equalTo(name.bottom).offset(bgHeight*0.1);
    }];
    _cardNumber = number;
    
    float width = 45;
    UILabel *defaultMark = [UILabel new];
    defaultMark.numberOfLines = 1;
    defaultMark.textAlignment = NSTextAlignmentCenter;
    defaultMark.font = [UIFont systemFontOfSize:9];
    defaultMark.textColor = [UIColor whiteColor];
    defaultMark.backgroundColor = UICOLOR(0x9B, 0x9B, 0x9B);
    defaultMark.text = @"默认卡";
    defaultMark.layer.cornerRadius = width/2;
    defaultMark.layer.masksToBounds=YES;
    defaultMark.clipsToBounds = YES;
    [superView addSubview:defaultMark];
    [defaultMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-15);
        make.top.equalTo(superView.top).offset(15);
        make.width.equalTo(width);
        make.height.equalTo(width);
    }];
    _defaultMark = defaultMark;
    return self;
}

- (void)setData:(WEModelGetMyCardListCardList *)model
{
    _name.text = model.Name;
    _cardNumber.text = [NSString stringWithFormat:@"XXXX XXXX XXXX %@", model.MaskedCardNumber];
    _defaultMark.hidden = !model.IsDefault;
}

@end
