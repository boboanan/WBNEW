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

/**
 1.今年
 1>今天
 *1分钟内：刚刚
 *1分钟——59分钟：xx分钟前
 *大于60分钟：xx小时前
 2>昨天
 *昨天 xx:xx
 3>其他
 *xx-xx xx:xx
 
 2.非今年
 
 //xxxx-xx-xx xx:xx
 */
-(NSString *)created_at
{
    //_created_at == Thu Oct 16 17:06:25 +0800 2014
    //dateFormat ==  EEE MMM dd HH:mm:ss Z yyyy 星期 月份 天 时 分 秒
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //设置日期格式，（声明字符串里面每个数字和单词的含义）
    //如果是真机测试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    //微博的创建日期
    NSDate *createDate = [fmt dateFromString:_created_at];
//    NSTimeInterval seconds = [createDate timeIntervalSinceNow];
    
    //日历对象(方便比较两个日期之间的差距)
    //    //当前时间
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //计算两个日期的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    return _created_at;
}
@end
