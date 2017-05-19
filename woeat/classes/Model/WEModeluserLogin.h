//
//  WEModeluserLogin.h
//  woeat
//
//  Created by liubin on 16/10/26.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@interface WEModeluserLogin : JSONModel
@property(nonatomic, strong) NSString<Optional> *access_token;
@property(nonatomic, strong) NSString<Optional> *token_type;
@property(nonatomic, strong) NSString<Optional> *expires_in;
@end
