//
//  WBUser.h
//  WB
//
//  Created by 锄禾日当午 on 15/7/11.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    WBUserVerifiedTypeNone = -1,//没有任何认证
    WBUserVerifiedPersonal = 0,//个人认证
    WBUserVerifiedOrgEnterprice = 2,//企业官方
    WBUserVerifiedOrgMedia = 3,//媒体官方
    WBUserVerifiedOrgWebsite = 5,//网站官方
    WBUserVerifiedDaren = 220//微博达人
    
}WBUserVerifiedType;

@interface WBUser : NSObject

/**	string	字符串型的用户UID*/
@property (nonatomic, copy) NSString *idstr;

/**	string	友好显示名称*/
@property (nonatomic, copy) NSString *name;

/**	string	用户头像地址，50×50像素*/
@property (nonatomic, copy) NSString *profile_image_url;

/** 会员类型 值大于2是会员*/
@property (nonatomic, assign) int mbtype;

/** 会员等级 */
@property (nonatomic,assign) int mbrank;

@property (nonatomic, assign, getter=isVip) BOOL vip;

/** 认证类型*/
@property (nonatomic, assign) WBUserVerifiedType verified_type;
@end
