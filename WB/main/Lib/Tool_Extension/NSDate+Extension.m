//
//  NSDate+Extension.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/14.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)



/**
 是否为今年
 */
-(BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return dateCmps.year == nowCmps.year;
}

/**
 是否为今天
 */
-(BOOL)isToday
{
    NSDate *now = [NSDate date];
    //把时分秒去掉
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    
    return [nowStr isEqualToString:dateStr];
}

/**
 是否为昨天
 */
-(BOOL)isYesterday
{
    NSDate *now = [NSDate date];
    NSDate *date = [[NSDate alloc] init];
    //把时分秒去掉
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    
    date = [fmt dateFromString:dateStr];
    now = [fmt dateFromString:nowStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //计算两个日期的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month ==0 && cmps.day == 1;
}

@end
