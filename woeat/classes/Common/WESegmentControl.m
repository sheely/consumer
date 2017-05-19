//
//  WESegmentControl.m
//  woeat
//
//  Created by liubin on 16/10/21.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WESegmentControl.h"

@implementation WESegmentControl

-(instancetype)initWithItems:(NSArray *)items
{
    self = [super initWithItems:items];
    NSMutableParagraphStyle* style;
    style = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIFont systemFontOfSize:15], NSFontAttributeName,
                          style, NSParagraphStyleAttributeName,
                          nil];
    [self setTitleTextAttributes:attr forState:UIControlStateNormal];
    self.tintColor = DARK_ORANGE_COLOR;
    self.selectedSegmentIndex = 0;
    
    return self;
}


@end
