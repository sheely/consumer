//
//  WETwoTimePicker.h
//  woeat
//
//  Created by liubin on 16/12/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WETwoTimePicker;

@protocol WETwoTimePickerDelegate <NSObject>
@optional
- (void)pickerView:(WETwoTimePicker *)pickView reslutString1:(NSString *)resultString1 reslutString2:(NSString *)resultString2;
@end

@interface WETwoTimePicker : UIView
@property(nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,weak) id<WETwoTimePickerDelegate> delegate;
-(instancetype)initWithDefaultString1:(NSString *)s1 defaultString2:(NSString *)s2;
-(void)hide;
-(void)show;
@end
