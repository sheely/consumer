//
//  WETwoColumnListView.m
//  woeat
//
//  Created by liubin on 16/11/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WETwoColumnListView.h"

@interface WETwoColumnListView()
{
    int _rows;
    float _totalHeight;
}
@end


@implementation WETwoColumnListView

- (void)setUpLeftText:(NSArray *)lefts rightText:(NSArray *)rights
{
    _rows = lefts.count;
    _totalHeight = 0;
    
    UIView *superView = self;
    for(UIView *v in superView.subviews) {
        [v removeFromSuperview];
    }
    
    UIView *lastRow = superView;
    for(int i=0; i<_rows; i++) {
        NSString *left = lefts[i];
        NSString *right = rights[i];
        
        UILabel *leftLabel = [UILabel new];
        leftLabel.text = left;
        leftLabel.font = _font;
        leftLabel.textColor = _color;
        leftLabel.textAlignment = NSTextAlignmentRight;
        [superView addSubview:leftLabel];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left);
            make.right.equalTo(superView.left).offset(_maxWidth/2 - _middleSpace/2);
            if (i == 0) {
                make.top.equalTo(superView.top).offset(0);
            } else if (i == _rows-1){
                make.top.equalTo(lastRow.bottom).offset(_vSpaceLine);
            } else {
                make.top.equalTo(lastRow.bottom).offset(_vSpace);
            }
            make.height.equalTo(_font.pointSize+1);
        }];
        
        UILabel *rightLabel = [UILabel new];
        rightLabel.text = right;
        rightLabel.font = _font;
        rightLabel.textColor = _color;
        rightLabel.textAlignment = NSTextAlignmentRight;
        [superView addSubview:rightLabel];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(_maxWidth/2 + _middleSpace/2);
            make.right.equalTo(superView.right);
            make.centerY.equalTo(leftLabel.centerY);
        }];
        
        lastRow = leftLabel;
        if (i == _rows - 2) {
            UIView *line = [UIView new];
            line.backgroundColor = [UIColor lightGrayColor];
            [superView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(superView.left);
                make.right.equalTo(superView.right);
                make.top.equalTo(lastRow.bottom).offset(_vSpaceLine);
                make.height.equalTo(0.5);
            }];
            
            lastRow = line;
        }
    }
    
}

- (CGFloat)getHeight
{
    if (_rows >= 2) {
        _totalHeight = _rows * (_font.pointSize+1) + (_rows-2) * _vSpace + 2 * _vSpaceLine;
    } else {
        _totalHeight = _rows * (_font.pointSize+1);
    }
    return _totalHeight;
}

@end
