//
//  WERightImageLeftLabelButton.h
//  woeat
//
//  Created by liubin on 16/11/29.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WERightImageLeftLabelButton : UIButton

@property(nonatomic, strong, readonly) UILabel *label;
@property(nonatomic, strong, readonly) UIImageView *imgView;

- (instancetype)initWithImage:(UIImage *)img title:(NSString *)title;


- (float)getHeight;
@end
