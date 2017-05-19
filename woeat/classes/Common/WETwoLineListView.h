//
//  WETwoLineListView.h
//  woeat
//
//  Created by liubin on 16/11/4.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WETwoLineListView : UIView

@property(nonatomic, strong) UIFont *upFont;
@property(nonatomic, strong) UIFont *downFont;

@property(nonatomic, strong) UIColor *upColor;
@property(nonatomic, strong) UIColor *downColor;

@property(nonatomic, assign) float leftPadding;
@property(nonatomic, assign) float rightPadding;
@property(nonatomic, assign) float topPadding;
@property(nonatomic, assign) float bottomPadding;
@property(nonatomic, assign) float middleYPadding;

@property(nonatomic, assign) float lineWidth;
@property(nonatomic, strong) UIColor *lineColor;


- (void)setUpText:(NSArray *)ups downText:(NSArray *)downs;
- (CGFloat)getWidth;
- (CGFloat)getHeight;
@end
