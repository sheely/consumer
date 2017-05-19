//
//  WERightImageLeftLabelButton.m
//  woeat
//
//  Created by liubin on 16/11/29.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WERightImageLeftLabelButton.h"
#import "WEUtil.h"

@interface WERightImageLeftLabelButton()
{
    float _totalHeight;
}
@property(nonatomic, strong, readwrite) UILabel *label;
@property(nonatomic, strong, readwrite) UIImageView *imgView;
@end


@implementation WERightImageLeftLabelButton

- (instancetype)initWithImage:(UIImage *)img title:(NSString *)title
{
    self = [super initWithFrame:CGRectZero];
    UIView *superView = self;
    
    UILabel *label = [UILabel new];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UICOLOR(0,0,0);
    [superView addSubview:label];
    label.text = title;
    CGSize size = [WEUtil oneLineSizeForTitle:title font:label.font];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left);
        make.centerY.equalTo(superView.centerY);
        make.height.equalTo(size.height);
    }];
    self.label = label;
    
    UIImageView *imgView = [UIImageView new];
    imgView.image = img;
    [superView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView.centerY);
        make.right.equalTo(superView.right);
        make.width.equalTo(img.size.width);
        make.height.equalTo(img.size.height);
        make.left.equalTo(label.right);
    }];
    self.imgView = imgView;
    
    _totalHeight = MAX(size.height, img.size.height);
    return self;
}

- (float)getHeight
{
    return _totalHeight;
}


@end
