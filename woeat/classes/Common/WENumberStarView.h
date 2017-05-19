//
//  WENumberStarView.h
//  woeat
//
//  Created by liubin on 16/10/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WENumberStarView : UIView

- (void)setStarFull:(int)full half:(int)half empty:(int)empty;

- (CGFloat)getWidth;
- (CGFloat)getHeight;
@end
