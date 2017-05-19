//
//  WEShoppingCartCell.m
//  woeat
//
//  Created by liubin on 16/12/14.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEShoppingCartCell.h"
#import "WEUtil.h"

@implementation WEShoppingCartCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = UICOLOR(197, 197, 197);
    
    
    UIView *superView = self.contentView;
    
    float offset = COND_WIDTH_320(15, 10);
    UILabel *name = [UILabel new];
    name.numberOfLines = 1;
    name.textAlignment = NSTextAlignmentLeft;
    name.font = [UIFont systemFontOfSize:13];
    name.textColor = [UIColor blackColor];
    [superView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offset);
        make.width.equalTo(200);
        make.centerY.equalTo(superView.centerY);
        make.height.equalTo(superView.height);
    }];
    _dishNameLabel = name;
    
    UILabel *money = [UILabel new];
    money.numberOfLines = 1;
    money.textAlignment = NSTextAlignmentRight;
    money.font = [UIFont systemFontOfSize:13];
    money.textColor = [UIColor blackColor];
    [superView addSubview:money];
    [money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(100);
        make.right.equalTo(superView.right).offset(-[WEUtil getScreenWidth]*0.35);
        make.centerY.equalTo(superView.centerY);
        make.height.equalTo(superView.height);
    }];
    _moneyLabel = money;
    
    UIImage *minusImg = [UIImage imageNamed:@"icon_minus"];
    UIImage *addImg = [UIImage imageNamed:@"icon_plus"];
    UIButton *add = [UIButton new];
    [add setBackgroundImage:addImg forState:UIControlStateNormal];
    [superView addSubview:add];
    [add mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-offset);
        make.width.equalTo(minusImg.size.width);
        make.height.equalTo(minusImg.size.height);
        make.centerY.equalTo(superView.centerY);
    }];
    _addButton = add;
    
    UILabel *count = [UILabel new];
    count.numberOfLines = 1;
    count.textAlignment = NSTextAlignmentCenter;
    count.font = [UIFont systemFontOfSize:13];
    count.textColor = [UIColor blackColor];
    [superView addSubview:count];
    [count mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(30);
        make.right.equalTo(add.left);
        make.centerY.equalTo(superView.centerY);
        make.height.equalTo(superView.height);
    }];
    _countLabel = count;
    
    
    UIButton *minus = [UIButton new];
    [minus setBackgroundImage:minusImg forState:UIControlStateNormal];
    [superView addSubview:minus];
    [minus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(count.left);
        make.width.equalTo(minusImg.size.width);
        make.height.equalTo(minusImg.size.height);
        make.centerY.equalTo(superView.centerY);
    }];
    _minusButton = minus;
    
    return self;
}
@end
