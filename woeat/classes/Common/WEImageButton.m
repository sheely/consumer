//
//  WEImageButton.m
//  woeat
//
//  Created by liubin on 16/10/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEImageButton.h"


@interface WEImageButton()

@property(nonatomic, strong, readwrite) UILabel *label;
@property(nonatomic, strong, readwrite) UIImageView *imgView;
@end


@implementation WEImageButton

- (instancetype)initWithImage:(UIImage *)img title:(NSString *)title
{
    self = [super initWithFrame:CGRectZero];
    UIView *superView = self;
    
    UILabel *label = [UILabel new];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = DARK_ORANGE_COLOR;
    [superView addSubview:label];
    label.text = title;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView.centerY);
        make.right.equalTo(superView.right);
        make.left.equalTo(superView.left);
    }];
    self.label = label;
    
    if (img) {
        UIImageView *imgView = [UIImageView new];
        imgView.image = img;
        [superView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(superView.centerY);
            make.left.equalTo(superView.left);
            make.width.equalTo(img.size.width);
            make.height.equalTo(img.size.height);
        }];
        self.imgView = imgView;
    }
    
    return self;
}


@end
