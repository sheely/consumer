//
//  WEImageButton.h
//  woeat
//
//  Created by liubin on 16/10/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEImageButton : UIButton

@property(nonatomic, strong, readonly) UILabel *label;
@property(nonatomic, strong, readonly) UIImageView *imgView;

- (instancetype)initWithImage:(UIImage *)img title:(NSString *)title;

@end
