//
//  WBAccountTool.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/11.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBAccountTool.h"

@implementation WBAccountTool

+(NSString *)path
{
    //沙盒路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [doc stringByAppendingString:@"acount.archive"];
    
    return path;
}

+(void)saveAccount:(WBAccount *)account
{
  
    
    //自定义对象的存储必须用NSKeyedArchiver,不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:account toFile:[self path]];
}

+(WBAccount *)account
{
    
    //加载模型
    WBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:[self path]];
    
    /*验证账号是否过期 */
     
     //过期的秒数
    long long expires_in = [account.expires_in longLongValue];
    //获得过期时间
    NSDate *expiresTime = [account.created_time dateByAddingTimeInterval:expires_in];
    //获得当前时间
    NSDate *now = [NSDate date];
   
    /**
    NSOrderedDescending  降序
    NSOrderedAscending  升序
    NSOrderedSame  一样
     */
    NSComparisonResult result = [expiresTime compare:now];
    if(result != NSOrderedDescending){
        //过期
        return nil;
    }
    
    return account;
    
}
@end
