//
//  WEIntroViewController.m
//  woeat
//
//  Created by liubin on 16/11/6.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEIntroViewController.h"
#import "AppDelegate.h"
#import "UmengStat.h"

@interface WEIntroViewController ()
{
    NSArray *_imageArray;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    UIButton *_startButton;
}
@end



@implementation WEIntroViewController

- (instancetype)initWithImageArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        _imageArray = array;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;
    
    for (int i = 0; i < _imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [_imageArray objectAtIndex:i];
        
        CGFloat x = i * imageW;
        imageView.frame = CGRectMake(x, 0, imageW, imageH);
        [scrollView addSubview:imageView];
    }
    
    scrollView.contentSize = CGSizeMake(imageW * _imageArray.count, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    _scrollView = scrollView;
    
    float bottom = 30;
    float left = 30;
    float height = 30;
    CGRect r = CGRectMake(left, self.view.bounds.size.height-bottom-height, self.view.bounds.size.width-left*2, height);
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:r];
    pageControl.numberOfPages = _imageArray.count;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = DARK_ORANGE_COLOR;
    [self.view addSubview:pageControl];
    [pageControl addTarget:self action:@selector(pageControlTapped:) forControlEvents:UIControlEventValueChanged];
    _pageControl = pageControl;
    
    UIButton *startButton = [UIButton new];
    [startButton setTitle:@"开始使用" forState:UIControlStateNormal];
    [startButton setTitleColor:UICOLOR(255, 255, 255) forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(startButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    startButton.backgroundColor = DARK_ORANGE_COLOR;
    startButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    startButton.layer.cornerRadius=8.0f;
    startButton.layer.masksToBounds=YES;
    [self.view addSubview:startButton];
    bottom = 80;
    left = 80;
    height = 30;
    r = CGRectMake(left, self.view.bounds.size.height-bottom-height, self.view.bounds.size.width-left*2, height);
    startButton.frame = r;
    if (_imageArray.count > 1) {
        startButton.hidden = YES;
    }
    _startButton = startButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UmengStat pageEnter:UMENG_STAT_PAGE_INTRODUCE];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UmengStat pageLeave:UMENG_STAT_PAGE_INTRODUCE];
}

- (void)showStartButton
{
    _startButton.hidden = NO;
}

- (void)pageControlTapped:(id)sender
{
    [_scrollView setContentOffset:CGPointMake(_pageControl.currentPage * self.view.bounds.size.width, 0) animated:YES];
    if (_pageControl.currentPage == _imageArray.count-1) {
        [self performSelector:@selector(showStartButton) withObject:nil afterDelay:0.2];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = _scrollView.contentOffset.x/self.view.bounds.size.width;
    if (_pageControl.currentPage == _imageArray.count-1) {
        [self performSelector:@selector(showStartButton) withObject:nil afterDelay:0.2];
    }
}

- (void)startButtonClicked:(UIButton *)button
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate selectRootController];
}
@end
