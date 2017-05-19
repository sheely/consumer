//
//  WEHomeKitchenComment.m
//  woeat
//
//  Created by liubin on 16/10/23.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEHomeKitchenComment.h"

@implementation WEHomeKitchenComment

+ (NSArray *)getTestData
{
    static NSMutableArray *array = nil;
    if (array) {
        return array;
    }
    array = [NSMutableArray new];
    
    WEHomeKitchenComment *c1 = [WEHomeKitchenComment new];
    c1.personName = @"胡晓晓";
    c1.evaluationLevel = @"好评";
    c1.evaluationContent = @"挺不错的";
    c1.evaluationList = @[@"超赞", @"分量足"];
    c1.evaluationTime = @"2016年12月01日";
    [array addObject:c1];
    
    WEHomeKitchenComment *c2 = [WEHomeKitchenComment new];
    c2.personName = @"马大大";
    c2.evaluationLevel = @"差评";
    c2.evaluationContent = @"有点贵。送餐慢";
    c2.evaluationList = @[@"超赞", @"分量足"];
    c2.evaluationTime = @"2016年12月01日";
    c2.kitchenReply = @"谢谢评论，我们会注意改进服务质量";
    [array addObject:c2];
    
    
    WEHomeKitchenComment *c3 = [WEHomeKitchenComment new];
    c3.personName = @"胡晓晓";
    c3.evaluationLevel = @"好评";
    c3.evaluationContent = @"挺不错的。挺不错的。挺不错的。\n挺不错的。挺不错的。挺不错的。挺不错的。";
    c3.evaluationList = @[@"超赞", @"分量足",@"超赞", @"分量足",@"超赞", @"分量足",@"超赞", @"分量足"];
    c3.evaluationTime = @"2016年12月01日";
    [array addObject:c3];
    
    WEHomeKitchenComment *c4 = [WEHomeKitchenComment new];
    c4.personName = @"马大大";
    c4.evaluationLevel = @"差评";
    c4.evaluationContent = @"有点贵。送餐慢";
    c4.evaluationList = @[@"超赞", @"分量足"];
    c4.evaluationTime = @"2016年12月01日";
    c4.kitchenReply = @"谢谢评论，我们会注意改进服务质量\n谢谢评论\n谢谢评论";
    [array addObject:c4];
    
    return array;
    
}


@end
