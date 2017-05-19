//
//  WEBottomStatusBar.h
//  woeat
//
//  Created by liubin on 16/11/7.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  enum WEBottomStatusBarType {
    WEBottomStatusBarType_OneLine,
    WEBottomStatusBarType_Order
}WEBottomStatusBarType;


@interface WEBottomStatusBar : UIView
@property(nonatomic, assign) WEBottomStatusBarType statusBarType;

@property(nonatomic, strong, readonly) UILabel *leftLabel;
@property(nonatomic, strong, readonly) UILabel *middleLabel;
@property(nonatomic, strong, readonly) UIButton *rightButton;

- (float)getHeight;
@end
