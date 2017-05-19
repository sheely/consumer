//
//  WEPersonalAddressListCellTableViewCell.m
//  woeat
//
//  Created by liubin on 16/11/28.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEPersonalAddressListCellTableViewCell.h"

@interface WEPersonalAddressListCellTableViewCell()
{
    UILabel *_name;
    UILabel *_phone;
    UILabel *_addr1;
    UILabel *_addr2;
    UIImageView *_arrow;
}

@end

@implementation WEPersonalAddressListCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = [UIColor clearColor];
    
    
    UIView *superView = self.contentView;
    
    float offsetX = 30;
    UILabel *name = [UILabel new];
    name.numberOfLines = 1;
    name.textAlignment = NSTextAlignmentLeft;
    name.font = [UIFont systemFontOfSize:13];
    name.textColor = [UIColor blackColor];
    [superView addSubview:name];
    [name sizeToFit];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.top.equalTo(superView.top).offset(15);
    }];
    _name = name;
    
    UILabel *phone = [UILabel new];
    phone.numberOfLines = 1;
    phone.textAlignment = NSTextAlignmentLeft;
    phone.font = [UIFont systemFontOfSize:13];
    phone.textColor = [UIColor lightGrayColor];
    [superView addSubview:phone];
    [phone sizeToFit];
    [phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(name.centerY);
        make.left.equalTo(name.right).offset(30);
    }];
    _phone = phone;
    
    UILabel *addr1 = [UILabel new];
    addr1.numberOfLines = 1;
    addr1.textAlignment = NSTextAlignmentLeft;
    addr1.font = [UIFont systemFontOfSize:13];
    addr1.textColor = [UIColor blackColor];
    [superView addSubview:addr1];
    [addr1 sizeToFit];
    [addr1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.left);
        make.top.equalTo(name.bottom).offset(12);
    }];
    _addr1 = addr1;

    UILabel *addr2 = [UILabel new];
    addr2.numberOfLines = 1;
    addr2.textAlignment = NSTextAlignmentLeft;
    addr2.font = [UIFont systemFontOfSize:13];
    addr2.textColor = [UIColor blackColor];
    [superView addSubview:addr2];
    [addr2 sizeToFit];
    [addr2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.left);
        make.top.equalTo(addr1.bottom).offset(5);
    }];
    _addr2 = addr2;
    
    UIImageView *arrow = [UIImageView new];
    arrow.image = [UIImage imageNamed:@"icon_arrow_gray"];
    [superView addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.right).offset(-offsetX);
        make.centerY.equalTo(superView.centerY);
        make.width.equalTo(arrow.image.size.width);
        make.height.equalTo(arrow.image.size.height);
    }];
    _arrow = arrow;
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lightGrayColor];
    [superView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(0.5);
        make.bottom.equalTo(superView.bottom);
    }];
    return self;
}

- (void)setModel:(WEAddress *)model
{
    _name.text = model.personName;
    _phone.text = model.phone;
    _addr1.text = model.house;
    _addr2.text = [NSString stringWithFormat:@"%@, %@, %@", model.cityName, model.stateName, model.postCode];
}


- (void)setIsSelected:(BOOL)isSelected
{
    UIImage *image;
    if (isSelected) {
        image = [UIImage imageNamed:@"circle_check"];
    } else {
        image = [UIImage imageNamed:@"circle_uncheck"];
    }
    _arrow.image = image;
    [_arrow mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(image.size.width);
        make.height.equalTo(image.size.height);
    }];
}


@end
