//
//  WEDistributeSpaceLabel.m
//  woeat
//
//  Created by liubin on 16/11/20.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEDistributeSpaceLabel.h"
#import "WEUtil.h"


@implementation WEDistributeSpaceLabel

- (void)setDistributeText:(NSString *)text width:(float)width
{
    CGSize size = [WEUtil oneLineSizeForTitle:text font:self.font];
    
    float space = width - size.width;
    space /= (text.length - 1);
    
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStr addAttribute:NSKernAttributeName value:@(space) range:NSMakeRange(0, attrStr.length-1)];
    self.attributedText = attrStr;
}


@end
