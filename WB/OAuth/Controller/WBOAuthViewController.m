//
//  WBOAuthViewController.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/10.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBOAuthViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "WBAccount.h"
#import "MBProgressHUD+MJ.h"
#import "WBAccountTool.h"

@interface WBOAuthViewController () <UIWebViewDelegate>
@end

@implementation WBOAuthViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建一个webview
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    //用webView加载登录界面
    //请求参数
    NSURL *url = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=2866150430&redirect_uri=http://"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

#pragma mark - webView代理方法

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //获得url
    NSString *url = request.URL.absoluteString;
    
    //判断是否为回调地址
    NSRange range = [url rangeOfString:@"code="];
    if(range.length != 0){
        //回调地址
        //截取code＝后面的参数
        int fromIndex = range.location + range.length;
        NSString *code = [url substringFromIndex:fromIndex];
        
        WBLog(@"%@ %@",code,url);
        
        //利用code换取一个acessToken
        [self accessTokenWithCode:code];
        return NO;
    }
    
    return YES;
}

-(void)accessTokenWithCode:(NSString *)code
{
/*
     URL:https://api.weibo.com/oauth2/access_token
 client_id 	true 	string 	申请应用时分配的AppKey。
 client_secret 	true 	string 	申请应用时分配的AppSecret。
 grant_type 	true 	string 	请求的类型，填写authorization_code
 code 	true 	string 	调用authorize获得的code值。
 redirect_uri 	true 	string 	回调地址，需需与注册应用里的回调地址一致。
*/
    
    //请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"]=@"2866150430";
    params[@"client_secret"]=@"307e15671860d2ebb77a2ae329d05011";
    params[@"grant_type"]=@"authorization_code";
    params[@"redirect_uri"]=@"http://";
    params[@"code"]=code;
    
    //发送请求
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WBLog(@"请求成功－%@",responseObject);
        [MBProgressHUD hideHUD];
      
        //将返回的账号数据，存进沙盒  ->转为模型
        WBAccount *account = [WBAccount accountWithDict:responseObject];
        
        //存储账号信息
        [WBAccountTool saveAccount:account];
       
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window switchRootViewController];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        WBLog(@"请求失败－%@",error);
        [MBProgressHUD hideHUD];
    }];
}
     
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    WBLog(@"----webViewDidFinishLoad");
    [MBProgressHUD hideHUD];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
     WBLog(@"----webViewDidStartLoad");
    [MBProgressHUD showMessage:@"正在加载数据..."];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUD];
}

@end
