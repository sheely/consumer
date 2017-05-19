//
//  WECouponListCell.m
//  woeat
//
//  Created by liubin on 16/11/30.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WECouponListCell.h"
#import "WEModelGetMyRedeemableCoupon.h"

@interface WECouponListCell()
{
    UILabel *_name;
    UILabel *_condition;
    UILabel *_amount;
    MASConstraint *_rightBgConstraint;
    UIImageView *_check;
}
@end


@implementation WECouponListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = [UIColor clearColor];
    
    
    UIView *superView = self.contentView;
    
    float offsetX = 25;
    UIView *bg = [UIView new];
    bg.backgroundColor = [UIColor clearColor];
    bg.layer.borderWidth = 1;
    bg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bg.layer.cornerRadius = 5;
    bg.layer.masksToBounds=YES;
    bg.clipsToBounds = YES;
    [superView addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        _rightBgConstraint = make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(superView.top);
        make.bottom.equalTo(superView.bottom).offset(-20);
    }];

    superView = bg;
    UIView *topBg = [UIView new];
    topBg.backgroundColor = DARK_ORANGE_COLOR;
    [superView addSubview:topBg];
    [topBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bg.left);
        make.right.equalTo(bg.right);
        make.top.equalTo(superView.top);
    }];
    
    UILabel *name = [UILabel new];
    name.numberOfLines = 1;
    name.textAlignment = NSTextAlignmentLeft;
    name.font = [UIFont systemFontOfSize:15];
    name.textColor = [UIColor whiteColor];
    [superView addSubview:name];
    [name sizeToFit];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(20);
        make.top.equalTo(superView.top).offset(15);
    }];
    _name = name;
    
    UILabel *condition = [UILabel new];
    condition.numberOfLines = 1;
    condition.textAlignment = NSTextAlignmentLeft;
    condition.font = [UIFont systemFontOfSize:13];
    condition.textColor = [UIColor lightGrayColor];
    [superView addSubview:condition];
    [condition sizeToFit];
    [condition mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.left);
        make.top.equalTo(name.bottom).offset(8);
        make.bottom.equalTo(topBg.bottom).offset(-12);
    }];
    _condition = condition;
    
    UILabel *amount = [UILabel new];
    amount.numberOfLines = 1;
    amount.textAlignment = NSTextAlignmentRight;
    amount.font = [UIFont boldSystemFontOfSize:33];
    amount.textColor = DARK_ORANGE_COLOR;
    [superView addSubview:amount];
    [amount sizeToFit];
    [amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-15);
        make.bottom.equalTo(superView.bottom).offset(-8);
    }];
    _amount = amount;
    
    superView = self.contentView;
    UIImageView *check = [UIImageView new];
    check.image = [UIImage imageNamed:@"circle_check"];
    [superView addSubview:check];
    [check mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-15);
        make.centerY.equalTo(superView.centerY);
        make.width.equalTo(check.image.size.width);
        make.height.equalTo(check.image.size.height);
    }];
    _check = check;
    _check.hidden = YES;
    
    return self;
}


-(void)setModel:(WEModelGetMyRedeemableCouponUserCouponList *)model
{
    _name.text = model.RuleName;
    _condition.text = model.RuleConditionDescription;
    _amount.text = model.RuleValueDescription;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _rightBgConstraint.offset(-55);
    _check.hidden = NO;
    if (isSelected) {
        _check.image = [UIImage imageNamed:@"circle_check"];
    } else {
        _check.image = [UIImage imageNamed:@"circle_uncheck"];
    }
}

@end
