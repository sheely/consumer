//
//  WEPersonalAddressEditViewController.m
//  woeat
//
//  Created by liubin on 16/11/28.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEPersonalAddressEditViewController.h"
#import "WERightImageLeftLabelButton.h"
#import "WEUtil.h"
#import "MBProgressHUD.h"
#import "WEAddress.h"
#import "WEAddressManager.h"
#import "WESearchCityViewController.h"
#import "WEState.h"
#import "WECity.h"
#import "WEOrderConfirmViewController.h"
#import "WENetUtil.h"
#import "UmengStat.h"

@interface WEPersonalAddressEditViewController ()
{
    UITableView *_tableView;
    
    UITextField *_nameField;
    UITextField *_phoneField;
    UITextField *_streetField;
    UITextField *_codeField;
    WERightImageLeftLabelButton *_stateButton;
    WERightImageLeftLabelButton *_cityButton;
    NSString *_name;
    NSString *_phone;
    NSString *_street;
    NSString *_code;
    int _stateId;
    NSString *_stateName;
    NSString *_cityName;
}
@end

@implementation WEPersonalAddressEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    float offsetX = 15;
    
    UITableView *tableView = [UITableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.delegate = self;
    tableView.dataSource = self;
    [superView addSubview:tableView];
    tableView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.equalTo(superView.left);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.right.equalTo(superView.right);
    }];
    _tableView = tableView;
    
    [self initData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_address.personName.length || _address.house.length) {
        self.title = @"编辑送餐地址";
    } else {
        self.title = @"添加送餐地址";
    }
    
    [self addRightNavButton:@"保存" image:nil target:self selector:@selector(rightButtonTapped:)];
    [UmengStat pageEnter:UMENG_STAT_PAGE_ADDRESS_EDIT];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengStat pageLeave:UMENG_STAT_PAGE_ADDRESS_EDIT];
}


- (void)initData
{
    _name = _address.personName;
    _phone = _address.phone;
    _street = _address.house;
    _code = _address.postCode;
    _stateId = _address.stateId.integerValue;
    _stateName = _address.stateName;
    _cityName = _address.cityName;
}

- (void)showErrorHud:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = text;
    [hud show:YES];
    
    [hud hide:YES afterDelay:2];
}

- (void)rightButtonTapped:(UIButton *)button
{
    if (!_name.length) {
        [self showErrorHud:@"请填写姓名"];
        return;
    }
    if (!_phone.length) {
        [self showErrorHud:@"请填写电话号码"];
        return;
    }
    if (!_street.length) {
        [self showErrorHud:@"请填写送餐地址"];
        return;
    }
    if (!_code.length) {
        [self showErrorHud:@"请填写邮政编码"];
        return;
    }
    if (!_stateName.length) {
        [self showErrorHud:@"请选择州"];
        return;
    }
    if (!_cityName.length) {
        [self showErrorHud:@"请选择城市"];
        return;
    }

    
    if (_address) {
        _address.personName = _name;
        _address.phone = _phone;
        _address.house = _street;
        _address.postCode = _code;
        _address.cityName = _cityName;
        _address.stateName = _stateName;
        _address.stateId = @(_stateId);
        [[WEAddressManager sharedInstance] modifyAddress:_address withDelegate:nil];
    } else {
        WEAddress *a = [WEAddress new];
        a.personName = _name;
        a.phone = _phone;
        a.house = _street;
        a.postCode = _code;
        a.cityName = _cityName;
        a.stateName = _stateName;
        a.stateId = @(_stateId);
        [[WEAddressManager sharedInstance] addAddress:a withDelegate:self];
    }
    if (!_address) {
        MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
        if (!hud) {
            hud = [[MBProgressHUD alloc] initWithView:self.view];
            //hud.yOffset = -30;
            [self.view addSubview:hud];
        }
        hud.labelText = @"正在保存地址，请稍后...";
        [hud show:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    float offsetX = 20;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *superView = cell.contentView;
    
    if (indexPath.section == 0) {
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectZero];
        field.backgroundColor = [UIColor clearColor];
        field.delegate = self;
        field.autocapitalizationType = UITextAutocapitalizationTypeNone;
        field.autocorrectionType = UITextAutocorrectionTypeNo;
        field.font = [UIFont systemFontOfSize:13];
        field.textColor = [UIColor blackColor];
        field.keyboardType = UIKeyboardTypeDefault;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.placeholder = @"联系人姓名";
        [superView addSubview:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.right.equalTo(superView.right).offset(-offsetX);
            make.top.equalTo(superView.top);
            make.bottom.equalTo(superView.bottom);
        }];
        _nameField = field;

    } else if (indexPath.section == 1) {
        UITextField *field = [[UITextField alloc] initWithFrame:CGRectZero];
        field.backgroundColor = [UIColor clearColor];
        field.delegate = self;
        field.autocapitalizationType = UITextAutocapitalizationTypeNone;
        field.autocorrectionType = UITextAutocorrectionTypeNo;
        field.font = [UIFont systemFontOfSize:13];
        field.textColor = [UIColor blackColor];
        field.keyboardType = UIKeyboardTypePhonePad;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.placeholder = @"未填写";
        [superView addSubview:field];
        [field makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.right.equalTo(superView.right).offset(-offsetX);
            make.top.equalTo(superView.top);
            make.bottom.equalTo(superView.bottom);
        }];
        _phoneField = field;
       
    
    } else if (indexPath.section == 2) {
        UITextField *street = [[UITextField alloc] initWithFrame:CGRectZero];
        street.backgroundColor = [UIColor clearColor];
        street.delegate = self;
        street.autocapitalizationType = UITextAutocapitalizationTypeNone;
        street.autocorrectionType = UITextAutocorrectionTypeNo;
        street.font = [UIFont systemFontOfSize:13];
        street.textColor = [UIColor blackColor];
        street.keyboardType = UIKeyboardTypeDefault;
        street.clearButtonMode = UITextFieldViewModeWhileEditing;
        street.placeholder = @"街道地址";
        [superView addSubview:street];
        [street makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset(offsetX);
            make.right.equalTo(superView.right).offset(-offsetX);
            make.top.equalTo(superView.top).offset(15);
            make.height.equalTo(20);
        }];
        _streetField = street;
        
        
        UIImage *grayArrow = [UIImage imageNamed:@"icon_arrow_gray"];
        WERightImageLeftLabelButton *stateButton = [[WERightImageLeftLabelButton alloc] initWithImage:grayArrow title:@"州"];
        stateButton.label.textColor = [UIColor blackColor];
        [stateButton addTarget:self action:@selector(stateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:stateButton];
        [stateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(street.left);
            make.top.equalTo(street.bottom).offset(15);
            make.width.equalTo([WEUtil getScreenWidth]*0.45);
            make.height.equalTo(30);
        }];
        _stateButton = stateButton;

        WERightImageLeftLabelButton *cityButton = [[WERightImageLeftLabelButton alloc] initWithImage:grayArrow title:@"城市"];
        cityButton.label.textColor = [UIColor blackColor];
        [cityButton addTarget:self action:@selector(cityButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [superView addSubview:cityButton];
        [cityButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.left).offset([WEUtil getScreenWidth]*0.5 + 15);
            make.centerY.equalTo(stateButton.centerY);
            make.right.equalTo(superView.right).offset(-offsetX);
            make.height.equalTo(stateButton.height);
        }];
        _cityButton = cityButton;
        
        UITextField *code = [[UITextField alloc] initWithFrame:CGRectZero];
        code.backgroundColor = [UIColor clearColor];
        code.delegate = self;
        code.autocapitalizationType = UITextAutocapitalizationTypeNone;
        code.autocorrectionType = UITextAutocorrectionTypeNo;
        code.font = [UIFont systemFontOfSize:13];
        code.textColor = [UIColor blackColor];
        code.keyboardType = UIKeyboardTypeNumberPad;
        code.clearButtonMode = UITextFieldViewModeWhileEditing;
        code.placeholder = @"邮编";
        [superView addSubview:code];
        [code makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(stateButton.left);
            make.right.equalTo(superView.right).offset(-offsetX);
            make.top.equalTo(stateButton.bottom).offset(15);
            make.height.equalTo(30);
        }];
        _codeField = code;
        
    }
    
    _nameField.text = _name;
    _streetField.text = _street;
    _phoneField.text = _phone;
    _codeField.text = _code;
    if (_stateName.length) {
        _stateButton.label.text = [NSString stringWithFormat:@"州 %@", _stateName];
        _stateButton.label.textColor = [UIColor blackColor];
    } else {
        _stateButton.label.text = @"州";
        _stateButton.label.textColor = [UIColor lightGrayColor];
    }
    if (_cityName.length) {
        _cityButton.label.text = [NSString stringWithFormat:@"城市 %@", _cityName];
        _cityButton.label.textColor = [UIColor blackColor];
    } else {
        _cityButton.label.text = @"城市";
        _cityButton.label.textColor = [UIColor lightGrayColor];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return 40;
    } else {
        return 150;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bg = [UIView new];
    bg.backgroundColor = UICOLOR(200, 200, 200);
    bg.frame = CGRectMake(0, 0, [WEUtil getScreenWidth], 40);
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    label.frame = CGRectMake(20, 0, 200, 40);
    [bg addSubview:label];
    if (section == 0) {
        label.text = @"联系人";
    } else if (section == 1) {
        label.text = @"手机号码";
    } else if (section == 2) {
        label.text = @"地址";
    }
    return bg;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)stateButtonTapped:(UIButton *)button
{
    WESearchCityViewController *c = [WESearchCityViewController new];
    c.stateId = 0;
    c.searchDelegate = self;
    [self.navigationController pushViewController:c animated:YES];
}

- (void)cityButtonTapped:(UIButton *)button
{
    if (!_stateId) {
        [self showErrorHud:@"请先选择州"];
        return;
    }
    WESearchCityViewController *c = [WESearchCityViewController new];
    c.stateId = _stateId;
    c.searchDelegate = self;
    [self.navigationController pushViewController:c animated:YES];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == _nameField) {
        _name = textField.text;
    } else if (textField == _phoneField) {
        _phone = textField.text;
    }  else if (textField == _streetField) {
        _street = textField.text;
    }  else if (textField == _codeField) {
        _code = textField.text;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == _nameField) {
        _name = newText;
    } else if (textField == _phoneField) {
        _phone = newText;
    }  else if (textField == _streetField) {
        _street = newText;
    }  else if (textField == _codeField) {
        _code = newText;
    }
    
    return YES;
    
}

- (void)userSelecteState:(WEState *)state
{
    _stateName = state.Name;
    _stateId = state.stateId;
    _cityName = nil;
    [_tableView reloadData];
    
}
- (void)userSelecteCity:(WECity *)city
{
    _cityName = city.Name;
    [_tableView reloadData];
}

- (void)addFinished
{
    
}

- (void)loadStart
{
    
}

- (void)loadFinished
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (hud) {
        [hud hide:YES afterDelay:0];
    }
    NSArray *controllers = self.navigationController.viewControllers;
    if (controllers.count > 3) {
        UIViewController *c = controllers[controllers.count-3];
        if ([c isKindOfClass:[WEOrderConfirmViewController class]]) {
            [[WEAddressManager sharedInstance] selectLastAdd];
            [self.navigationController popToViewController:c animated:YES];
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    return;
}
@end
