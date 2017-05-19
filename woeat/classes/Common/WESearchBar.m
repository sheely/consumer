//
//  WESearchBar.m
//  woeat
//
//  Created by liubin on 16/12/22.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WESearchBar.h"

@interface WESearchBar()
{
    MASConstraint *_cancelButtonRightConstraint;
}
@property (nonatomic) UIButton *cancelButton;
@property (nonatomic) UIImageView *searchImageView;
@property (nonatomic) UIView *roundCornerView;

@property (nonatomic) UIImage *searchImage;

@end

@implementation WESearchBar

- (void)setDefaults {
    
    UIImage *searchIcon = [UIImage imageNamed:@"search-icon"];
    _searchImage = searchIcon;
    self.backgroundColor = UICOLOR(234, 234, 234);
    
    self.roundCornerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.roundCornerView.backgroundColor = [UIColor whiteColor];
    self.roundCornerView.layer.cornerRadius = 18;
    self.roundCornerView.layer.masksToBounds = YES;
    [self addSubview:self.roundCornerView];
    
    //Search Image
    self.searchImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.searchImageView.image = self.searchImage;
    self.searchImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.searchImageView];
    
    //TextField
    self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.textField.font = [UIFont systemFontOfSize:13];
    self.textField.textColor = [UIColor blackColor];
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:self.textField];
    //self.textField.clipsToBounds = NO;
    
    //Cancel Button
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:UICOLOR(61,194,164) forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.cancelButton addTarget:self action:@selector(pressedCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    
    UIView *superview = self;
    [self.roundCornerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.top).offset(6);
        make.left.equalTo(superview.left).offset(12);
        make.bottom.equalTo(superview.bottom).offset(-6);
    }];
    
    [self.searchImageView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(14);
        make.height.equalTo(15);
        make.left.equalTo(self.roundCornerView.left).offset(12);
        make.centerY.equalTo(superview.centerY);
    }];
    
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.roundCornerView.left).offset(34);
        make.right.equalTo(self.roundCornerView.right).offset(0);
        make.height.equalTo(superview.height).offset(-14);
        make.centerY.equalTo(superview.centerY);
    }];
    
    [self.cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.roundCornerView.right);
        _cancelButtonRightConstraint = make.right.equalTo(superview.right);
        make.centerY.equalTo(superview.centerY);
        make.width.equalTo(54);
    }];
    [self.cancelButton setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                         forAxis:UILayoutConstraintAxisHorizontal];
    [self.cancelButton setContentCompressionResistancePriority:UILayoutPriorityRequired
                                                       forAxis:UILayoutConstraintAxisHorizontal];
    
    //Listen to text changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:self.textField];
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}


- (NSString *)text {
    return self.textField.text;
}
- (void)setText:(NSString *)text {
    self.textField.text = text;
}
- (NSString *)placeholder {
    return self.textField.placeholder;
}
- (void)setPlaceholder:(NSString *)placeholder {
    self.textField.placeholder = placeholder;
}

- (UIFont *)font {
    return self.textField.font;
}
- (void)setFont:(UIFont *)font {
    self.textField.font = font;
}

- (BOOL)isCancelButtonHidden {
    return _cancelButtonHidden;
}
- (void)setCancelButtonHidden:(BOOL)cancelButtonHidden {
    
    if (_cancelButtonHidden != cancelButtonHidden) {
        _cancelButtonHidden = cancelButtonHidden;
        self.cancelButton.hidden = cancelButtonHidden;
        if (_cancelButtonHidden) {
            _cancelButtonRightConstraint.offset(50-12);
        } else {
            _cancelButtonRightConstraint.offset(0);
        }
    }
}

- (void)pressedCancel: (id)sender {
    if ([self.searchDelegate respondsToSelector:@selector(searchBarCancelButtonClicked:)])
        [self.searchDelegate searchBarCancelButtonClicked:self];
}

#pragma mark - Text Delegate

- (void)textChanged: (id)sender {
    if ([self.searchDelegate respondsToSelector:@selector(searchBar:textDidChange:)])
        [self.searchDelegate searchBar:self textDidChange:self.text];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([self.searchDelegate respondsToSelector:@selector(searchBarShouldBeginEditing:)])
        return [self.searchDelegate searchBarShouldBeginEditing:self];
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.searchDelegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)])
        [self.searchDelegate searchBarTextDidBeginEditing:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.searchDelegate respondsToSelector:@selector(searchBarTextDidEndEditing:)])
        [self.searchDelegate searchBarTextDidEndEditing:self];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.searchDelegate respondsToSelector:@selector(searchBarSearchButtonClicked:)])
        [self.searchDelegate searchBarSearchButtonClicked:self];
    
    return YES;
}

- (BOOL)isFirstResponder {
    return [self.textField isFirstResponder];
}
- (BOOL)becomeFirstResponder {
    return [self.textField becomeFirstResponder];
}
- (BOOL)resignFirstResponder {
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark - Cleanup

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
