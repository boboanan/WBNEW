//
//  WBStatusPhotosView.h
//  WB
//
//  Created by 锄禾日当午 on 15/7/14.
//  Copyright (c) 2015年 WWS. All rights reserved.
//cell上面的配图，会显示1——9张图片

#import <UIKit/UIKit.h>

@interface WBStatusPhotosView : UIView

@property (nonatomic, strong) NSArray *photos;

/**
 根据图片个数计算相册尺寸
 */
+ (CGSize)sizeWithCount:(int)count;

@end
