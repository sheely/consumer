//
//  WEModelGetMyCardList.h
//  woeat
//
//  Created by liubin on 17/3/20.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JsonModel.h"

@protocol WEModelGetMyCardListCardList
@end

@interface WEModelGetMyCardListCardList : JSONModel
@property(nonatomic, assign) int ExpirationMonth;
@property(nonatomic, assign) int ExpirationYear;
@property(nonatomic, strong) NSString<Optional> *Id;
@property(nonatomic, strong) NSString<Optional> *MaskedCardNumber;
@property(nonatomic, strong) NSString<Optional> *Name;
@property(nonatomic, assign) BOOL IsDefault;
@end


@interface WEModelGetMyCardList : JSONModel
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@property(nonatomic, strong) NSArray<WEModelGetMyCardListCardList> *CardList;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@end
