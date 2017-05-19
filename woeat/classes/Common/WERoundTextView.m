//
//  WERoundTextView.m
//  woeat
//
//  Created by liubin on 16/10/21.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WERoundTextView.h"
#import "YYKit.h"

@interface  WERoundTextView()
{
    float _featureHeight;
    float _featureWidth;
}
@end

@implementation WERoundTextView

//- (void)setString:(NSString *)text
//{
//    self.backgroundColor = [UIColor blueColor];
//    UIView *superView = self;
//    for(UIView *v in superView.subviews) {
//        [v removeFromSuperview];
//    }
//    
//    UIEdgeInsets insets = UIEdgeInsetsMake(-5, -11, -5, -11);
//    if (_inset.bottom) {
//        insets = _inset;
//    }
//    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:text];
//    [text1 insertString:@"    " atIndex:0];
//    [text1 appendString:@"    "];
//    text1.font = [UIFont systemFontOfSize:13];
//    if (_font) {
//        text1.font = _font;
//    }
//    text1.color = [UIColor whiteColor];
//    YYTextBorder *border = [YYTextBorder new];
//    border.fillColor = _textBgColor;
//    border.cornerRadius = 6;
//    if (_radius) {
//        border.cornerRadius = _radius;
//    }
//    border.lineJoin = kCGLineJoinBevel;
//    border.insets = insets;
//    [text1 setTextBackgroundBorder:border range:[text1.string rangeOfString:text]];
//    text1.lineSpacing = 10;
//    text1.lineBreakMode = NSLineBreakByWordWrapping;
//    YYLabel *flavour = [YYLabel new];
//    flavour.attributedText = text1;
//    flavour.numberOfLines = 1;
//    [superView addSubview:flavour];
//    [flavour mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(superView.left).offset(-3);
//        make.right.equalTo(superView.right).offset(0);
//        make.top.equalTo(superView.top).offset(0);
//        make.bottom.equalTo(superView.bottom).offset(0);
//    }];
//    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName : text1.font}];
//    
//    _featureWidth = -insets.left + size.width - insets.right + 3;
//    _featureHeight = -insets.top + size.height - insets.bottom;
//    flavour.yy_size = CGSizeMake(_featureWidth, _featureHeight);
//}

- (void)setString:(NSString *)text
{
    UIColor *textColor;
    if (_onlyBorder) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 1;
        self.layer.borderColor = _textBgColor.CGColor;
        textColor = _textBgColor;
    } else {
        self.backgroundColor = _textBgColor;
        textColor = [UIColor whiteColor];

    }
    
    UIView *superView = self;
    for(UIView *v in superView.subviews) {
        [v removeFromSuperview];
    }
    
    UIEdgeInsets insets = UIEdgeInsetsMake(-5, -11, -5, -11);
    if (_textInset.bottom) {
        insets = _textInset;
    }
    
    float radius = MIN(-insets.top, -insets.left);
    if (_cornerRadius) {
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius = _cornerRadius;
    }
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:13];
    if (_textFont) {
        label.font = _textFont;
    }
    label.textColor = textColor;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    [superView addSubview:label];
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName : label.font}];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.equalTo(-insets.left);
        //make.top.equalTo(-insets.top);
        make.centerX.equalTo(superView.centerX);
        make.centerY.equalTo(superView.centerY);
        make.width.equalTo(size.width+4);
        make.height.equalTo(size.height);
    }];
    
    _featureWidth = -insets.left + size.width - insets.right;
    _featureHeight = -insets.top + size.height - insets.bottom;
}


- (float)getHeight
{
    return _featureHeight;
}

- (float)getWidth
{
    return _featureWidth;
}

- (void)setTextBgColor:(UIColor *)textBgColor
{
    _textBgColor = textBgColor;
    self.backgroundColor = _textBgColor;
}


@end
