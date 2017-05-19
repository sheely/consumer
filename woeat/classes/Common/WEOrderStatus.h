//
//  WEOrderStatus.h
//  woeat
//
//  Created by liubin on 16/12/28.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>


#define  WEOrderStatus_COMPLETED           @"COMPLETED"
#define  WEOrderStatus_TO_BE_COMMENTTED    @"TO_BE_COMMENTTED"
#define  WEOrderStatus_DISPATCHED          @"DISPATCHED"
#define  WEOrderStatus_ACCEPTED            @"ACCEPTED"
#define  WEOrderStatus_REJECTED            @"REJECTED"
#define  WEOrderStatus_PAID                @"PAID"
#define  WEOrderStatus_UNPAID              @"UNPAID"
#define  WEOrderStatus_UNSUBMITTEDD        @"UNSUBMITTED"
#define  WEOrderStatus_READY               @"READY"
#define  WEOrderStatus_RECEIVED            @"RECEIVED"
#define  WEOrderStatus_REFUNDING           @"REFUNDING"


@interface WEOrderStatus : NSObject

+ (NSString *)getDesc:(NSString *)status;

@end
