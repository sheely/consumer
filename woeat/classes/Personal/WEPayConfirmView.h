//
//  WEPayConfirmView.h
//  woeat
//
//  Created by liubin on 17/3/26.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEPayConfirmView : UIView
@property(nonatomic, strong) UILabel *right1;
@property(nonatomic, strong) UILabel *right2;
@property(nonatomic, strong) UILabel *right3;
@property(nonatomic, strong) UILabel *right4;
//@property(nonatomic, strong) UILabel *right5;


-(instancetype)initWithRecharge:(BOOL)forRecharge;
- (float)getHeight;
@end
