//
//  WBTitleButton.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/11.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBTitleButton.h"

@implementation WBTitleButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    
        
        //    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0);
        //    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
        //    按钮内部图片，文字固定时建议使用imageEdgeInsets，titleEdgeInsets
//        CGFloat titleW = titleButton.titleLabel.width * [UIScreen mainScreen].scale;
//        //乘上scale系数，保证retina屏幕上的图片宽度是正确的
//        CGFloat imageW = titleButton.imageView.width * [UIScreen mainScreen].scale;
//        CGFloat left = titleW + imageW;
//        self.imageEdgeInsets = UIEdgeInsetsMake(0, left, 0, 0);
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //如果仅仅是调整按钮内部的imageView和titltLabel位置，那么在layoutSubViews中单独设置位置即可
    
    //计算titltLabel的frame
    //self.titleLabel.x = self.imageView.x;
    self.titleLabel.x = 0;
//    self.backgroundColor = [UIColor yellowColor];
//    self.titleLabel.backgroundColor = [UIColor redColor];
    //计算imageView的frame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame);
}


//只要按钮的文字和图片改了，都需要调整一下sizeToFit
-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    [self sizeToFit];
}

-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    [self sizeToFit];
}
///**
// 设置按钮内部imageView的frame
// contentRect  按钮的bounds
// */
//-(CGRect)imageRectForContentRect:(CGRect)contentRect
//{
//    CGFloat x = 80;
//    CGFloat y= 0;
//    CGFloat width = 13;
//    CGFloat height = contentRect.size.height;
//    return  CGRectMake(x,y, width, height);
//}
//
///**
// 设置按钮内部titltLabel的frame
// contentRect  按钮的bounds
// */
//-(CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    CGFloat x = 0;
//    CGFloat y= 0;
//    CGFloat width = 80;
//    CGFloat height = contentRect.size.height;
//    return  CGRectMake(x,y, width, height);
//    
//}

@end
