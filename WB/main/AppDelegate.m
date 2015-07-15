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


/**
 *  当app进入后台时调用
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /**
     *  app的状态
     *  1.死亡状态：没有打开app
     *  2.前台运行状态
     *  3.后台暂停状态：停止一切动画、定时器、多媒体、联网操作，很难再作其他操作
     *  4.后台运行状态
     */
    // 向操作系统申请后台运行的资格，能维持多久，是不确定的
    __block UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        // 当申请的后台运行时间已经结束（过期），就会调用这个block
        
        // 赶紧结束任务
        [application endBackgroundTask:task];
    }];
    //此据代码首先定义变量，再执行右边代码，再将右边方法的返回值给task,解决方法用__block,(用static不行)或者定义为全局变量
    
    // 在Info.plst中设置后台模式：Required background modes == App plays audio or streams audio/video using AirPlay
    // 搞一个0kb的MP3文件，没有声音
    // 循环播放
    
    // 以前的后台模式只有3种
    // 保持网络连接
    // 多媒体应用
    // VOIP:网络电话
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
