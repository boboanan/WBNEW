//
//  WBStatus.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/11.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBStatus.h"
#import "WBPhoto.h"
#import "MJExtension.h"

@implementation WBStatus
-(NSDictionary *)objectClassInArray
{
    return @{@"pic_urls":[WBPhoto class]};
}

@end
