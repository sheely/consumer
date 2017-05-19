//
//  WEPersonalCommentCell.m
//  woeat
//
//  Created by liubin on 17/1/3.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WEPersonalCommentCell.h"
#import "WEModelGetCommentList.h"
#import "WEUtil.h"
#import "UIImageView+WebCache.h"

@interface WEPersonalCommentCell()
{
    UILabel *_orderId;
    UILabel *_orderDate;
    UIImageView *_imgView;
    UILabel *_kitchenName;
    UILabel *_diliver;
    UILabel *_price;
    
    UILabel *_myCommentContent;
    MASConstraint *_commentContentConstraint;
    UILabel *_replyContent;
    MASConstraint *_replyContentConstraint;
    UIView *_replyBg;
}

@end

#define REPLY_FONT [UIFont systemFontOfSize:11]
#define NORMAL_FONT  [UIFont systemFontOfSize:11]

static float g_height_normal = 0;
static float g_width_normal = 0;
static float g_height_reply = 0;
static float g_width_reply = 0;


@implementation WEPersonalCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = [UIColor clearColor];
    
    
    UIView *superView = self.contentView;
    
    g_height_normal = 0;
    float space = 20;
    float offsetX = 15;
    UILabel *orderId = [UILabel new];
    orderId.numberOfLines = 1;
    orderId.textAlignment = NSTextAlignmentLeft;
    orderId.font = [UIFont boldSystemFontOfSize:13];
    orderId.textColor = [UIColor blackColor];
    //orderId.text = @"订单号 102226";
    [superView addSubview:orderId];
    [orderId sizeToFit];
    [orderId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.top.equalTo(superView.top).offset(space);
    }];
    _orderId = orderId;
    g_height_normal += space + orderId.font.lineHeight;
    
    UILabel *orderDate = [UILabel new];
    orderDate.numberOfLines = 1;
    orderDate.textAlignment = NSTextAlignmentRight;
    orderDate.font = [UIFont systemFontOfSize:13];
    orderDate.textColor = [UIColor grayColor];
    //orderDate.text = @"2016年10月20日 19:25";
    [superView addSubview:orderDate];
    [orderDate sizeToFit];
    [orderDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(orderId.centerY);
        make.right.equalTo(superView.right).offset(-offsetX);
    }];
    _orderDate = orderDate;
    
    space = 10;
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor lightGrayColor];
    [superView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(orderId.bottom).offset(space);
        make.height.equalTo(0.5);
    }];
    g_height_normal += space + 0.5;
    
    float imageWidth = 70;
    UIImageView *imgView = [UIImageView new];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    imgView.backgroundColor = UICOLOR(200,200,200);
    [superView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line.left);
        make.top.equalTo(line.bottom).offset(5);
        make.height.equalTo(imageWidth);
        make.width.equalTo(imageWidth);
    }];
    //NSString *s = @"http://doc.woeatapp.com/ui/resource/DummyImages/Dishes/02.jpg";
    //NSURL *url = [NSURL URLWithString:s];
    //[imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    _imgView = imgView;
    
    space = 5;
    float offsetLeft = COND_WIDTH_320(15, 10);
    UILabel *kitchenName = [UILabel new];
    kitchenName.numberOfLines = 1;
    kitchenName.textAlignment = NSTextAlignmentLeft;
    kitchenName.font = [UIFont boldSystemFontOfSize:15];
    kitchenName.textColor = DARK_ORANGE_COLOR;
    //kitchenName.text = @"飘湘满楼";
    [superView addSubview:kitchenName];
    [kitchenName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.right).offset(offsetLeft);
        make.top.equalTo(line.bottom).offset(space);
    }];
    _kitchenName = kitchenName;
    g_height_normal += space + kitchenName.font.pointSize;
    
    space = 8;
    UILabel *diliver = [UILabel new];
    diliver.numberOfLines = 1;
    diliver.textAlignment = NSTextAlignmentLeft;
    diliver.font = [UIFont systemFontOfSize:11];
    diliver.textColor = [UIColor blackColor];
    //diliver.text = @"配送";
    [superView addSubview:diliver];
    [diliver sizeToFit];
    [diliver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(kitchenName.left);
        make.top.equalTo(kitchenName.bottom).offset(space);
    }];
    _diliver = diliver;
    g_height_normal += space + diliver.font.pointSize;
    
    UILabel *price = [UILabel new];
    price.numberOfLines = 1;
    price.textAlignment = NSTextAlignmentLeft;
    price.font = [UIFont systemFontOfSize:11];
    price.textColor = [UIColor blackColor];
    //price.text = @"需支付: $36.00";
    [superView addSubview:price];
    [price sizeToFit];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(diliver.right).offset(20);
        make.centerY.equalTo(diliver.centerY);
    }];
    _price = price;
    
    space = 16;
    UILabel *myCommentTitle = [UILabel new];
    myCommentTitle.numberOfLines = 1;
    myCommentTitle.textAlignment = NSTextAlignmentLeft;
    myCommentTitle.font = [UIFont boldSystemFontOfSize:11];
    myCommentTitle.textColor = [UIColor blackColor];
    myCommentTitle.text = @"我的评价";
    [superView addSubview:myCommentTitle];
    [myCommentTitle sizeToFit];
    [myCommentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(price.bottom).offset(space);
        make.left.equalTo(kitchenName.left);
    }];
    g_height_normal += space + myCommentTitle.font.pointSize;
    
    space = 6;
    UILabel *myCommentContent = [UILabel new];
    myCommentContent.numberOfLines = 0;
    myCommentContent.textAlignment = NSTextAlignmentLeft;
    myCommentContent.font = NORMAL_FONT;
    myCommentContent.textColor = [UIColor grayColor];
    //myCommentContent.text = @"有点贵。送餐慢";
    [superView addSubview:myCommentContent];
    [myCommentContent sizeToFit];
    [myCommentContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myCommentTitle.bottom).offset(space);
        make.left.equalTo(myCommentTitle.left);
        make.right.equalTo(superView.right).offset(-offsetX);
        _commentContentConstraint = make.height.equalTo(0);
    }];
    _myCommentContent = myCommentContent;
    g_height_normal += space;
    g_width_normal = [WEUtil getScreenWidth] - (offsetX + imageWidth + offsetLeft + offsetX);
    
    float bottom = 25;
    g_height_normal += bottom;
    g_height_reply = 0;
    
    space = 10;
    UIView *replyBg = [UIView new];
    replyBg.backgroundColor = UICOLOR(238, 238, 238);
    [superView addSubview:replyBg];
    [replyBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myCommentContent.left);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(myCommentContent.bottom).offset(space);
    }];
    _replyBg = replyBg;
    g_height_reply += space;
    
    superView = replyBg;
    float replyOffsetX = 5;
    space = 8;
    UILabel *replyHeader = [UILabel new];
    replyHeader.numberOfLines = 1;
    replyHeader.textAlignment = NSTextAlignmentLeft;
    replyHeader.font = [UIFont boldSystemFontOfSize:11];
    replyHeader.textColor = [UIColor blackColor];
    replyHeader.text = @"家厨回复";
    [superView addSubview:replyHeader];
    [replyHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(replyOffsetX);
        make.top.equalTo(superView.top).offset(space);
    }];
    g_height_reply += space + replyHeader.font.pointSize;
    
    g_width_reply = g_width_normal - replyOffsetX * 2;
    space = 6;
    UILabel *replyContent = [UILabel new];
    replyContent.numberOfLines = 0;
    replyContent.textAlignment = NSTextAlignmentLeft;
    replyContent.lineBreakMode = NSLineBreakByWordWrapping;
    replyContent.font = REPLY_FONT;
    replyContent.textColor = UICOLOR(180, 180, 180);
    //replyContent.text = @"谢谢评论，我们注意改进服务质量";
    [superView addSubview:replyContent];
    [replyContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(replyBg.left).offset(replyOffsetX);
        make.top.equalTo(replyHeader.bottom).offset(space);
        make.right.equalTo(replyBg.right).offset(-replyOffsetX);
        make.bottom.equalTo(replyBg.bottom).offset(-space);
        _replyContentConstraint = make.height.equalTo(0);
        
    }];
    _replyContent = replyContent;
    g_height_reply += space;
    
    
    
    return self;
}


- (void)setModel:(WEModelGetCommentListCommentList *)model
{
    _orderId.text = [NSString stringWithFormat:@"订单号 %@", model.ObjectId];
    _orderDate.text = [WEUtil convertFullDateStringToSimple:model.ObjectTimeCreated];
    if ([model.SalesOrderDispatchMethod isEqualToString:@"PICKUP"]) {
        _diliver.text = @"自取";
    } else if ([model.SalesOrderDispatchMethod isEqualToString:@"DELIVER"]){
        _diliver.text = @"配送";
    }
    _price.text = [NSString stringWithFormat:@"总额: $%.2f",model.SalesOrderTotalValue];

    NSString *s = model.KitchenPortraitUrl;
    NSURL *url = [NSURL URLWithString:s];
    [_imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    _kitchenName.text = model.KitchenName;
    
    NSString *normal = model.Message;
    CGSize normalContentSize = [WEUtil sizeForTitle:normal font:NORMAL_FONT maxWidth:g_width_normal];
    _myCommentContent.text = normal;
    _commentContentConstraint.equalTo(normalContentSize.height);
    
    _replyBg.hidden = YES;
    if (model.Reply.Message.length) {
        NSString *reply = model.Reply.Message;
        CGSize replyContentSize = [WEUtil sizeForTitle:reply font:REPLY_FONT maxWidth:g_width_reply];
        _replyBg.hidden = NO;
        _replyContent.text = reply;
        _replyContentConstraint.equalTo(replyContentSize.height);
        
    }
}

+ (float)getHeightWithModel:(WEModelGetCommentListCommentList *)model
{
    NSString *normal = model.Message;
    CGSize normalContentSize = [WEUtil sizeForTitle:normal font:NORMAL_FONT maxWidth:g_width_normal];
    
    if (model.Reply.Message.length) {
        NSString *reply = model.Reply.Message;
        CGSize replyContentSize = [WEUtil sizeForTitle:reply font:REPLY_FONT maxWidth:g_width_reply];
        return g_height_reply + g_height_normal + normalContentSize.height + replyContentSize.height;
        
    } else {
        return g_height_normal + normalContentSize.height;
    }
    
}


@end
