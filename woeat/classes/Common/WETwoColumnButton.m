//
//  WETwoColumnButton.m
//  woeat
//
//  Created by liubin on 17/1/11.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WETwoColumnButton.h"

@interface WETwoColumnButton()
@property(nonatomic, strong, readwrite) UILabel *leftLabel;
@property(nonatomic, strong, readwrite) UILabel *rightLabel;
@end

@implementation WETwoColumnButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView *superView = self;
        
        float rightWidth = 50;
        UILabel *label = [UILabel new];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UICOLOR(0,0,0);
        [superView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left);
            make.right.equalTo(superView.right).offset(-rightWidth);
            make.top.equalTo(superView.top);
            make.bottom.equalTo(superView.bottom);
        }];
        _leftLabel = label;
        
        label = [UILabel new];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UICOLOR(0,0,0);
        [superView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.right);
            make.width.equalTo(rightWidth);
            make.top.equalTo(superView.top);
            make.bottom.equalTo(superView.bottom);
        }];
        _rightLabel = label;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
