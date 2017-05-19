//
//  WEOrderDishCell.m
//  woeat
//
//  Created by liubin on 16/11/17.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEOrderDishCell.h"
#import "WEUtil.h"
#import "WEModelOrder.h"

@interface WEOrderDishCell()
{
    UILabel *_name;
    UILabel *_amount;
    UILabel *_price;
}
@end

@implementation WEOrderDishCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = [UIColor clearColor];
    
    
    UIView *superView = self.contentView;
    
    float offsetX = 15;
    UILabel *name = [UILabel new];
    name.numberOfLines = 1;
    name.textAlignment = NSTextAlignmentLeft;
    name.font = [UIFont systemFontOfSize:13];
    name.textColor = [UIColor blackColor];
    //name.text = @"锅包肉";
    [superView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.width.equalTo(100);
        make.top.equalTo(superView.top);
        make.bottom.equalTo(superView.bottom);
    }];
    _name = name;
   
    UILabel *amount = [UILabel new];
    amount.numberOfLines = 1;
    amount.textAlignment = NSTextAlignmentLeft;
    amount.font = [UIFont systemFontOfSize:13];
    amount.textColor = [UIColor blackColor];
    //amount.text = @"x 1";
    [superView addSubview:amount];
    [amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset([WEUtil getScreenWidth]*0.65);
        make.width.equalTo(50);
        make.top.equalTo(superView.top);
        make.bottom.equalTo(superView.bottom);
    }];
    _amount = amount;

    UILabel *price = [UILabel new];
    price.numberOfLines = 1;
    price.textAlignment = NSTextAlignmentRight;
    price.font = [UIFont systemFontOfSize:13];
    price.textColor = [UIColor blackColor];
    //price.text = @"$30.00";
    [superView addSubview:price];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-offsetX);
        make.width.equalTo(50);
        make.top.equalTo(superView.top);
        make.bottom.equalTo(superView.bottom);
    }];
    _price = price;
    
    return self;
}

- (void)setModel:(WEModelOrderLines *)model
{
    _model = model;
    if ([_model.LineType isEqualToString:@"ITEM"]) {
        _name.text = _model.Name;
        _amount.text = [NSString stringWithFormat:@"x %d", _model.Quantity];
        _price.text = [NSString stringWithFormat:@"$%.2f", _model.UnitPrice * _model.Quantity];
        
    } else if ([_model.LineType isEqualToString:@"COUPON"]){
        _name.text = @"优惠券";
        _amount.text = [NSString stringWithFormat:@"x %d", _model.Quantity];
        _price.text = [NSString stringWithFormat:@"-$%.2f", _model.UnitPrice * _model.Quantity];
    }
}
@end
