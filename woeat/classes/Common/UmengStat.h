//
//  UmengStat.h
//  ClipPlus
//
//  Created by liubin on 16/7/16.
//  Copyright © 2016年 Sense-U. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UMENG_STAT_PAGE_INTRODUCE              @"1.0 欢迎页"
#define UMENG_STAT_PAGE_LOGIN                  @"2.0 登录"

#define UMENG_STAT_PAGE_HOME                   @"3.0 饭友端首页"
#define UMENG_STAT_PAGE_SET_ADDRESS            @"3.1 设置当前地址"
#define UMENG_STAT_PAGE_SEARCH                 @"3.2 搜索"
#define UMENG_STAT_PAGE_KITCHEN                @"4.0 厨房详情页"
#define UMENG_STAT_PAGE_KITCHEN_STORY          @"4.1 我的厨房故事"
#define UMENG_STAT_PAGE_DISH                   @"5.0 菜品详情页"

#define UMENG_STAT_PAGE_ORDER_LIST              @"6.0 订单"
#define UMENG_STAT_PAGE_PAY_LIST                @"6.1 支付方式选择"
#define UMENG_STAT_PAGE_PAY_BALANCE             @"6.2 余额支付"
#define UMENG_STAT_PAGE_BALANCE_CHARGE          @"6.3 余额充值"
#define UMENG_STAT_PAGE_PAY_CARD                @"6.4 信用卡支付"
#define UMENG_STAT_PAGE_ORDER_DETAIL            @"6.5 订单详情"

#define UMENG_STAT_PAGE_PERCENTER_CENTER        @"7.0 个人中心"
#define UMENG_STAT_PAGE_MY_ORDER                @"7.1 我的订单"
#define UMENG_STAT_PAGE_MY_COMMENT              @"7.2 我的评论"
#define UMENG_STAT_PAGE_ADDRESS_LIST            @"7.3 送餐地址列表"
#define UMENG_STAT_PAGE_ADDRESS_EDIT            @"7.3.1 送餐地址编辑"
#define UMENG_STAT_PAGE_APPLY_KITCHENER         @"7.4 申请为家厨"
#define UMENG_STAT_PAGE_USER_DECLARE            @"7.5 免责声明"
#define UMENG_STAT_PAGE_ABOUNT                  @"7.6 关于WOEAT"
#define UMENG_STAT_PAGE_SETTING                 @"7.7 个人设置"
#define UMENG_STAT_PAGE_COUPON                  @"7.8 优惠券"
#define UMENG_STAT_PAGE_BANK_CARD_LIST          @"7.9 我的银行卡"
#define UMENG_STAT_PAGE_BANK_CARD_ADD           @"7.9.1 增加银行卡"
#define UMENG_STAT_PAGE_BANK_CARD_UPDATE        @"7.9.2 修改银行卡"
#define UMENG_STAT_PAGE_BANK_CARD_SCAN          @"7.9.3 扫描银行卡"



@interface UmengStat : NSObject
+ (void)initWithAppKey:(NSString *)appkey;
+ (void)pageEnter:(NSString *)pageName;
+ (void)pageLeave:(NSString *)pageName;
+ (void)signIn:(NSString *)userName;
+ (void)signOut;
+ (void)event:(NSString *)event type:(NSString *)type platform:(NSString *)platform;
@end
