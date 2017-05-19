//
//  WELeftTextField.m
//  woeat
//
//  Created by liubin on 17/3/16.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WELeftTextField.h"

@interface WELeftTextField()
{
    UILabel *_leftLabe;
}

@end


@implementation WELeftTextField

- (instancetype)initWithLeftText:(NSString *)leftText
{
    self = [super init];
    if (self) {
        //MM
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor blackColor];
        label.text = leftText;
        label.frame = CGRectMake(0, 0, 30, 20);
        self.leftView = label;
        self.leftViewMode = UITextFieldViewModeAlways;
        _leftLabe = label;
    }
    return self;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 15; //像右边偏15
    return iconRect;
}

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectMake(bounds.origin.x+45, bounds.origin.y, bounds.size.width-45,bounds.size.height);
    
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.origin.x+45, bounds.origin.y, bounds.size.width-45,bounds.size.height);
}

@end
