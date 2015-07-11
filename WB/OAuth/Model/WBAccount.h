//
//  WBAccount.h
//  WB
//
//  Created by 锄禾日当午 on 15/7/11.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBAccount : NSObject<NSCoding>

/** access_token 	string 	用于调用access_token，接口获取授权后的access token。*/
@property (nonatomic, copy) NSString *access_token;

/**expires_in 	string 	access_token的生命周期，单位是秒数。*/
@property (nonatomic, copy) NSNumber *expires_in;

/**uid 	string 	当前授权用户的UID。*/
@property (nonatomic, copy) NSString *uid;

/** access_token 的创建时间 */
@property (nonatomic, strong)NSDate *created_time;

/** 用户的昵称 */
@property (nonatomic, copy)NSString *name;

+(instancetype)accountWithDict:(NSDictionary *)dict;
@end
