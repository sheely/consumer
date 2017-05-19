//
//  WEModelGetListForConsumerHome.h
//  woeat
//
//  Created by liubin on 16/12/10.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@protocol WEModelGetListForConsumerHomeBannerList
@end

@interface WEModelGetListForConsumerHomeBannerList : JSONModel
@property(nonatomic, strong) NSString<Optional> *ImageUrl;
@property(nonatomic, strong) NSString<Optional> *Id;
@property(nonatomic, strong) NSString<Optional> *ImageId;
@property(nonatomic, strong) NSString<Optional> *VersionValidFrom;
@property(nonatomic, assign) int DisplayOrder;
@property(nonatomic, strong) NSString<Optional> *Name;
@property(nonatomic, strong) NSString<Optional> *TimeValidFrom;
@property(nonatomic, strong) NSString<Optional> *ClientKey;
@property(nonatomic, strong) NSString<Optional> *TimeValidTo;
@property(nonatomic, strong) NSString<Optional> *VersionValidTo;
@end

@interface WEModelGetListForConsumerHome : JSONModel
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@property(nonatomic, strong) NSArray<WEModelGetListForConsumerHomeBannerList> *BannerList;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, strong) NSString<Optional> *ModelFilter;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@end

