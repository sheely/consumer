//
//  WEPersonalSettingViewController.m
//  woeat
//
//  Created by liubin on 16/11/26.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEPersonalSettingViewController.h"
#import "WEUtil.h"
#import "WENetUtil.h"
#import "UIImageView+WebCache.h"
#import "TNRadioButtonGroup.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "WEProfileImage.h"
#import "MBProgressHUD.h"
#import "WEUserDataManager.h"
#import "UmengStat.h"

#define THUMBNAIL_SIZE CGSizeMake(140, 140)

@interface WEPersonalSettingViewController ()
{
    UIScrollView *_scrollView;
    
    UITableView *_infoTableView;
    MASConstraint *_infoTableViewHeightConstraint;
    
    UITextField *_nickTextField;
    TNRadioButtonGroup *_checkGroup;
    BOOL _placeHolder;
    
    NSString *_nickContent;
    BOOL _genderIsMale;
    UIImageView *_personView;
    BOOL _imageChanged;
    NSString *_imageId;
}
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
@end

@implementation WEPersonalSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.returnKeyHandler = nil;
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDefault;
    [IQKeyboardManager sharedManager].toolbarManageBehaviour = IQAutoToolbarBySubviews;
    //[IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 50;

    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    self.title = @"我的";
    self.view.backgroundColor = UICOLOR(255,255,255);
    UIView *superView = self.view;
    
    //scroll
    UIScrollView *scrollView = [UIScrollView new];
    [superView addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    [scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    _scrollView = scrollView;
    
    //content
    superView = scrollView;
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor clearColor];
    [superView addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView.top);
        make.left.equalTo(scrollView.left);
        make.right.equalTo(scrollView.right);
        make.bottom.equalTo(scrollView.bottom);
        make.width.equalTo([WEUtil getScreenWidth]);
    }];
    
    superView = contentView;
    
    UIImageView *personView = [UIImageView new];
    personView.backgroundColor = [UIColor lightGrayColor];
    float radius = THUMBNAIL_SIZE.height/2;
    personView.layer.cornerRadius = radius;
    personView.layer.masksToBounds = YES;
    [superView addSubview:personView];
    [personView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.centerX);
        make.top.equalTo(superView.top).offset(20);
        make.width.equalTo(radius*2);
        make.height.equalTo(radius*2);
    }];
    _personView = personView;
    _personView.image = [WEProfileImage loadProfileImage];
    
    UILabel *personName = [UILabel new];
    personName.backgroundColor = [UIColor clearColor];
    personName.textColor = DARK_ORANGE_COLOR;
    personName.font = [UIFont systemFontOfSize:14];
    personName.textAlignment = NSTextAlignmentCenter;
    [superView addSubview:personName];
    [personName sizeToFit];
    [personName makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(personView.centerX);
        make.top.equalTo(personView.bottom).offset(10);
    }];
    personName.text = @"更换头像";
    
    UIButton *takeButton = [UIButton new];
    takeButton.backgroundColor = [UIColor clearColor];
    [takeButton addTarget:self action:@selector(takeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:takeButton];
    [takeButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(personView.left);
        make.right.equalTo(personView.right);
        make.top.equalTo(personView.top);
        make.bottom.equalTo(personName.bottom);
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    [superView addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(takeButton.bottom).offset(20);
        make.left.equalTo(superView.left);
        make.right.equalTo(superView.right);
        _infoTableViewHeightConstraint = make.height.equalTo(400);
        make.bottom.equalTo(superView.bottom).offset(-20);
    }];
    _infoTableView = tableView;
    
    _nickContent = [[WEUserDataManager sharedInstance] getNick];
    _genderIsMale = [[WEUserDataManager sharedInstance] isMale];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addRightNavButton:@"保存" image:nil target:self selector:@selector(rightButtonTapped:)];
    [UmengStat pageEnter:UMENG_STAT_PAGE_SETTING];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateTableHeight];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
     [UmengStat pageLeave:UMENG_STAT_PAGE_SETTING];
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

- (void)uploadImage
{
    NSLog(@"uploadImage");
    UIImage *image = [WEProfileImage loadProfileImage];
    [WENetUtil UploadWithImage:image
                       success:^(NSURLSessionDataTask *task, id responseObject) {
                           NSDictionary *dict = responseObject;
                           _imageId = [dict objectForKey:@"Id"];
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [self uploadImageId];
                           });
                           
                       } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                           NSLog(@"failure %@", errorMsg);
                           MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                           hud.labelText = errorMsg;
                           [hud hide:YES afterDelay:1.5];
                       }];
}

- (void)uploadImageId
{
    NSLog(@"uploadImageId");
    [WENetUtil UpdateUserImageWithImageId:_imageId
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self uploadDetail];
                                      });
                                      
                                  }
                                  failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                      NSLog(@"failure %@", errorMsg);
                                      MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                                      hud.labelText = errorMsg;
                                      [hud hide:YES afterDelay:1.5];
                                  }];
    
}

- (void)uploadDetail
{
    NSLog(@"uploadDetail");
    [WENetUtil UpdateUserDetailsWithDisplayName:_nickTextField.text
                                         isMale:_genderIsMale
                                        success:^(NSURLSessionDataTask *task, id responseObject) {
                                            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                                            hud.labelText = @"保存成功";
                                            hud.delegate = self;
                                            [hud hide:YES afterDelay:1];
                                            [[WEUserDataManager sharedInstance] setMale:_genderIsMale];
                                            [[WEUserDataManager sharedInstance] setNick:_nickTextField.text];
                                            
                                        } failure:^(NSURLSessionDataTask *task, NSString *errorMsg) {
                                            NSLog(@"failure %@", errorMsg);
                                            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
                                            hud.labelText = errorMsg;
                                            [hud hide:YES afterDelay:1.5];
                                        }];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightButtonTapped:(UIButton *)button
{
    if (!_nickTextField.text.length) {
        [self showErrorHud:@"请填写昵称"];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        //hud.yOffset = -30;
        [self.view addSubview:hud];
    }
    hud.labelText = @"正在保存，请稍后...";
    [hud show:YES];
    
    if (_imageChanged) {
        [self uploadImage];
    } else {
        [self uploadDetail];
    }
}


- (void)updateTableHeight
{
    _infoTableViewHeightConstraint.equalTo(_infoTableView.contentSize.height);
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifer = nil;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *superView = cell.contentView;

    float offsetX = 20;
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
        _nickTextField = field;
        if (_nickContent.length) {
            _nickTextField.text = _nickContent;
        }
        
    } else if (indexPath.section == 1) {
        TNImageRadioButtonData *data1 = [TNImageRadioButtonData new];
        data1.labelFont = [UIFont systemFontOfSize:13];
        data1.labelActiveColor = [UIColor lightGrayColor];
        data1.labelPassiveColor = [UIColor lightGrayColor];
        data1.labelText = @"男";
        data1.identifier = @"0";
        data1.selected = _genderIsMale;
        data1.unselectedImage = [UIImage imageNamed:@"icon_circle_uncheck"];
        data1.selectedImage = [UIImage imageNamed:@"icon_circle_check"];
        data1.labelOffset = 5;
        
        TNImageRadioButtonData *data2 = [TNImageRadioButtonData new];
        data2.labelFont = [UIFont systemFontOfSize:13];
        data2.labelActiveColor = [UIColor lightGrayColor];
        data2.labelPassiveColor = [UIColor lightGrayColor];
        data2.labelText = @"女";
        data2.identifier = @"1";
        data2.selected = !_genderIsMale;
        data2.unselectedImage = [UIImage imageNamed:@"icon_circle_uncheck"];
        data2.selectedImage = [UIImage imageNamed:@"icon_circle_check"];
        data2.labelOffset = 5;
        
        TNRadioButtonGroup *group = [[TNRadioButtonGroup alloc] initWithRadioButtonData:@[data1, data2] layout:TNRadioButtonGroupLayoutHorizontal];
        group.marginBetweenItems = 30;
        group.identifier = @"group";
        [group create];
        group.position = CGPointMake(20, 15);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentCheckGroupUpdated:) name:SELECTED_RADIO_BUTTON_CHANGED object:group];
        [group update];
        _checkGroup = group;
        
         [superView addSubview:_checkGroup];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
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
        label.text = @"昵称";
    } else if (section == 1) {
        label.text = @"性别";
    }
    return bg;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)commentCheckGroupUpdated:(NSNotification *)notification {
    NSString *iden = _checkGroup.selectedRadioButton.data.identifier;
    NSLog(@"group updated to %@", _checkGroup.selectedRadioButton.data.identifier);
    if ([iden integerValue]) {
        _genderIsMale = NO;
    } else {
        _genderIsMale = YES;
    }
}

- (void)takeButtonTapped:(UIButton *)button
{
    [_nickTextField resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照",
                                  @"从相册选择",
                                  nil];
    [actionSheet showInView:self.view];
}

-(void) actionSheet :(UIActionSheet *) actionSheet didDismissWithButtonIndex:(NSInteger) buttonIndex
{
    UIImagePickerControllerSourceType sourceType;
    
    if ( buttonIndex == [actionSheet firstOtherButtonIndex]) {
        sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ( buttonIndex == [actionSheet firstOtherButtonIndex] + 1) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        return;
    }
    
    UIImagePickerController *imagePickerController;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = sourceType;
        imagePickerController.allowsEditing = YES;
        [self presentModalViewController:imagePickerController animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    UIImage *thumnb = [WEUtil imageByScalingAndCroppingForSize:image targetSize:THUMBNAIL_SIZE];
    _personView.image = thumnb;
    
    [WEProfileImage saveProfileImage:thumnb];
    _imageChanged = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PROFILE_IMAGE_RELOAD object:nil];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    _nickContent = newText;
    return YES;
    
}

@end
