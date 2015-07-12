//
//  WBLoadMoreFooter.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/12.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBLoadMoreFooter.h"

@implementation WBLoadMoreFooter


+(instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"WBLoadMoreFooter" owner:nil options:nil] lastObject];
}
@end
