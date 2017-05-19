//
//  WEPayConfirmView.m
//  woeat
//
//  Created by liubin on 17/3/26.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WEPayConfirmView.h"
#import "WEDistributeSpaceLabel.h"
#import "WEUtil.h"


@interface WEPayConfirmView()
{
    float _total_height;
}

@end


@implementation WEPayConfirmView


-(instancetype)initWithRecharge:(BOOL)forRecharge
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *superView = self;
        
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize size = [WEUtil oneLineSizeForTitle:@"银行卡名称" font:font];
        size.width += 0.5;
        float middleSpace = 10;
        float vSpace = 15;
        
        float iconScale = 0.2;
        UIImageView *icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"icon_eye"];
        [superView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(0);
            make.top.equalTo(superView.top);
            make.height.equalTo(icon.image.size.height*iconScale);
            make.width.equalTo(icon.image.size.width*iconScale);
        }];
        
        UILabel *label = [UILabel new];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:13];
        [superView addSubview:label];
        [label sizeToFit];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.right).offset(5);
            make.centerY.equalTo(icon.centerY);
        }];
         if(forRecharge) {
             label.text = @"请确认以下充值信息是否正确";
         } else {
             label.text = @"请确认以下银行卡信息是否正确";
         }
  
        WEDistributeSpaceLabel *label1 = nil;
        if(forRecharge) {
            label1 = [WEDistributeSpaceLabel new];
            label1.numberOfLines = 1;
            label1.textAlignment = NSTextAlignmentLeft;
            label1.font = font;
            label1.textColor = [UIColor blackColor];
            [label1 setDistributeText:@"充值金额" width:size.width];
            [superView addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(superView.left);
                make.top.equalTo(label.bottom).offset(vSpace+5);
                make.width.equalTo(size.width);
                make.height.equalTo(size.height);
            }];
        }
        
        //持卡人姓名
        UILabel *label2 = [UILabel new];
        label2.numberOfLines = 1;
        label2.textAlignment = NSTextAlignmentLeft;
        label2.font = font;
        label2.textColor = [UIColor blackColor];
        label2.text = @"持卡人姓名";
        [superView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left);
            if (label1) {
                make.top.equalTo(label1.bottom).offset(vSpace);
            } else {
                make.top.equalTo(label.bottom).offset(vSpace+5);
            }
            make.width.equalTo(size.width);
            make.height.equalTo(size.height);
        }];
        
        //信用卡号码
        UILabel *label3 = [UILabel new];
        label3.numberOfLines = 1;
        label3.textAlignment = NSTextAlignmentLeft;
        label3.font = font;
        label3.textColor = [UIColor blackColor];
        label3.text = @"信用卡号码";
        [superView addSubview:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label2.left);
            make.top.equalTo(label2.bottom).offset(vSpace);
            make.width.equalTo(size.width);
            make.height.equalTo(size.height);
        }];
        
        //过期时间
        WEDistributeSpaceLabel *label4 = [WEDistributeSpaceLabel new];
        label4.numberOfLines = 1;
        label4.textAlignment = NSTextAlignmentLeft;
        label4.font = font;
        label4.textColor = [UIColor blackColor];
        [label4 setDistributeText:@"过期时间" width:size.width];
        [superView addSubview:label4];
        [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label3.left);
            make.top.equalTo(label3.bottom).offset(vSpace);
            make.width.equalTo(size.width);
            make.height.equalTo(size.height);
        }];
        
//        //安全码
//        WEDistributeSpaceLabel *label5 = [WEDistributeSpaceLabel new];
//        label5.numberOfLines = 1;
//        label5.textAlignment = NSTextAlignmentLeft;
//        label5.font = font;
//        label5.textColor = [UIColor blackColor];
//        [label5 setDistributeText:@"安全码" width:size.width];
//        [superView addSubview:label5];
//        [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(label4.left);
//            make.top.equalTo(label4.bottom).offset(vSpace);
//            make.width.equalTo(size.width);
//            make.height.equalTo(size.height);
//        }];
        
        //_total_height = size.height * 5 + vSpace * 4;
        if (forRecharge) {
            _total_height = size.height * 5 + vSpace * 4 + 5;
        } else {
            _total_height = size.height * 4 + vSpace * 3 + 5;
        }
        
        UIColor *rightColor = UICOLOR(50,50,50);
        if (forRecharge) {
            //label1
            UILabel *right1 = [UILabel new];
            right1.numberOfLines = 1;
            right1.textAlignment = NSTextAlignmentLeft;
            right1.font = font;
            right1.textColor = rightColor;
            [superView addSubview:right1];
            [right1 sizeToFit];
            [right1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label1.right).offset(middleSpace);
                make.centerY.equalTo(label1.centerY);
            }];
            _right1 = right1;
        }
        
        //label2
        UILabel *right2 = [UILabel new];
        right2.numberOfLines = 1;
        right2.textAlignment = NSTextAlignmentLeft;
        right2.font = font;
        right2.textColor = rightColor;
        [superView addSubview:right2];
        [right2 sizeToFit];
        [right2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label2.right).offset(middleSpace);
            make.centerY.equalTo(label2.centerY);
        }];
        _right2 = right2;
        
        //label3
        UILabel *right3 = [UILabel new];
        right3.numberOfLines = 1;
        right3.textAlignment = NSTextAlignmentLeft;
        right3.font = font;
        right3.textColor = rightColor;
        [superView addSubview:right3];
        [right3 sizeToFit];
        [right3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(right2.left);
            make.centerY.equalTo(label3.centerY);
        }];
        _right3 = right3;
        
        //label4
        UILabel *right4 = [UILabel new];
        right4.numberOfLines = 1;
        right4.textAlignment = NSTextAlignmentLeft;
        right4.font = font;
        right4.textColor = rightColor;
        [superView addSubview:right4];
        [right4 sizeToFit];
        [right4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(right2.left);
            make.centerY.equalTo(label4.centerY);
        }];
        _right4 = right4;
        
//        //label5
//        UILabel *right5 = [UILabel new];
//        right5.numberOfLines = 1;
//        right5.textAlignment = NSTextAlignmentLeft;
//        right5.font = font;
//        right5.textColor = rightColor;
//        [superView addSubview:right5];
//        [right5 sizeToFit];
//        [right5 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(right2.left);
//            make.centerY.equalTo(label5.centerY);
//        }];
//        _right5 = right5;
    }
    return self;
}

- (float)getHeight
{
    return _total_height;
}



@end
