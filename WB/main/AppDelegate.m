//  AppDelegate.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/6.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "AppDelegate.h"
#import "WBOAuthViewController.h"
#import "WBOAuthViewController.h"
#import "WBAccount.h"
#import "WBAccountTool.h"
#import "SDWebImageManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [[UIScreen mainScreen] bounds];
    
    //显示窗口
    [self.window makeKeyAndVisible];
 
    WBAccount *account = [WBAccountTool account];
    
    if(account){//之前已经成功登陆过
        [self.window switchRootViewController];
    }else{
        self.window.rootViewController = [[WBOAuthViewController alloc] init];
    }
    
    
    
    return YES;
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    
    //取消下载
    [mgr cancelAll];
    
    //清楚内存中的所有图片
    [mgr.imageCache clearMemory];
}



@end
