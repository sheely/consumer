//
//  NSString+Addition.m
//  cygs
//
//  Created by dasenlin on 15/12/3.
//  Copyright © 2015年 dasenlin. All rights reserved.
//

#import "NSString+Addition.h"

@implementation NSString (Addition)

- (BOOL)containString:(NSString *)s
{
    return [self rangeOfString:s].length > 0;
}

@end
