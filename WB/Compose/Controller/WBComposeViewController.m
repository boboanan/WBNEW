//
//  WBComposeViewController.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/15.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBComposeViewController.h"
#import "WBAccountTool.h"
#import "WBPlaceholderTextView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#define WBNotificationCenter [NSNotificationCenter defaultCenter]

@interface WBComposeViewController ()
@property (nonatomic, weak)UITextView *textView;
@end

@implementation WBComposeViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    //设置导航栏内容
    [self setUpNav];
    
    //添加输控件
    [self setUpTextView];
    
    //self.automaticallyAdjustsScrollViewInsets 默认是YES
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // WBLog(@"%@",NSStringFromUIEdgeInsets(self.textView.contentInset));
#warning 如果此句不放在这里颜色还是橙色的
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}

-(void)dealloc
{
    [WBNotificationCenter removeObserver:self];
}

#pragma  mark - 初始化方法
-(void)setUpNav
{
    
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancell)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];

       
    
        NSString *name = [WBAccountTool account].name;
        NSString *prefix = @"发微博";
        if(name){
        UILabel *titleView = [[UILabel alloc] init];
        titleView.width = 200;
        titleView.height = 44;
        titleView.textAlignment = NSTextAlignmentCenter;
        //自动换行
        titleView.numberOfLines = 0;
       
        NSString *str = [NSString stringWithFormat:@"%@\n%@",prefix,name];
        
        //创建一个带有属性的字符串
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
        
        //添加属性
        NSRange range= [str rangeOfString:name];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];
        //[attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:15] range:[str rangeOfString:prefix]];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:[str rangeOfString:prefix]];
        titleView.attributedText = attrStr;
        
        self.navigationItem.titleView = titleView;
    }else{
        self.title = prefix;
    }
}

/**
 UITextField
 1、文字永远一行，不能显示多行文字
 2、有placeholder属性设置占为文字
 3、继承自UIControl
 4、监听行为
   1>设置代理
   2>addTarget:
   3>通知UITextFieldTextDidChangeNotification
 
 UITextView
 1、能显示任意行文字
 2、不能设置占位文字
 3、继承自UIScrollView
 4、监听行为
  1>设置代理
  2>通知
 */

/**
 添加输入控件
 */
-(void)setUpTextView
{
    //在这个控制器中，textView的contentInset.type默认会等于64
    WBPlaceholderTextView *textView = [[WBPlaceholderTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"分享新鲜事";
    textView.placeholderColor = [UIColor orangeColor];
    [self.view addSubview:textView];
    self.textView = textView;
   // WBLog(@"%@",NSStringFromUIEdgeInsets(textView.contentInset));
    
    //监听通知
    [WBNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
}


#pragma mark － 监听方法

-(void)cancell
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)send
{
    //url:https://api.weibo.com/2/statuses/update.json
    // 参数
    /**
     status 	true 	string 	要发布的微博文本内容，必须做URLencode，内容不超过140个汉字。 
     access_token 	false 	string 	采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。 
     pic 	true 	binary 	要上传的图片，仅支持JPEG、GIF、PNG格式，图片大小小于5M。
     */
    
    //请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    //拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"]= [WBAccountTool account].access_token;
    params[@"status"]= self.textView.text;

    
    //发送请求
    [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WBLog(@"请求成功－%@",responseObject);
        [MBProgressHUD showSuccess:@"发布成功"];
        
      
     
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        WBLog(@"请求失败－%@",error);
      
         [MBProgressHUD showError:@"发布失败"];
    }];

    //dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 监听文字改变*/
-(void)textDidChange
{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}



@end
