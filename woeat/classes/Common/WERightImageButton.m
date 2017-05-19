//
//  WERightImageButton.m
//  woeat
//
//  Created by liubin on 16/11/16.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WERightImageButton.h"
#import "WEUtil.h"

@interface WERightImageButton()
{
    float _totalHeight;
    float _totalWidth;
}
@property(nonatomic, strong, readwrite) UILabel *label;
@property(nonatomic, strong, readwrite) UIImageView *imgView;
@end

@implementation WERightImageButton
- (instancetype)initWithImage:(UIImage *)img title:(NSString *)title
{
    self = [super initWithFrame:CGRectZero];
    UIView *superView = self;
    
    UILabel *label = [UILabel new];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UICOLOR(0,0,0);
    [superView addSubview:label];
    label.text = title;
    CGSize size = [WEUtil oneLineSizeForTitle:title font:label.font];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView.centerY);
        make.width.equalTo(size.width+0.5);
        make.height.equalTo(size.height);
    }];
    self.label = label;
    
    float space = 10;
    UIImageView *imgView = [UIImageView new];
    imgView.image = img;
    [superView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView.centerY);
        make.right.equalTo(superView.right);
        make.width.equalTo(img.size.width);
        make.height.equalTo(img.size.height);
        make.left.equalTo(label.right).offset(space);
    }];
    self.imgView = imgView;
    
    _totalHeight = MAX(size.height, img.size.height);
    _totalWidth = size.width + space + img.size.width;
    return self;
}

- (float)getWidth
{
    return _totalWidth;
}

- (float)getHeight
{
    return _totalHeight;
}
@end
