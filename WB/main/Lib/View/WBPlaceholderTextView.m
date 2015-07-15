//
//  WBPlaceholderTextView.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/15.
//  Copyright (c) 2015年 WWS. All rights reserved.
//带有占位文字

#import "WBPlaceholderTextView.h"
#define WBNotificationCenter [NSNotificationCenter defaultCenter]

@implementation WBPlaceholderTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //不要设置自己的delegate为自己
        
        //通知
        //当UITextView的文字发生改变时，UITextView自己会发出一个UITextViewTextDidChangeNotification通知
        [WBNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        
        self.placeholderColor = [UIColor grayColor];
    }
   
    return self;
}

-(void)dealloc
{
    [WBNotificationCenter removeObserver:self];
}

/**
 监听文字改变
 */
-(void)textDidChange
{
    //重绘(重新调用 drawRect)
    [self setNeedsDisplay];
}

-(void)setPlaceholder:(NSString *)placeholder
{
    //因为属性是copy，如果是strong，直接复制就行
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
}

-(void)setText:(NSString *)text
{
    [super setText:text];
    
    
    //setNeedsDisplay会在下一个消息循环中调用drawRect，不是立即执行
    [self setNeedsDisplay];
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}

-(void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}


//还可以用添加UILabel的方法，这样UILabel上的文字可以随着extView滚动
-(void)drawRect:(CGRect)rect
{
    if(self.hasText) return;
    
    
    //文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
    //画文字
    //[self.placeholder drawAtPoint:CGPointMake(5, 8) withAttributes:attrs];
    CGFloat x = 5;
    CGFloat w = rect.size.width -2 * x;
    CGFloat y = 8;
    CGFloat h = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
    
}

@end
