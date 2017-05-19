//
//  WERoundTextListView.m
//  woeat
//
//  Created by liubin on 16/10/20.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WERoundTextListView.h"
#import "YYKit.h"
#import "WEUtil.h"
#import "WERoundTextView.h"

#define TAG_BUTTON_START 1000
#define TAG_TEXTVIEW_START 3000

@interface  WERoundTextListView()
{
    float _featureHeight;
    float _featureWidth;
    float _featureHeightMore;
    float _featureWidthMore;
    UIButton *_moreButton;
}
@end

@implementation WERoundTextListView


//- (void)setStringArray:(NSArray *)array
//{
//    self.backgroundColor = [UIColor clearColor];
//    UIView *superView = self;
//    for(UIView *v in superView.subviews) {
//        [v removeFromSuperview];
//    }
//
//    float offsetXFeature = _offsetX-9;
//    YYTextView *featureText = [YYTextView new];
//    [superView addSubview:featureText];
//    [featureText makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(superView.left).offset(offsetXFeature);
//        make.right.equalTo(superView.right).offset(-offsetXFeature);
//        make.top.equalTo(superView.top).offset(2);
//        make.bottom.equalTo(superView.bottom).offset(0);
//    }];
//    
//    float lineSpaceing = 15;
//    NSMutableAttributedString *text = [NSMutableAttributedString new];
//    NSArray *tags = array;
//    UIFont *font = [UIFont boldSystemFontOfSize:13];
//    float featureWidth = [WEUtil getScreenWidth]-2*offsetXFeature;
//    _featureHeight = 0;
//    UIEdgeInsets insets =  UIEdgeInsetsMake(-8, -10, -8, -10);
//    CGSize size;
//    int lines = 1;
//    for (int i = 0; i < tags.count; i++) {
//        NSString *tag = tags[i];
//        UIColor *tagFillColor = _textBgColor;
//        NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] initWithString:tag];
//        [tagText insertString:@"    " atIndex:0];
//        [tagText appendString:@"    "];
//        tagText.font = font;
//        tagText.color = [UIColor whiteColor];
//        [tagText setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:tagText.rangeOfAll];
//        
//        YYTextBorder *border = [YYTextBorder new];
//        border.fillColor = tagFillColor;
//        border.cornerRadius = 6;
//        border.insets = insets;
//        [tagText setTextBackgroundBorder:border range:[tagText.string rangeOfString:tag]];
//        
//        NSString *s = text.string;
//        NSString *sNext = [s stringByAppendingString:tagText.string];
//        size = [sNext sizeWithAttributes:@{NSFontAttributeName : font}];
//        //_featureHeight += size.height;
//        if (size.width >= featureWidth - 2) { //calc safe
//            [tagText insertString:@"\n" atIndex:0];
//            //_featureHeight += lineSpaceing;
//            lines++;
//        }
//        [text appendAttributedString:tagText];
//    }
//    text.lineSpacing = lineSpaceing;
//    text.lineBreakMode = NSLineBreakByWordWrapping;
//    featureText.textVerticalAlignment = YYTextVerticalAlignmentTop;
//    featureText.attributedText = text;
//    int count = lines;
//    _featureHeight = count * (-insets.top + size.height - insets.bottom)  + (count-1) * (text.lineSpacing + insets.top + insets.bottom + 6) ;
//    featureText.yy_size = CGSizeMake(featureWidth, _featureHeight);
//    featureText.scrollEnabled = NO;
//}

- (void)setStringArray:(NSArray *)array
{
    if (!array) {
        return;
    }
    
    self.backgroundColor = [UIColor clearColor];
    UIView *superView = self;
    for(UIView *v in superView.subviews) {
        [v removeFromSuperview];
    }
    
    float x = 0;
    float y = 0;
    _featureWidth = 0;
    _featureHeight = 0;
    float lastHeight = 0;
    int tag = 0;
    for(NSString *str in array) {
        WERoundTextView *textView = [WERoundTextView new];
        textView.textBgColor = self.textBgColor;
        textView.textFont = self.textFont;
        textView.textInset = self.textInset;
        textView.cornerRadius = self.cornerRadius;
        textView.onlyBorder = self.onlyBorder;
        textView.tag = TAG_TEXTVIEW_START + tag;
        [self addSubview:textView];
        [textView setString:str];
        
        if (x + [textView getWidth] >= self.maxWidth) {
            x = 0;
            y +=  [textView getHeight] + self.lineSpace;
            _featureWidth = self.maxWidth;
        }
        
        [textView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(x);
            make.top.equalTo(superView.top).offset(y);
            make.width.equalTo([textView getWidth]);
            make.height.equalTo([textView getHeight]);
        }];
        
        x += [textView getWidth] + self.itemSpace;
        lastHeight = [textView getHeight];
        
        if (_allowMultiSelect) {
            UIButton *button = [UIButton new];
            button.backgroundColor = [UIColor clearColor];
            button.tag = TAG_BUTTON_START + tag;
            [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(textView.left);
                make.top.equalTo(textView.top);
                make.right.equalTo(textView.right);
                make.bottom.equalTo(textView.bottom);
            }];
        }
        tag++;
    }
    if (!_featureWidth) {
        _featureWidth = x;
    }
    _featureHeight = y + lastHeight;
    
    _featureWidthMore = _featureWidth;
    _moreButton = [UIButton new];
    _moreButton.backgroundColor = [UIColor clearColor];
    [_moreButton setTitle:@"+ 更多" forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _moreButton.titleLabel.font = _textFont;
    [_moreButton addTarget:self action:@selector(moreButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_moreButton];
    float w = 60;
    float h = lastHeight;
    if (x + w >= self.maxWidth) {
        x = 0;
        y +=  lastHeight + self.lineSpace;
        _featureWidthMore = self.maxWidth;
    }
    [_moreButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.left).offset(x);
        make.top.equalTo(superView.top).offset(y);
        make.width.equalTo(w);
        make.height.equalTo(h);
    }];
    
    if (_showMoreButton) {
        _moreButton.hidden = NO;
    } else {
        _moreButton.hidden = YES;
    }
    
    _featureHeightMore = y + lastHeight;
}


- (float)getHeight
{
    if (_showMoreButton) {
        return _featureHeightMore;
    } else {
        return _featureHeight;
    }
}

- (float)getWidth
{
    if (_showMoreButton) {
        return _featureWidthMore;
    } else {
        return _featureWidth;
    }
}

- (void)buttonTapped:(UIButton *)button
{
    if (!_selectedSet) {
        _selectedSet = [NSMutableSet new];
    }
    int tag = button.tag - TAG_BUTTON_START;
    NSNumber *key = @(tag);
    if ([_selectedSet containsObject:key]) {
        [_selectedSet removeObject:key];
    } else {
        [_selectedSet addObject:key];
    }
    [self updateBg];
}

- (void)updateBg
{
    for(UIView *v in self.subviews) {
        if (v.tag >= TAG_TEXTVIEW_START) {
            WERoundTextView *textView = (WERoundTextView *)v;
            int tag = v.tag - TAG_TEXTVIEW_START;
            NSNumber *key = @(tag);
            if ([_selectedSet containsObject:key]) {
                textView.textBgColor = self.selectedBgColor;
            } else {
                textView.textBgColor = self.textBgColor;
            }
        }
    }
}

- (void)moreButtonTapped:(UIButton *)button
{
    NSLog(@"more button tapped");
}

@end
