//
//  WETwoLineListWideView.h
//  woeat
//
//  Created by liubin on 16/11/26.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WETwoLineListWideView : UIView
@property(nonatomic, strong) UIFont *upFont;
@property(nonatomic, strong) UIFont *downFont;

@property(nonatomic, strong) UIColor *upColor;
@property(nonatomic, strong) UIColor *downColor;

@property(nonatomic, assign) float leftPadding;
@property(nonatomic, assign) float rightPadding;
@property(nonatomic, assign) float topPadding;
@property(nonatomic, assign) float bottomPadding;
@property(nonatomic, assign) float middleYPadding;

@property(nonatomic, assign) float lineHeight;
@property(nonatomic, assign) float lineWidth;
@property(nonatomic, strong) UIColor *lineColor;

@property(nonatomic, assign) float totalWidth;
@property(nonatomic, strong) NSMutableArray *buttons;

- (void)setUpText:(NSArray *)ups downText:(NSArray *)downs;
- (CGFloat)getHeight;
@end
