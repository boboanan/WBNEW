//
//  WBStatus.h
//  WB
//
//  Created by 锄禾日当午 on 15/7/11.
//  Copyright (c) 2015年 WWS. All rights reserved.
//



#import <Foundation/Foundation.h>
@class WBUser;

@interface WBStatus : NSObject

/**	string	字符串型的微博ID*/
@property (nonatomic, copy) NSString *idstr;

/**	string	微博信息内容*/
@property (nonatomic, copy) NSString *text;

/**	object	微博作者的用户信息字段 详细*/
@property (nonatomic, strong) WBUser *user;

/** 微博的创建时间 */
@property (nonatomic, copy) NSString *created_at;

/** 微博来源 */
@property (nonatomic, copy) NSString *source;

/** 微博配图地址，多图时返回多图链接，无图返回“[]”*/
@property (nonatomic, strong)NSArray *pic_urls;

/** 被转发的原微博信息字段，当该微博为转发微博是返回 */
@property (nonatomic, strong) WBStatus *retweeted_status;
@end
