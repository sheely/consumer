//
//  WESearchCityCell.m
//  woeat
//
//  Created by liubin on 16/12/22.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WESearchCityCell.h"

@implementation WESearchCityCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = [UIColor clearColor];
    
    
    UIView *superView = self.contentView;
    
    float offsetX = 25;
    UILabel *name = [UILabel new];
    name.numberOfLines = 1;
    name.textAlignment = NSTextAlignmentLeft;
    name.font = [UIFont systemFontOfSize:15];
    name.textColor = [UIColor blackColor];
    [superView addSubview:name];
    [name sizeToFit];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(20);
        make.top.equalTo(superView.top).offset(15);
    }];
    _leftLabel = name;
    
    UILabel *amount = [UILabel new];
    amount.numberOfLines = 1;
    amount.textAlignment = NSTextAlignmentRight;
    amount.font = [UIFont boldSystemFontOfSize:15];
    amount.textColor = UICOLOR(68, 68, 68);
    [superView addSubview:amount];
    [amount sizeToFit];
    [amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-15);
        make.bottom.equalTo(superView.bottom).offset(-8);
    }];
    _rightLabel = amount;
    
    return self;
}

@end
