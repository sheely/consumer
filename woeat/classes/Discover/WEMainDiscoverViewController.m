//
//  WEMainDiscoverViewController.m
//  woeat
//
//  Created by liubin on 16/10/11.
//  Copyright © 2016年 liubin. All rights reserved.
//

#import "WEMainDiscoverViewController.h"
#import "WEMainTabBarController.h"
#import "WebViewJavascriptBridge.h"
#import "WEHomeKitchenViewController.h"
#import "Reachability.h"
#import "WEBaseNavigationController.h"
#import "WEHomeKitchenDishViewController.h"


@interface WEMainDiscoverViewController ()
{
    UIBarButtonItem *_backItem;
    UIBarButtonItem *_closeItem;
    NSURL *_homeUrl;
}
@property (assign, nonatomic) NSUInteger loadCount;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UIWebView *webView;
@property WebViewJavascriptBridge* bridge;
@end

@implementation WEMainDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    progressView.tintColor = DARK_ORANGE_COLOR;
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    webView.scalesPageToFit = YES;
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    [self.view insertSubview:webView belowSubview:progressView];
    self.webView = webView;
    
    UIImage *backImage = [UIImage imageNamed:@"cc_webview_back"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 22)];
    [backBtn setTintColor:DARK_ORANGE_COLOR];
    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    _backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UIButton *colseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [colseBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [colseBtn setTitleColor:DARK_ORANGE_COLOR forState:UIControlStateNormal];
    [colseBtn addTarget:self action:@selector(closeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [colseBtn sizeToFit];
    _closeItem = [[UIBarButtonItem alloc] initWithCustomView:colseBtn];
    
    self.navigationItem.hidesBackButton = YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [WEBaseNavigationController hideNavBarBottomLine:self];
    
    if (_bridge) { return; }
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
    
    [_bridge registerHandler:@"jumpPage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js called: %@(%@)", data, [data class]);
        NSDictionary *dict = data;
        NSString *page = [dict objectForKey:@"pageName"];
        if ([page isEqualToString:@"FirstPage"]) {
            [[WEMainTabBarController sharedInstance] setTabBarHidden:NO animated:NO];
            [WEMainTabBarController sharedInstance].selectedIndex = 0;
            UIViewController *c = [WEMainTabBarController sharedInstance].selectedViewController;
            if ([c isKindOfClass:[UINavigationController class]]) {
                [(UINavigationController *)c popToRootViewControllerAnimated:NO];
            }
            
            
        } else if ([page isEqualToString:@"KitchenPage"]) {
            NSString *kitchenId = [dict objectForKey:@"kitchenId"];
            NSString *itemId = [dict objectForKey:@"itemId"];
            
            [[WEMainTabBarController sharedInstance] setTabBarHidden:NO animated:NO];
            [WEMainTabBarController sharedInstance].selectedIndex = 0;
            UIViewController *c = [WEMainTabBarController sharedInstance].selectedViewController;
            if ([c isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = c;
                [nav popToRootViewControllerAnimated:NO];
                if (itemId.integerValue) {
                    WEHomeKitchenViewController *kitchenViewController = [WEHomeKitchenViewController new];
                    kitchenViewController.kitchenId = kitchenId;
                    [nav pushViewController:kitchenViewController animated:NO];
                    
                    WEHomeKitchenDishViewController *c = [WEHomeKitchenDishViewController new];
                    c.itemId = itemId;
                    c.kitchenId = kitchenId;
                    [nav pushViewController:c animated:YES];
                } else {
                    WEHomeKitchenViewController *kitchenViewController = [WEHomeKitchenViewController new];
                    kitchenViewController.kitchenId = kitchenId;
                    [nav pushViewController:kitchenViewController animated:YES];
                }
            }
        
        } else if ([page isEqualToString:@"Webpage"]) {
            NSNumber *kitchenId = [dict objectForKey:@"kitchenId"];
            NSNumber *itemId = [dict objectForKey:@"itemId"];
            if (!kitchenId.integerValue) {
                return;
            }
            
            [[WEMainTabBarController sharedInstance] setTabBarHidden:NO animated:NO];
            [WEMainTabBarController sharedInstance].selectedIndex = 0;
            UIViewController *c = [WEMainTabBarController sharedInstance].selectedViewController;
            if ([c isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = c;
                [nav popToRootViewControllerAnimated:NO];
                if (itemId.integerValue) {
                    WEHomeKitchenViewController *kitchenViewController = [WEHomeKitchenViewController new];
                    kitchenViewController.kitchenId = [NSString stringWithFormat:@"%d", kitchenId.integerValue];
                    [nav pushViewController:kitchenViewController animated:NO];
                    
                    WEHomeKitchenDishViewController *c = [WEHomeKitchenDishViewController new];
                    c.itemId = [NSString stringWithFormat:@"%d", itemId.integerValue];
                    //c.itemId = [NSString stringWithFormat:@"%d", 100013];
                    c.kitchenId = [NSString stringWithFormat:@"%d", kitchenId.integerValue];;
                    [nav pushViewController:c animated:YES];
                } else {
                    WEHomeKitchenViewController *kitchenViewController = [WEHomeKitchenViewController new];
                    kitchenViewController.kitchenId = kitchenId;
                    [nav pushViewController:kitchenViewController animated:YES];
                }
            }
        }
        
        responseCallback(@"{response : Response from oc}");
    }];
  
//    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
//    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
//    [_webView loadHTMLString:appHtml baseURL:baseURL];
    
    _homeUrl = [NSURL URLWithString:URL_DISCOVER];
    NSURLRequest *request = [NSURLRequest requestWithURL:_homeUrl];
    [_webView loadRequest:request];

}



- (void)updateBackItem {
    BOOL canBack = NO;
    if (self.webView.canGoBack) {
        canBack = YES;
    }
    if ([[self.webView.request URL] isEqual:_homeUrl]) {
        canBack = NO;
    }

    
    if (canBack) {
        if (self.navigationItem.leftBarButtonItems.count != 2) {
            NSMutableArray *newArr = [NSMutableArray arrayWithObjects:_backItem,_closeItem, nil];
            self.navigationItem.leftBarButtonItems = newArr;
        }
        [[WEMainTabBarController sharedInstance] setTabBarHidden:YES animated:NO];
        
        
    } else {
        if (self.navigationItem.leftBarButtonItems.count != 0) {
            self.navigationItem.leftBarButtonItems = nil;
        }
        [[WEMainTabBarController sharedInstance] setTabBarHidden:NO animated:NO];
    }
}

- (void)backBtnPressed:(id)sender
{

    if (self.webView.canGoBack) {
        [self.webView goBack];
    }
    [self performSelector:@selector(updateBackItem) withObject:nil afterDelay:0.1];
}

- (void)closeBtnPressed:(id)sender
{
    NSURLRequest *request = [NSURLRequest requestWithURL:_homeUrl];
    [self.webView loadRequest:request];
    
}



- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
    [self updateBackItem];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *types[] = {
        @"UIWebViewNavigationTypeLinkClicked",
        @"UIWebViewNavigationTypeFormSubmitted",
        @"UIWebViewNavigationTypeBackForward",
        @"UIWebViewNavigationTypeReload",
        @"UIWebViewNavigationTypeFormResubmitted",
        @"UIWebViewNavigationTypeOther"
    };
    NSLog(@"webView shouldStartLoadWithRequest %@, navigationType %@, origin request %@", request, types[navigationType], webView.request);
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad, req %@", webView.request);
    self.loadCount ++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad, req %@", webView.request);
    self.loadCount --;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"didFailLoadWithError, req %@, error %@", webView.request, error);
    self.loadCount --;
    
    BOOL reachable = (BOOL) [[Reachability reachabilityWithHostName:@"www.baidu.com"] currentReachabilityStatus] != NotReachable;
    if (!reachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络未连接" message:@"您需要网络连接才能访问这部分内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
