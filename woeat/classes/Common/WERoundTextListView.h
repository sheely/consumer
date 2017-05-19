//
//  WERoundTextListView.h
//  woeat
//
//  Created by liubin on 16/10/20.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WERoundTextListView : UIView

@property(nonatomic, strong) UIColor *textBgColor;
@property(nonatomic, strong) UIFont *textFont;
@property(nonatomic, assign) UIEdgeInsets textInset;
@property(nonatomic, assign) float cornerRadius;
@property(nonatomic, assign) BOOL onlyBorder;

@property(nonatomic, assign) float maxWidth;
@property(nonatomic, assign) float lineSpace;
@property(nonatomic, assign) float itemSpace;

@property(nonatomic, assign) BOOL allowMultiSelect;
@property(nonatomic, strong) UIColor *selectedBgColor;
@property(nonatomic, assign) BOOL showMoreButton;
@property(nonatomic, strong) NSMutableSet *selectedSet;

- (void)setStringArray:(NSArray *)array;
- (float)getHeight;
- (float)getWidth;

@end
