//
//  NSString+Extension.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/14.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

-(CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    //maxSize为约束
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

-(CGSize)sizeWithFont:(UIFont *)font
{
    //用MAXFLOAT表示没有最大宽度
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

@end
