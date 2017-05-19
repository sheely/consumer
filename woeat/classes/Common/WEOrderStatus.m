//
//  WEOrderStatus.m
//  woeat
//
//  Created by liubin on 16/12/28.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEOrderStatus.h"

@implementation WEOrderStatus

+ (NSString *)getDesc:(NSString *)status
{
    NSDictionary *statusDict = @{
                                 WEOrderStatus_COMPLETED : @"已完成",
                                 WEOrderStatus_TO_BE_COMMENTTED : @"待评论",
                                 WEOrderStatus_DISPATCHED : @"已派送",
                                 WEOrderStatus_ACCEPTED : @"已接单",
                                 WEOrderStatus_REJECTED : @"已拒单",
                                 WEOrderStatus_PAID : @"已付款",
                                 WEOrderStatus_UNPAID : @"待付款",
                                 WEOrderStatus_UNSUBMITTEDD : @"未提交",
                                 WEOrderStatus_READY : @"待派送或待自取",
                                 WEOrderStatus_RECEIVED : @"已送达",
                                 WEOrderStatus_REFUNDING : @"退款中",
                                 };
    NSString *value = [statusDict objectForKey:status];
    if (value.length) {
        return value;
    }
    return status;
}

@end
