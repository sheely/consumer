//
//  WETwoLineListView.m
//  woeat
//
//  Created by liubin on 16/11/4.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WETwoLineListView.h"
#import "WEUtil.h"

@interface WETwoLineListView()
{
    int _total;
    float _totalWidth;
    float _totalHeight;
}
@end

@implementation WETwoLineListView
- (void)setUpText:(NSArray *)ups downText:(NSArray *)downs
{
    _total = ups.count;
    _totalWidth = 0;
    _totalHeight = 0;
    
    UIView *superView = self;
    for(UIView *v in superView.subviews) {
        [v removeFromSuperview];
    }
    
    UIView *lastView = nil;
    for(int i=0; i<_total; i++) {
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
                make.left.equalTo(lastView.right).offset(_leftPadding);
            } else {
                make.left.equalTo(superView.left).offset(_leftPadding);
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

        _totalWidth += _leftPadding + w + _rightPadding;
        float total = _topPadding + upSize.height + _middleYPadding + downSize.height + _bottomPadding;
        if (_totalHeight < total) {
            _totalHeight = total;
        }
        lastView = downLabel;
        if (i < _total-1) {
            UIView *line = [UIView new];
            line.backgroundColor = _lineColor;
            [superView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.right).offset(_rightPadding);
                make.top.equalTo(superView.top);
                make.bottom.equalTo(superView.bottom);
                make.width.equalTo(_lineWidth);
            }];
            
            lastView = line;
            _totalWidth += _lineWidth;
        }
    }
    
}

- (CGFloat)getWidth
{
    return _totalWidth;
}

- (CGFloat)getHeight
{
    return _totalHeight;
}
@end
