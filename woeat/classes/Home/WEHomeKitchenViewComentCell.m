//
//  WEHomeKitchenViewComentCell.m
//  woeat
//
//  Created by liubin on 16/10/23.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEHomeKitchenViewComentCell.h"
#import "WEUtil.h"
#import "WERoundTextView.h"
#import "WERoundTextListView.h"
#import "UIImageView+WebCache.h"

static float offsetX = 15;
static float imageWidth = 60;
static float topSpace = 10;
static float offsetLeft;
static float offsetRight;
static float vSpace = 10;
static float replyTop = 10;
static float replyOffsetX = 10;
static float replyVSpace = 10;
static float bottomSpace = 20;


#define NAME_FONT [UIFont boldSystemFontOfSize:13]
#define CONTENT_FONT [UIFont systemFontOfSize:14]
#define TIME_FONT [UIFont systemFontOfSize:12]

#define REPLY_HEADER_FONT [UIFont boldSystemFontOfSize:14]
#define REPLY_CONTENT_FONT [UIFont systemFontOfSize:14]

@implementation WEHomeKitchenViewComentCell

+ (float)getHeightWithModel:(WEModelGetCommentListCommentList *)model
{
//    static NSMutableDictionary *cache = nil;
//    if (!cache) {
//        cache = [NSMutableDictionary new];
//    }
//    NSNumber *n = [cache objectForKey:model];
    
    offsetLeft = COND_WIDTH_320(15, 10);
    offsetRight = COND_WIDTH_320(15, 10);
    
    float height = 0;
    height += topSpace;
    
    CGSize size = [model.UserDisplayName sizeWithAttributes:@{NSFontAttributeName : NAME_FONT}];
    height += size.height;
    
    height += vSpace;
    float contentWidth = [WEUtil getScreenWidth] - (offsetX + imageWidth + offsetLeft) - offsetX;
    CGSize contentSize = [WEUtil sizeForTitle:model.Message font:CONTENT_FONT maxWidth:contentWidth];
    height += contentSize.height;
    
    height += vSpace;
    WERoundTextListView *evaluationListView = [WERoundTextListView new];
    evaluationListView.textBgColor = UICOLOR(184, 184, 184);
    evaluationListView.textFont = [UIFont systemFontOfSize:13];
    evaluationListView.textInset = UIEdgeInsetsMake(-6, -11, -6, -11);
    evaluationListView.cornerRadius = 6;
    evaluationListView.onlyBorder = NO;
    evaluationListView.maxWidth = contentWidth;
    evaluationListView.lineSpace = 10;
    evaluationListView.itemSpace = 10;
    [evaluationListView setStringArray: model.TagList];
    height += [evaluationListView getHeight];
    
    height += vSpace;
    height += TIME_FONT.pointSize+1;
    
    if (!model.Reply) {
        height += bottomSpace;
        return height;
    }
    
    height += replyTop;
    height += replyVSpace;
    height += REPLY_HEADER_FONT.pointSize + 1;
    
    height += replyVSpace;
    float replyContentWidth = contentWidth - replyOffsetX - replyOffsetX;
    CGSize replyContentSize = [WEUtil sizeForTitle:model.Reply.Message font:REPLY_CONTENT_FONT maxWidth:replyContentWidth];
    height += replyContentSize.height;
    height += replyVSpace;
    
    height += bottomSpace;
    
    return height;
}

- (NSString *)getPosttiveString:(NSString *)text
{
    if ([text isEqualToString:@"POSITIVE"]) {
        return @"好评";
    } else if ([text isEqualToString:@"NEUTRAL"]) {
        return @"中评";
    } else if ([text isEqualToString:@"NEGATIVE"]) {
        return @"差评";
    }
    return nil;
}

- (void)setModel:(WEModelGetCommentListCommentList *)model
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = [UIColor clearColor];
    
    UIView *superView = self.contentView;
    for(UIView *v in superView.subviews) {
        [v removeFromSuperview];
    }
    
    UIImageView *imgView = [UIImageView new];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    imgView.backgroundColor = UICOLOR(200,200,200);
    [superView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.top.equalTo(superView.top).offset(0);
        make.width.equalTo(imageWidth);
        make.height.equalTo(imageWidth);
    }];
    NSString *s = model.UserPortraitUrl;
    NSURL *url = [NSURL URLWithString:s];
    [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
   
    offsetLeft = COND_WIDTH_320(15, 10);
    offsetRight = COND_WIDTH_320(15, 10);
    UILabel *name = [UILabel new];
    name.numberOfLines = 1;
    name.textAlignment = NSTextAlignmentLeft;
    name.font = NAME_FONT;
    name.textColor = [UIColor blackColor];
    name.text = model.UserDisplayName;
    CGSize size = [name.text sizeWithAttributes:@{NSFontAttributeName : name.font}];
    [superView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.right).offset(offsetLeft);
        make.top.equalTo(superView.top).offset(topSpace);
        make.width.equalTo(size.width+0.5).priorityHigh();
        make.height.equalTo(size.height);
    }];
    
    WERoundTextView *level = [WERoundTextView new];
    level.textBgColor = UICOLOR(139, 133, 101);
    level.textFont = [UIFont systemFontOfSize:12];
    level.textInset = UIEdgeInsetsMake(-3, -7, -3, -7);
    level.cornerRadius = 0;
    [level setString:[self getPosttiveString:model.Positive]];
    [superView addSubview:level];
    [level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.right).offset(offsetRight);
        make.centerY.equalTo(name.centerY);
        make.width.equalTo([level getWidth]).priorityHigh();
        make.height.equalTo([level getHeight]);
        make.right.lessThanOrEqualTo(superView.right).offset(-offsetX);
    }];
    
    
    UILabel *content = [UILabel new];
    content.backgroundColor = [UIColor clearColor];
    content.numberOfLines = 0;
    content.textAlignment = NSTextAlignmentLeft;
    content.lineBreakMode = NSLineBreakByWordWrapping;
    content.font = CONTENT_FONT;
    content.textColor = UICOLOR(180, 180, 180);
    content.text = model.Message;
    [superView addSubview:content];
    float contentWidth = [WEUtil getScreenWidth] - (offsetX + imageWidth + offsetLeft) - offsetX;
    content.preferredMaxLayoutWidth = contentWidth;
    CGSize contentSize = [WEUtil sizeForTitle:content.text font:content.font maxWidth:contentWidth];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.right.equalTo(superView.right).offset(-offsetRight);
        make.top.equalTo(name.bottom).offset(vSpace);
        make.left.equalTo(name.left);
        make.width.equalTo(contentWidth);
        make.height.equalTo(contentSize.height);
    }];
    
    
    WERoundTextListView *evaluationListView = [WERoundTextListView new];
    evaluationListView.textBgColor = UICOLOR(184, 184, 184);
    evaluationListView.textFont = [UIFont systemFontOfSize:13];
    evaluationListView.textInset = UIEdgeInsetsMake(-6, -11, -6, -11);
    evaluationListView.cornerRadius = 6;
    evaluationListView.onlyBorder = NO;
    evaluationListView.maxWidth = contentWidth;
    evaluationListView.lineSpace = 10;
    evaluationListView.itemSpace = 10;
    [evaluationListView setStringArray: model.TagList];
    [superView addSubview:evaluationListView];
    [evaluationListView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(content.left);
        make.width.equalTo([evaluationListView getWidth]);
        make.top.equalTo(content.bottom).offset(vSpace);
        make.height.equalTo([evaluationListView getHeight]);
    }];

    UILabel *time = [UILabel new];
    time.numberOfLines = 1;
    time.textAlignment = NSTextAlignmentLeft;
    time.font = TIME_FONT;
    time.textColor = UICOLOR(150, 150, 150);
    NSString *timeString = [WEUtil convertFullDateStringToSimple:model.ObjectTimeCreated];
    time.text = timeString;
    [superView addSubview:time];
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.left);
        make.top.equalTo(evaluationListView.bottom).offset(vSpace);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.height.equalTo(time.font.pointSize+1);
    }];
    
    
    if (!model.Reply) {
        return;
    }
    
    UIView *replyBg = [UIView new];
    replyBg.backgroundColor = UICOLOR(238, 238, 238);
    [superView addSubview:replyBg];
    [replyBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(content.left);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(time.bottom).offset(replyTop);
        //make.bottom.equalTo(imgView.bottom).offset(-bottomSpace);
    }];
    
    superView = replyBg;
    UILabel *replyHeader = [UILabel new];
    replyHeader.numberOfLines = 1;
    replyHeader.textAlignment = NSTextAlignmentLeft;
    replyHeader.font = REPLY_HEADER_FONT;
    replyHeader.textColor = DARK_ORANGE_COLOR;
    replyHeader.text = @"家厨回复";
    [superView addSubview:replyHeader];
    [replyHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(replyOffsetX);
        make.top.equalTo(superView.top).offset(replyVSpace);
        make.right.equalTo(superView.right).offset(-replyOffsetX);
        make.height.equalTo(replyHeader.font.pointSize+1);
    }];
    
    
    UILabel *replyContent = [UILabel new];
    replyContent.numberOfLines = 0;
    replyContent.textAlignment = NSTextAlignmentLeft;
    replyContent.lineBreakMode = NSLineBreakByWordWrapping;
    replyContent.font = REPLY_CONTENT_FONT;
    replyContent.textColor = UICOLOR(180, 180, 180);
    replyContent.text = model.Reply.Message;
    [superView addSubview:replyContent];
    float replyContentWidth = contentWidth - replyOffsetX - replyOffsetX;
    CGSize replyContentSize = [WEUtil sizeForTitle:replyContent.text font:replyContent.font maxWidth:replyContentWidth];
    [replyContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(replyOffsetX);
        make.top.equalTo(replyHeader.bottom).offset(replyVSpace);
        make.right.equalTo(superView.right).offset(-replyOffsetX);
        //make.bottom.equalTo(superView.bottom).offset(-vSpace);
    }];

    float replyHeight = replyVSpace + replyHeader.font.pointSize+1 + replyVSpace + replyContentSize.height + replyVSpace;
    [replyBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(replyHeight);
    }];
    
}
@end
