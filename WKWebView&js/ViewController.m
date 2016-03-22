//
//  ViewController.m
//  WKWebView&js
//
//  Created by mac on 16/3/21.
//  Copyright © 2016年 treebear. All rights reserved.
//

#import "Console.h"
#import "Plugin.h"
#import "ViewController.h"
#import "Accelerometer.h"
#import <WebKit/WebKit.h>
@interface ViewController () <WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate> {
    UILabel* label;
    WKWebView* webView;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadWebViewSource];
}

- (void)loadWebViewSource
{
    NSString* js = @"window.webkit.messageHandlers.observe.postMessage(document.body.innerText);";
    WKUserScript* script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:true]; //这里的atend 是指当web页面加载完后注入js代码
    WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc] init];
    [config.userContentController addUserScript:script];
    [config.userContentController addScriptMessageHandler:self name:@"observe"]; //向webkit注册一个scriptmessagehandle，observe给js使用

    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50.0f)];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];

    webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 50.0f, self.view.frame.size.width, self.view.frame.size.height - 50.0f) configuration:config];
    webView.navigationDelegate = self;
    webView.allowsBackForwardNavigationGestures = self; //页面允许侧滑手势
    webView.UIDelegate = self;
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:@"http://www.jianshu.com/"]]];

    [self executeJSCode:@[ @"Console", @"Base", @"Accelerometer" ]];
    [self.view addSubview:webView];
}

- (void)executeJSCode:(NSArray*)names
{
    //app向wk 注入js代码
    for (NSString* name in names) {
        NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@"js"];
        NSString* content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [webView evaluateJavaScript:content completionHandler:^(id _Nullable obj, NSError* _Nullable error) {
            NSLog(@" app execute js %@ ", error);
        }];
    }
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary<NSString*, id>*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"title"]) {
        label.text = webView.title;
    }
}

#pragma handler js调用app 代理中带handler的需要回传
- (void)userContentController:(WKUserContentController*)userContentController didReceiveScriptMessage:(WKScriptMessage*)message
{
    //接受js传递的信息调用app 方法
    NSLog(@" receive message : %@ ", message.body);

    if ([message.body isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dic = message.body;

        NSString* className = dic[@"className"];
        NSString* functionName = [dic[@"functionName"] stringByAppendingFormat:@":"];
        //        NSString *path = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"] stringByAppendingString:[NSString stringWithFormat:@".%@",className]];
        /*
        Class cls = NSClassFromString(className);
        if (cls) {
            id obj = [[cls alloc] init];
            SEL function = NSSelectorFromString(functionName);
            if ([obj respondsToSelector:function]) {
                [obj performSelector:function withObject:dic[@"data"]];
                NSLog(@" function execute ");
            }
            else {
                NSLog(@" obj 未找到对应函数 ");
            }
        }
        else {
            NSLog(@" 未找到对应的class ");
        }
        */

        Class cls = NSClassFromString(className);
        if (cls) {
            Accelerometer* obj = [[cls alloc] init];
            obj.wk = webView;
            obj.taskId = [[dic objectForKey:@"taskId"] intValue];
            obj.data = dic[@"data"];

            SEL functionSelector = NSSelectorFromString(dic[@"functionName"]);
            if ([obj respondsToSelector:functionSelector]) {
                [obj performSelector:functionSelector];
            }
            else {
                NSLog(@" 方法未找到 ");
            }
        }
        else {
            NSLog(@" 类未找到 ");
        }
    }
}

- (void)webView:(WKWebView*)webView didFinishNavigation:(null_unspecified WKNavigation*)navigation
{
}
- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow); //app来决定是否要继续加载
}

#pragma UI delegate js调用UI相关
- (void)webView:(WKWebView*)webView runJavaScriptAlertPanelWithMessage:(NSString*)message initiatedByFrame:(WKFrameInfo*)frame completionHandler:(void (^)(void))completionHandler
{

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:
                                                      NSLocalizedString(@"Test Alert", nil)
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction* action) {
                                                              completionHandler(); //将app的点击回传给js
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/* 1.js向native层的传值和反射  
 
 step1， 新建Console.js，在里面有console 和 log函数。以及对应native层中的类Console.h, 和处理函数-log:
 step2， 在webview显示前  注入Console.js代码
 step3， 在safari开发调试控制器中，执行console.log('cooper')
 step4， 通过回调函数-didReceiveScriptMessage ，解析出对应的类Console，和函数-log: 
 step5， 由native层的Console类执行-log:
 
*/

@end
