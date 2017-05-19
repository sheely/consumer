//
//  WEOrderPayButton.m
//  woeat
//
//  Created by liubin on 16/11/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEOrderPayButton.h"
#import "WEUtil.h"


@interface WEOrderPayButton()
{
    UILabel *_upTitleLabel;
    UILabel *_bottomTitle1Label;
    UILabel *_bottomTitle2Label;
    UILabel *_rightTitleLabel;
    UIImageView *_arrowImage;
    
    MASConstraint *_topConstraint;
    MASConstraint *_bottomConstraint;
}
@end


@implementation WEOrderPayButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView *superView = self;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds=YES;
        
        float offsetX = 15;
        UILabel *label = [UILabel new];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = [UIColor whiteColor];
        [superView addSubview:label];
        [label sizeToFit];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            _topConstraint = make.top.equalTo(superView.top).offset(20);
        }];
        _upTitleLabel = label;
        
        label = [UILabel new];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        [superView addSubview:label];
        [label sizeToFit];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_upTitleLabel.left);
            _bottomConstraint = make.bottom.equalTo(superView.bottom).offset(-20);
        }];
        _bottomTitle1Label = label;
        
        label = [UILabel new];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        [superView addSubview:label];
        [label sizeToFit];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_bottomTitle1Label.right).offset(15);
            make.centerY.equalTo(_bottomTitle1Label.centerY);
        }];
        _bottomTitle2Label = label;

        UIImageView *arrow = [UIImageView new];
        arrow.image = [UIImage imageNamed:@"icon_arrow_red"];
        [superView addSubview:arrow];
        [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(superView.right).offset(-offsetX);
            make.centerY.equalTo(superView.centerY);
            make.width.equalTo(arrow.image.size.width);
            make.height.equalTo(arrow.image.size.height);
        }];
        _arrowImage = arrow;
        
        label = [UILabel new];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = DARK_ORANGE_COLOR;
        [superView addSubview:label];
        [label sizeToFit];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrow.left).offset(-15);
            make.centerY.equalTo(superView.centerY);
        }];
        _rightTitleLabel = label;
    }
    return self;
}

- (void)setUpTitle:(NSString *)upTitle
{
    _upTitleLabel.text = upTitle;
}

- (void)setBottomTitle1:(NSString *)bottomTitle1
{
    _bottomTitle1Label.text = bottomTitle1;
}

- (void)setBottomTitle2:(NSString *)bottomTitle2
{
    _bottomTitle2Label.text = bottomTitle2;
}

- (void)setRightTitle:(NSString *)rightTitle
{
    _rightTitleLabel.text = rightTitle;
}

- (void)setArrowIsGray:(BOOL)arrowIsGray
{
    if (arrowIsGray) {
        _arrowImage.image = [UIImage imageNamed:@"icon_arrow_gray"];
    } else {
        _arrowImage.image = [UIImage imageNamed:@"icon_arrow_red"];
    }
}

- (void)setBottomTitle1Color:(UIColor *)bottomTitle1Color
{
    _bottomTitle1Label.textColor = bottomTitle1Color;
}

- (void)setHeight:(float)height
{
    if (_bottomTitle1Label.text.length) {
        _topConstraint.equalTo( height * 0.15 );
        _bottomConstraint.equalTo( -height * 0.25 );
        _bottomTitle1Label.hidden = NO;
        _bottomTitle2Label.hidden = NO;
        
    } else {
        _topConstraint.equalTo( height * 0.5 - 8 );
        _bottomTitle1Label.hidden = YES;
        _bottomTitle2Label.hidden = YES;
    }
}

@end
