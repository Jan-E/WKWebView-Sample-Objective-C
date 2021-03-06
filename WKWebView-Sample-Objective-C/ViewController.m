//
//  ViewController.m
//  WKWebView-Sample-Objective-C
//
//  Created by kawaharadai on 2018/04/08.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
@property (nonatomic) NSInteger whatsapp;
@property (nonatomic) BOOL lockInterfaceRotation;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic) WKWebView *webView;
@property (strong,atomic) NSString *model;
@end

static NSString *const RequestURL = @"https://pmto.sessiedatabase.nl/ivieww.php?movie=nl132557.opt.mp4";
static NSString *const RequestRSP = @"https://rading.sessionportal.net/tfrshoww.php?movie=ra000013.opt.mp4";
//static NSString *const RequestAPP = @"https://fimpcentral.net/";
static NSString *const RequestAPP = @"https://web.whatsapp.com/";
static NSString *const RequestMAC = @"https://hls-js.netlify.com/demo/?src=https://video.sessionportal.net/public/mp4:sportplezier.mp4/playlist.m3u8";

@implementation ViewController

- (BOOL)shouldAutorotate
{
    // Disable autorotation of the interface when recording is in progress.
    return ![self lockInterfaceRotation];
}

#pragma mark - LifeCycle Methods
- (void)viewDidLoad {
    self.model = [[UIDevice currentDevice] model];
    NSLog(@"Model: %@", self.model);
    if ([self.model isEqual: @"iPad"]) {
        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
        [UINavigationController attemptRotationToDeviceOrientation];
        [self setLockInterfaceRotation:YES];
    }
    if ([self.model isEqual: @"iPhone"]) {
        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
        [UINavigationController attemptRotationToDeviceOrientation];
        [self setLockInterfaceRotation:YES];
    }
    [self setWhatsapp:2];
    [super viewDidLoad];
    [self setup];
}

#pragma mark - Private Methods
- (void)setup {
    if (self.whatsapp == 0) {
        NSString *urlAddress = [NSString stringWithFormat:RequestURL];
        //NSString *postString = [NSString stringWithFormat:@"uid=%ld&username=%@&password=%@&height=%d&width=%d&fh=%d&fw=%d",
        //                        (long)44,
        //                        @"username",
        //                        @"password",
        //                        352,
        //                        288,
        //                        448,
        //                        256
        //                        ];
        //NSData *data = [postString dataUsingEncoding:NSASCIIStringEncoding];
        NSLog(@"URL on portal: %@", urlAddress);
        //NSLog(@"postString %@", postString);
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSMutableURLRequest *requestObj = [[NSMutableURLRequest alloc] initWithURL:url];
        //[requestObj setHTTPMethod:@"POST"];
        //[requestObj setHTTPBody:data];

        if ([self.model isEqual: @"iPhone"]) {
            self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 320) configuration: [self setJS]];
        } else {
            self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(607, 165, 352, 292) configuration: [self setJS]];
        }
        self.webView.navigationDelegate = self;
        self.webView.UIDelegate = self;
        [self.view addSubview:_webView];
        [self.webView loadRequest:requestObj];
        
        self.webView.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.webView.layer.borderColor = [UIColor grayColor].CGColor;
        self.webView.layer.borderWidth = 5.0;
    } else if (self.whatsapp == 1) {
        NSString *urlAddress = [NSString stringWithFormat:RequestRSP];
        //NSString *postString = [NSString stringWithFormat:@"uid=%ld&username=%@&password=%@&height=%d&width=%d&fh=%d&fw=%d",
        //                        (long)44,
        //                        @"username",
        //                        @"password",
        //                        352,
        //                        288,
        //                        448,
        //                        256
        //                        ];
        //NSData *data = [postString dataUsingEncoding:NSASCIIStringEncoding];
        NSLog(@"URL on portal: %@", urlAddress);
        //NSLog(@"postString %@", postString);
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSMutableURLRequest *requestObj = [[NSMutableURLRequest alloc] initWithURL:url];
        //[requestObj setHTTPMethod:@"POST"];
        //[requestObj setHTTPBody:data];

        if ([self.model isEqual: @"iPhone"]) {
            self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 320) configuration: [self setJS]];
        } else {
            self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(607, 165, 352, 292) configuration: [self setJS]];
        }
        self.webView.navigationDelegate = self;
        self.webView.UIDelegate = self;
        [self.view addSubview:_webView];
        [self.webView loadRequest:requestObj];
        
        self.webView.layer.backgroundColor = [UIColor clearColor].CGColor;
        self.webView.layer.borderColor = [UIColor grayColor].CGColor;
        self.webView.layer.borderWidth = 5.0;
    } else {
        // self.whatsapp == 2
        NSString *urlAddress = [NSString stringWithFormat:RequestAPP];
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSMutableURLRequest *requestObj = [[NSMutableURLRequest alloc] initWithURL:url];

        if ([self.model isEqual: @"iPhone"]) {
            int extraSpace = !self.lockInterfaceRotation ? 8 : 0;
            self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 576, 312 + extraSpace) configuration: [self setJS]];
        } else {
            self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 1024, 758) configuration: [self setJS]];
        }
        self.webView.navigationDelegate = self;
        self.webView.UIDelegate = self;
        self.webView.customUserAgent = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.1 Safari/605.1.15";
        [self.view addSubview:_webView];
        [self.webView loadRequest:requestObj];
    }
}

- (void)setURL:(NSString *)requestURLString {
    NSURL *url = [[NSURL alloc] initWithString: requestURLString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url
                                                  cachePolicy: NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval: 5];
    [self.webView loadRequest: request];
}

/// JSをセット（生成時に仕込み。JS側でトリガーする）
- (WKWebViewConfiguration *)setJS {
    NSString *jsString = @"";
    WKUserScript *userScript = [[WKUserScript alloc] initWithSource: jsString
                                                      injectionTime: WKUserScriptInjectionTimeAtDocumentEnd
                                                   forMainFrameOnly:YES];
    WKUserContentController *wkUController = [WKUserContentController new];
    [wkUController addUserScript: userScript];
    // JSを判別するためのキーを設定
    [wkUController addScriptMessageHandler:self name:@"callbackHandler"];
    
    WKWebViewConfiguration *wkWebConfig = [WKWebViewConfiguration new];
    wkWebConfig.userContentController = wkUController;
    
    return wkWebConfig;
}

/// JS実行（アプリ側から任意のタイミングでトリガー）
- (void)triggerJS:(NSString *)jsString webView:(WKWebView *)webView {
    [webView evaluateJavaScript:jsString
              completionHandler:^(NSString *result, NSError *error){
                  if (error != nil) {
                      NSLog(@"JS実行時のエラー：%@", error.localizedDescription);
                      return;
                  }
                  NSLog(@"出力結果：%@", result);
              }];
}

/// autoLayoutをセット
- (void)setupWKWebViewConstain: (WKWebView *)webView {
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // ４辺のマージンを0にする
    NSLayoutConstraint *topConstraint =
    [NSLayoutConstraint constraintWithItem: webView
                                 attribute: NSLayoutAttributeTop
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: self.baseView
                                 attribute: NSLayoutAttributeTop
                                multiplier: 1.0
                                  constant: 0];
    
    NSLayoutConstraint *bottomConstraint =
    [NSLayoutConstraint constraintWithItem: webView
                                 attribute: NSLayoutAttributeBottom
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: self.baseView
                                 attribute: NSLayoutAttributeBottom
                                multiplier: 1.0
                                  constant: 0];
    
    NSLayoutConstraint *leftConstraint =
    [NSLayoutConstraint constraintWithItem: webView
                                 attribute: NSLayoutAttributeLeft
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: self.baseView
                                 attribute: NSLayoutAttributeLeft
                                multiplier: 1.0
                                  constant: 0];
    
    NSLayoutConstraint *rightConstraint =
    [NSLayoutConstraint constraintWithItem: webView
                                 attribute: NSLayoutAttributeRight
                                 relatedBy: NSLayoutRelationEqual
                                    toItem: self.baseView
                                 attribute: NSLayoutAttributeRight
                                multiplier: 1.0
                                  constant: 0];
    
    NSArray *constraints = @[
                             topConstraint,
                             bottomConstraint,
                             leftConstraint,
                             rightConstraint
                             ];
    
    [self.baseView addConstraints:constraints];
}

#pragma mark - Action Methods
- (IBAction)back:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (IBAction)forword:(id)sender {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (IBAction)refresh:(id)sender {
    // cycle 0 - 1 - 2 = URL - RSP - APP
    [self setWhatsapp:self.whatsapp+1];
    if (self.whatsapp == 3) [self setWhatsapp:0];
    [self setup];
    [self setLockInterfaceRotation:NO];
    if ([self.model isEqual: @"iPhone"]) {
        if (self.whatsapp != 2) {
            [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
            [UINavigationController attemptRotationToDeviceOrientation];
        } else {
            [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
            [UINavigationController attemptRotationToDeviceOrientation];
        }
    }
    //[self.webView reload];
}

- (IBAction)jsTrigger:(id)sender {
    /// Configurationで設定したJSをメッセージ付きで呼び出し（戻り値なし）
    [self triggerJS:@"window.webkit.messageHandlers.callbackHandler.postMessage('Hello Native!');" webView:self.webView];
}

#pragma mark - UIWebViewDelegate Methods
/// 新しいウィンドウ、フレームを指定してコンテンツを開く時
- (WKWebView *)webView:(WKWebView *)webView
createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration
   forNavigationAction:(WKNavigationAction *)navigationAction
        windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    if (navigationAction.targetFrame != nil &&
        !navigationAction.targetFrame.mainFrame) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [[NSURL alloc] initWithString: navigationAction.request.URL.absoluteString]];
        [webView loadRequest: request];
        
        return nil;
    }
    return nil;
}

/// JSのalert実行時
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
}

/// JSのconfirm実行時
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
}

/// JSのprompt実行時
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
}

/// 指定された要素がプレビューを表示する許可
- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo {
    return YES;
}

#pragma mark - WKNavigationDelegate Methods
/// ページ遷移前にアクセスを許可
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSLog(@"アクセスURL：%@", navigationAction.request.URL.absoluteString);
    
    // どのページも許可
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 読み込み開始
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"読み込み開始");
}

// 読み込み完了
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"読み込み完了");
    [self.baseView bringSubviewToFront: self.toolbar];
    /// 読み込み完了時にHTML全体を受け取るJSを実行（戻り値あり）
    [self triggerJS:@"document.body.innerHTML" webView:webView];
}

// 読み込み失敗
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"読み込み失敗");
}

// 接続失敗
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"エラーコード：%ld", (long)error.code);
}

#pragma mark - WKScriptMessageHandler Methods
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    // 指定したコールバック名を判断して処理を分岐
    if([message.name  isEqual: @"callbackHandler"]) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@", message.body]);
    }
}

@end
