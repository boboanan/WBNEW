//
//  WBAccountTool.h
//  WB
//
//  Created by 锄禾日当午 on 15/7/11.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBAccount.h"

@interface WBAccountTool : NSObject

/**
 存储账号信息
 */
+(void)saveAccount:(WBAccount *)account;

/**
 返回账号信息
 
 如果账号过期，返回nil
 */
+(WBAccount *)account;
@end
