//
//  WETwoLineListWideView.m
//  woeat
//
//  Created by liubin on 16/11/26.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WETwoLineListWideView.h"
#import "WEUtil.h"

@interface WETwoLineListWideView()
{
    int _count;
    float _totalHeight;
}
@end

@implementation WETwoLineListWideView

- (void)setUpText:(NSArray *)ups downText:(NSArray *)downs
{
    _count = ups.count;
    _totalHeight = 0;
    _buttons = [NSMutableArray arrayWithCapacity:_count];
    NSMutableArray *lines = [NSMutableArray arrayWithCapacity:_count];
    
    UIView *superView = self;
    for(UIView *v in superView.subviews) {
        [v removeFromSuperview];
    }
    
    float width = 0;
    for(int i=0; i<_count; i++) {
        NSString *up = ups[i];
        NSString *down = downs[i];
        CGSize upSize = [WEUtil oneLineSizeForTitle:up font:_upFont];
        CGSize downSize = [WEUtil oneLineSizeForTitle:down font:_downFont];
        float w = MAX(upSize.width, downSize.width);
        width += w;
    }
    float padding = (_totalWidth - width - _leftPadding - _rightPadding - _lineWidth * (_count-1));
    padding /= (_count * 2);
    
    UIView *lastView = nil;
    for(int i=0; i<_count; i++) {
        NSString *up = ups[i];
        NSString *down = downs[i];
        CGSize upSize = [WEUtil oneLineSizeForTitle:up font:_upFont];
        CGSize downSize = [WEUtil oneLineSizeForTitle:down font:_downFont];
        float w = MAX(upSize.width, downSize.width);
        
        UILabel *upLabel = [UILabel new];
        upLabel.text = up;
        upLabel.font = _upFont;
        upLabel.textColor = _upColor;
        upLabel.textAlignment = NSTextAlignmentCenter;
        [superView addSubview:upLabel];
        [upLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.equalTo(lastView.right).offset(padding);
            } else {
                make.left.equalTo(superView.left).offset(_leftPadding+padding);
            }
            make.top.equalTo(superView.top).offset(_topPadding);
            make.width.equalTo(w);
            make.height.equalTo(upSize.height);
        }];
        
        UILabel *downLabel = [UILabel new];
        downLabel.text = down;
        downLabel.font = _downFont;
        downLabel.textColor = _downColor;
        downLabel.textAlignment = NSTextAlignmentCenter;
        [superView addSubview:downLabel];
        [downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(upLabel.left);
            make.right.equalTo(upLabel.right);
            make.top.equalTo(upLabel.bottom).offset(_middleYPadding);
            make.width.equalTo(w);
            make.height.equalTo(downSize.height);
        }];
        
        float total = _topPadding + upSize.height + _middleYPadding + downSize.height + _bottomPadding;
        if (_totalHeight < total) {
            _totalHeight = total;
        }
        lastView = downLabel;
        if (i < _count -1) {
            UIView *line = [UIView new];
            line.backgroundColor = _lineColor;
            [superView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.right).offset(padding);
                make.centerY.equalTo(superView.centerY).offset((_topPadding - _bottomPadding)/2);
                make.height.equalTo(_lineHeight);
                make.width.equalTo(_lineWidth);
            }];
            
            lastView = line;
            [lines addObject:line];
        }
    }
    
    for(int i=0; i<=lines.count; i++) {
        UIView *left = nil;
        UIView *right = nil;
        if (i == 0) {
            left = superView;
        } else {
            UIView *line = [lines objectAtIndex:i-1];
            left = line;
        }
        if (i == lines.count) {
            right = superView;
        } else {
            UIView *line = [lines objectAtIndex:i];
            right = line;
        }
        
        UIButton *button = [UIButton new];
        [superView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(left.left);
            make.right.equalTo(right.right);
            make.top.equalTo(superView.top);
            make.bottom.equalTo(superView.bottom);
        }];
        [_buttons addObject:button];
    }
}


- (CGFloat)getHeight
{
    return _totalHeight;
}


@end
