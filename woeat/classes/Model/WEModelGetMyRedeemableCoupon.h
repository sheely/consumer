//
//  WEModelGetMyRedeemableCoupon.h
//  woeat
//
//  Created by liubin on 16/12/10.
//

#import <Foundation/Foundation.h>
#import "JsonModel.h"

@protocol WEModelGetMyRedeemableCouponUserCouponList
@end

@interface WEModelGetMyRedeemableCouponUserCouponList : JSONModel
@property(nonatomic, strong) NSString<Optional> *OrderId;
@property(nonatomic, strong) NSString<Optional> *RuleDescription;
@property(nonatomic, strong) NSString<Optional> *RuleValueDescription;
@property(nonatomic, strong) NSString<Optional> *CouponCode;
@property(nonatomic, strong) NSString<Optional> *UserCouponId;
@property(nonatomic, strong) NSString<Optional> *CouponName;
@property(nonatomic, strong) NSString<Optional> *UserId;
@property(nonatomic, strong) NSString<Optional> *ValidFrom;
@property(nonatomic, strong) NSString<Optional> *RuleName;
@property(nonatomic, strong) NSString<Optional> *RuleConditionDescription;
@property(nonatomic, strong) NSString<Optional> *TimeRedeemed;
@property(nonatomic, strong) NSString<Optional> *ValidTo;
@property(nonatomic, strong) NSString<Optional> *TimeClaimed;
@end

@interface WEModelGetMyRedeemableCoupon : JSONModel
@property(nonatomic, strong) NSString<Optional> *UserId;
@property(nonatomic, strong) NSArray<WEModelGetMyRedeemableCouponUserCouponList> *UserCouponList;
@property(nonatomic, strong) NSString<Optional> *ResponseCode;
@property(nonatomic, strong) NSString<Optional> *ResponseDebugInfo;
@property(nonatomic, assign) BOOL IsRedeemed;
@property(nonatomic, assign) BOOL IsSuccessful;
@property(nonatomic, strong) NSString<Optional> *ResponseMessage;
@end

