//
//  WEBottomStatusBar.m
//  woeat
//
//  Created by liubin on 16/11/7.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEBottomStatusBar.h"
#import "WEUtil.h"


@interface WEBottomStatusBar()
{

}
@property(nonatomic, strong, readwrite) UILabel *leftLabel;
@property(nonatomic, strong, readwrite) UILabel *middleLabel;
@property(nonatomic, strong, readwrite) UIButton *rightButton;

@end

@implementation WEBottomStatusBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIView *superView = self;
        
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = DARK_ORANGE_COLOR;
        [superView addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(superView.bottom);
            make.left.equalTo(superView.left);
            make.right.equalTo(superView.right);
            make.height.equalTo(40);
        }];
        
        superView = bottomView;
        UILabel *leftLabel = [UILabel new];
        leftLabel.numberOfLines = 1;
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.font = [UIFont systemFontOfSize:13];
        leftLabel.textColor = UICOLOR(193, 193, 193);
        [superView addSubview:leftLabel];
        [leftLabel sizeToFit];
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(superView.centerY);
            make.left.equalTo(superView.left).offset(20);
        }];
        _leftLabel = leftLabel;
        
        UILabel *middleLabel = [UILabel new];
        middleLabel.numberOfLines = 1;
        middleLabel.textAlignment = NSTextAlignmentCenter;
        middleLabel.font = [UIFont systemFontOfSize:13];
        middleLabel.textColor = UICOLOR(193, 193, 193);
        [superView addSubview:middleLabel];
        [middleLabel sizeToFit];
        [middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(superView.centerY);
            make.centerX.equalTo(superView.centerX);
            make.left.equalTo(superView.left).offset(10);
            make.right.equalTo(superView.right).offset(-10);
        }];
        _middleLabel = middleLabel;
        
        UIButton *rightButton = [UIButton new];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        rightButton.contentEdgeInsets = UIEdgeInsetsMake(0,0, 0, 0);
        rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [superView addSubview:rightButton];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.right).offset(-20);
            make.left.equalTo(superView.left).offset(100);
            make.top.equalTo(superView.top);
            make.bottom.equalTo(superView.bottom);
        }];
        _rightButton = rightButton;
    }
    return self;
}

- (float)getHeight
{
    return 40;
}

- (void)updateTotalHeight
{
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo( [self getHeight] );
    }];
}

- (void)setStatusBarType:(WEBottomStatusBarType)statusBarType
{
    _statusBarType = statusBarType;
    if (_statusBarType == WEBottomStatusBarType_OneLine) {
        _leftLabel.hidden = YES;
        _rightButton.hidden = YES;
        _middleLabel.hidden = NO;
    
    } else if (_statusBarType == WEBottomStatusBarType_Order) {
        _leftLabel.hidden = NO;
        _rightButton.hidden = NO;
        _middleLabel.hidden = YES;
        
    }
}

@end
