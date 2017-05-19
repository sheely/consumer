//
//  WETwoTimePicker.m
//  woeat
//
//  Created by liubin on 16/12/19.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WETwoTimePicker.h"
#import "WEUtil.h"

#define SUToobarHeight 40

#define BGColor UICOLOR(224,224,224)
#define BUTTON_COLOR  DARK_ORANGE_COLOR

@interface WETwoTimePicker()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSInteger pikcerViewDefaultIndex;
    NSMutableArray *_hoursArray;
    NSMutableArray *_minsArray;
    int _currentSelectIndex[4];
}
@property (nonatomic,strong) UIView * toolbar;
@property(nonatomic,assign) BOOL isHaveNavControler;//是否有导航
@property(nonatomic,assign) NSInteger pickeviewHeight;//控件高
@property (nonatomic,assign) CGRect showRect;
@property (nonatomic,assign) CGRect hideRect;

@end

@implementation WETwoTimePicker
-(instancetype)initWithDefaultString1:(NSString *)s1 defaultString2:(NSString *)s2{
    
    self=[super init];
    if (self) {
        _hoursArray = [[NSMutableArray alloc] init];
        for (int i = 0; i <= 23; i++)
        {
            [_hoursArray addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        _minsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i <= 59; i++)
        {
            [_minsArray addObject:[NSString stringWithFormat:@"%02d",i]];
        }
        
        [self setUpToolBar];
        [self setUpPickView];
        [self setFrameWith:NO];
        self.backgroundColor = BGColor;
        
        NSArray *array = [s1 componentsSeparatedByString:@":"];
        if (array.count == 2) {
            NSString *hour = array[0];
            NSString *min = array[1];
            _currentSelectIndex[0] = [hour intValue];
            _currentSelectIndex[1] = [min intValue];
        }
        array = [s2 componentsSeparatedByString:@":"];
        if (array.count == 2) {
            NSString *hour = array[0];
            NSString *min = array[1];
            _currentSelectIndex[2] = [hour intValue];
            _currentSelectIndex[3] = [min intValue];
        }
        if (!_currentSelectIndex[0] && !_currentSelectIndex[2] && !_currentSelectIndex[1] && !_currentSelectIndex[3]) {
            _currentSelectIndex[3] += 1;
        }
        [_pickerView selectRow:_currentSelectIndex[0] inComponent:0 animated:NO];
        [_pickerView selectRow:_currentSelectIndex[1] inComponent:2 animated:NO];
        [_pickerView selectRow:_currentSelectIndex[2] inComponent:4 animated:NO];
        [_pickerView selectRow:_currentSelectIndex[3] inComponent:6 animated:NO];
        
    }
    return self;
    
}

-(void)setUpToolBar{
    _toolbar=[self setToolbarStyle];
    _toolbar.frame=CGRectMake(0, 0,[WEUtil getScreenWidth], SUToobarHeight);
    [self addSubview:_toolbar];
}


-(UIView *)setToolbarStyle{
    UIView *toolbar=[[UIView alloc] init];
    toolbar.backgroundColor = BGColor;
    //左按钮
    UIButton * leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 7.5, 65, 25)];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [leftBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:leftBtn];
    leftBtn.layer.cornerRadius = leftBtn.bounds.size.height / 2;
    leftBtn.layer.masksToBounds = YES;
    leftBtn.backgroundColor = BUTTON_COLOR;
    
    //右边
    UIButton * rightBtn = [[UIButton alloc] initWithFrame:CGRectMake([WEUtil getScreenWidth]-10-65, 7.5, 65, 25)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [rightBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.layer.cornerRadius = rightBtn.bounds.size.height / 2;
    rightBtn.layer.masksToBounds = YES;
    rightBtn.backgroundColor = BUTTON_COLOR;
    
    [toolbar addSubview:rightBtn];
    
    return toolbar;
}

-(void)setUpPickView{
    
    UIPickerView *pickView=[[UIPickerView alloc] init];
    _pickerView=pickView;
    pickView.delegate=self;
    pickView.dataSource=self;
    pickView.frame=CGRectMake(0, SUToobarHeight, [UIScreen mainScreen].bounds.size.width, [WEUtil getScreenHeight]/3);
    _pickeviewHeight=pickView.frame.size.height;
    [self addSubview:pickView];
}

-(void)setFrameWith:(BOOL)isHaveNavControler{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = _pickeviewHeight+SUToobarHeight;
    CGFloat toolViewY;
    CGFloat toolViewY1;
    if (isHaveNavControler) {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH-50;
    }else {
        toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH;
    }
    if (isHaveNavControler) {
        toolViewY1= [UIScreen mainScreen].bounds.size.height - 50;
    }else {
        toolViewY1= [UIScreen mainScreen].bounds.size.height;
    }
    
    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(toolViewX, toolViewY1, toolViewW, toolViewH);
    _hideRect = CGRectMake(toolViewX, toolViewY1, toolViewW, toolViewH);
    _showRect = CGRectMake(toolViewX, toolViewY, toolViewW, toolViewH);
}


-(void)hide
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = _hideRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

-(void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = _showRect;
    }];
    
}

- (BOOL)isValidSelect
{
    int hour1 = [_pickerView selectedRowInComponent:0];
    int min1 = [_pickerView selectedRowInComponent:2];
    int hour2 = [_pickerView selectedRowInComponent:4];
    int min2 = [_pickerView selectedRowInComponent:6];
    if (hour1 < hour2) {
        return YES;
    }
    if (hour1 == hour2) {
        if (min1 < min2) {
            return YES;
        }
    }
    return NO;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (![self isValidSelect]) {
        if (component == 0) {
            [_pickerView selectRow:_currentSelectIndex[0] inComponent:0 animated:YES];
        } else if (component == 2) {
            [_pickerView selectRow:_currentSelectIndex[1] inComponent:2 animated:YES];
        } else if (component == 4) {
            [_pickerView selectRow:_currentSelectIndex[2] inComponent:4 animated:YES];
        } else if (component == 6) {
            [_pickerView selectRow:_currentSelectIndex[3] inComponent:6 animated:YES];
        }
    }
    
    _currentSelectIndex[0] = [pickerView selectedRowInComponent:0];
    _currentSelectIndex[1] = [pickerView selectedRowInComponent:2];
    _currentSelectIndex[2] = [pickerView selectedRowInComponent:4];
    _currentSelectIndex[3] = [pickerView selectedRowInComponent:6];
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return _hoursArray[row];
            
        case 1:
            return @":";
            
        case 2:
            return _minsArray[row];
            
        case 3:
            return  @"~";
            
        case 4:
            return _hoursArray[row];
            
        case 5:
            return @":";
            
        case 6:
            return _minsArray[row];
            
        default:
            break;
    }
    return @"";
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0 || component == 2 || component == 4 || component == 6) {
        if (component == 6) {
            return [WEUtil getScreenWidth]/8+10;
        }
        return [WEUtil getScreenWidth]/8;
    } else if (component == 1 || component == 5) {
        return 20;
    } else {
        return 50;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 7;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            return [_hoursArray count];
            
            
        case 1:
            return 1;
            
        case 2:
            return [_minsArray count];
            
        case 3:
            return 1;
            
        case 4:
            return [_hoursArray count];
            
        case 5:
            return 1;
            
        case 6:
            return [_minsArray count];
            
        default:
            break;
    }
    return 0;
}


//toolbar 按钮的监听
-(void)doneClick
{
    NSString *s1 = [NSString stringWithFormat:@"%@:%@", _hoursArray[_currentSelectIndex[0]], _minsArray[_currentSelectIndex[1]]];
    NSString *s2 = [NSString stringWithFormat:@"%@:%@", _hoursArray[_currentSelectIndex[2]], _minsArray[_currentSelectIndex[3]]];
    
    if ([self.delegate respondsToSelector:@selector(pickerView:reslutString1:reslutString2:)]) {
        [self.delegate pickerView:self reslutString1:s1 reslutString2:s2];
    }
    [self hide];
}

- (void)cancelClick
{
    if ([self.delegate respondsToSelector:@selector(pickerView:reslutString1:reslutString2:)]) {
        [self.delegate pickerView:nil  reslutString1:nil reslutString2:nil];
    }
    [self hide];
}

/**
 *  设置PickView的颜色
 */
-(void)setPickViewColer:(UIColor *)color{
    _pickerView.backgroundColor=color;
}
@end
