//
//  WEHomeKitchenComment.h
//  woeat
//
//  Created by liubin on 16/10/23.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WEHomeKitchenComment : NSObject

@property(nonatomic, strong) NSString *personName;
@property(nonatomic, strong) NSString *evaluationLevel;
@property(nonatomic, strong) NSString *evaluationContent;
@property(nonatomic, strong) NSString *evaluationTime;
@property(nonatomic, strong) NSArray *evaluationList;
@property(nonatomic, strong) NSString *kitchenReply;



+ (NSArray *)getTestData;
@end
