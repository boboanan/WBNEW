//
//  UIWindow+Extension.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/11.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "WBTabBarViewController.h"
#import "WBNewFeatureViewController.h"

@implementation UIWindow (Extension)


-(void)switchRootViewController
{
    
    
    //上一次使用版本(存储在沙盒中的版本号)
    NSString *key = @"CFBundleVersion";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    //当前软件的本版本号(从info.plist中获得)
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
   
    if([currentVersion isEqualToString:lastVersion]){
        //版本号相同，这次打开的和上一次打开的是同一个版本
        self.rootViewController = [[WBTabBarViewController alloc] init];
    }else{
        //这次和上次打开的不一样，显示新特性
        self.rootViewController = [[WBNewFeatureViewController alloc] init];
        
        //将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    
    

}

@end
