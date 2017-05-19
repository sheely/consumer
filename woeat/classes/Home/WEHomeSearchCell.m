//
//  WEHomeSearchCell.m
//  woeat
//
//  Created by liubin on 17/1/11.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WEHomeSearchCell.h"
#import "UIImageView+WebCache.h"
#import "WETwoColumnButton.h"
#import "WEUtil.h"
#import "WEModelWildSearch.h"


#define TEXT_COLOR UICOLOR(153,153,153)

#define TAG_BUTTON_START  100

#define BOTTOM_SPACE  15
#define BUTTON_TOP   10
#define BUTTON_HEIGHT    20
#define BUTTON_MIDDLE    10

@interface WEHomeSearchCell()
{
    UIView *_line;
    UIImageView *_imgView;
    UILabel *_name;
    UILabel *_title;
    UILabel *_distance;
    //NSMutableArray<WETwoColumnButton *> *_buttons;
    WEModelWildSearchKitchenList *_data;
}

@end


@implementation WEHomeSearchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self)
        return nil;
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = [UIColor clearColor];
    
    UIView *superView = self.contentView;
    float offsetX = 15;
    UIView *line = [UIView new];
    line.backgroundColor = UICOLOR(233,205,203);
    [superView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(offsetX);
        make.right.equalTo(superView.right).offset(-offsetX);
        make.top.equalTo(superView.top).offset(0);
        make.height.equalTo(1);
    }];
    _line = line;
    
    UIImageView *imgView = [UIImageView new];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    imgView.backgroundColor = UICOLOR(200,200,200);
    [superView addSubview:imgView];
    float imgWidth = COND_WIDTH_320(80, 80);
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(15);
        make.top.equalTo(_line.bottom).offset(12);
        make.width.equalTo(imgWidth);
        make.height.equalTo(imgWidth);
    }];
    _imgView = imgView;
    
    float offset = COND_WIDTH_320(15, 5);
    UILabel *name = [UILabel new];
    name.numberOfLines = 1;
    name.textAlignment = NSTextAlignmentLeft;
    name.font = [UIFont systemFontOfSize:13];
    name.textColor = DARK_ORANGE_COLOR;
    [superView addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.right).offset(offset);
        make.right.equalTo(superView.right).offset(-50);
        make.top.equalTo(imgView.top).offset(2);
        make.height.equalTo(16);
    }];
    _name = name;
    
    UILabel *title = [UILabel new];
    title.numberOfLines = 1;
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont systemFontOfSize:13];
    title.textColor = TEXT_COLOR;
    [superView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.left);
        make.right.equalTo(name.right);
        make.top.equalTo(name.bottom).offset(5);
        make.height.equalTo(16);
    }];
    _title = title;
    
    UIImageView *locIcon = [UIImageView new];
    locIcon.backgroundColor = [UIColor clearColor];
    locIcon.image = [UIImage imageNamed:@"icon_location_gray"];
    [superView addSubview:locIcon];
    [locIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(name.left);
        make.top.equalTo(title.bottom).offset(5);
        make.width.equalTo(12);
        make.height.equalTo(12);
    }];
    
    UILabel *distance = [UILabel new];
    distance.numberOfLines = 1;
    distance.textAlignment = NSTextAlignmentLeft;
    distance.font = [UIFont systemFontOfSize:13];
    distance.textColor = TEXT_COLOR;
    [superView addSubview:distance];
    [distance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locIcon.right).offset(3);
        make.right.equalTo(title.right);
        make.centerY.equalTo(locIcon.centerY);
        make.height.equalTo(16);
    }];
    _distance = distance;
    
    return self;
}

- (void)setIsFirstCell:(BOOL)isFirstCell
{
    _isFirstCell = isFirstCell;
    if (_isFirstCell) {
        _line.hidden = YES;
    } else {
        _line.hidden = NO;
    }
}

- (void)setData:(WEModelWildSearchKitchenList *)data
{
    _data = data;
    if (!data) {
        return;
    }
    if (![data isKindOfClass:[WEModelWildSearchKitchenList class]]) {
        NSLog(@"setData class error, should be %@, but %@", [WEModelWildSearchKitchenList class], [data class]);
        return;
    }
    
    _name.text = data.KitchenName;
    _title.text = @"";
    _distance.text = data.DistanceDescription;
    NSString *s = data.KitchenPortraitImageUrl;
    NSURL *url = [NSURL URLWithString:s];
    [_imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image_placeholder"] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
//    for(WETwoColumnButton *button in _buttons) {
//        [button removeFromSuperview];
//    }
    for(UIView *v in self.contentView.subviews) {
        if ([v isKindOfClass:[WETwoColumnButton class]]) {
            [v removeFromSuperview];
        }
    }
    
    UIView *superView = self.contentView;
    WETwoColumnButton *lastButton = nil;
    for(int i=0; i<data.Items.count; i++) {
        WEModelWildSearchKitchenListItems *item = [data.Items objectAtIndex:i];
        WETwoColumnButton *button = [WETwoColumnButton new];
        button.leftLabel.text = item.ItemName;
        button.rightLabel.text = [NSString stringWithFormat:@"$%.2f", item.UnitPrice];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = TAG_BUTTON_START + i;
        [superView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(_imgView.bottom).offset(BUTTON_TOP);
            } else {
                make.top.equalTo(lastButton.bottom).offset(BUTTON_MIDDLE);
            }
            make.left.equalTo(_name.left);
            make.right.equalTo(superView.right).offset(-60);
            make.height.equalTo(BUTTON_HEIGHT);
        }];
        lastButton = button;
    }
    
}

+ (float)getHeightWithData:(WEModelWildSearchKitchenList *)data
{
    float base = 1 + 12 + 80;
    base += BOTTOM_SPACE;
    base += BUTTON_TOP;
    base += data.Items.count * BUTTON_HEIGHT;
    if (data.Items.count > 0) {
        base += (data.Items.count-1) * (BUTTON_MIDDLE);
    }
    return base;
}

- (void)buttonTapped:(UIButton *)button
{
    int i = button.tag - TAG_BUTTON_START;
    WEModelWildSearchKitchenListItems *item = [_data.Items objectAtIndex:i];
    if ([_dishDelegate respondsToSelector:@selector(searchDishTapped:kitchen:)]) {
        [_dishDelegate searchDishTapped:item.ItemId kitchen:_data.KitchenId];
    }
}

@end
