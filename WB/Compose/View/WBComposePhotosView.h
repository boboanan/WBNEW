//
//  WBComposePhotosView.h
//  WB
//
//  Created by 锄禾日当午 on 15/7/16.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBComposePhotosView : UIView
-(void)addPhoto:(UIImage *)photo;

@property (nonatomic, strong,readonly) NSMutableArray *addedPhoto;
//@property (nonatomic, strong,readonly) NSArray *photos;
//此方法默认会实现一个getter的声明和实现，_开头的成员变量，如果自己实现了getter方法,那么就不会产生_开头的变量和getter方法
@end
