//
//  WBUser.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/11.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBUser.h"

@implementation WBUser

-(void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    
    self.vip = mbtype > 2;
}


//-(BOOL)isVip
//{
//    return self.mbrank > 2;
//}
////调用次数太多，不好
@end
