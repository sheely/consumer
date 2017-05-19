//
//  WERoundTextView.h
//  woeat
//
//  Created by liubin on 16/10/21.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WERoundTextView : UIView

@property(nonatomic, strong) UIColor *textBgColor;
@property(nonatomic, strong) UIFont *textFont;
@property(nonatomic, assign) UIEdgeInsets textInset;
@property(nonatomic, assign) float cornerRadius;
@property(nonatomic, assign) BOOL onlyBorder;

- (float)getWidth;
- (float)getHeight;
- (void)setString:(NSString *)text;
@end

