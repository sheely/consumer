//
//  WETimePicker.h
//  woeat
//
//  Created by liubin on 16/12/20.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WETimePicker;

@protocol WETimePickerDelegate <NSObject>
@optional
- (void)pickerView:(WETimePicker *)pickView reslutString1:(NSString *)resultString1;
@end


@interface WETimePicker : UIView
@property(nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,weak) id<WETimePickerDelegate> delegate;
-(instancetype)initWithDefaultString1:(NSString *)s1;
-(void)hide;
-(void)show;
@end
