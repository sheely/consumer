//
//  WEModelCommon.h
//  woeat
//
//  Created by liubin on 16/12/20.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@interface WEModelCommon : JSONModel
@property(nonatomic, strong) NSString<Optional> *UserId;
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;

@end
