//
//  WETwoColumnListView.h
//  woeat
//
//  Created by liubin on 16/11/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WETwoColumnListView : UIView
@property(nonatomic, strong) UIFont *font;
@property(nonatomic, strong) UIColor *color;

@property(nonatomic, assign) float middleSpace;
@property(nonatomic, assign) float maxWidth;
@property(nonatomic, assign) float vSpace;
@property(nonatomic, assign) float vSpaceLine;

- (void)setUpLeftText:(NSArray *)lefts rightText:(NSArray *)rights;
- (CGFloat)getHeight;

@end
