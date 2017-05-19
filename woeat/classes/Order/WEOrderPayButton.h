//
//  WEOrderPayButton.h
//  woeat
//
//  Created by liubin on 16/11/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEOrderPayButton : UIButton

@property(nonatomic, strong) NSString *upTitle;
@property(nonatomic, strong) NSString *bottomTitle1;
@property(nonatomic, strong) NSString *bottomTitle2;
@property(nonatomic, strong) NSString *rightTitle;
@property(nonatomic, assign) BOOL arrowIsGray;
@property(nonatomic, strong) UIColor *bottomTitle1Color;

- (void)setHeight:(float)height;
@end
