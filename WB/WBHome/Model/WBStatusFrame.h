//
//  WBStatusFrame.h
//  WB
//
//  Created by 锄禾日当午 on 15/7/13.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

//一个WBStatusFrame模型包含
//1、存放着一个cell内部所有子控件的frame数据
//2、存放一个cell的高度
//3、存放着一个数据模型WBStatus
#import <Foundation/Foundation.h>
@class WBStatus;
//用commend＋f整体替换
@interface WBStatusFrame : NSObject

@property (nonatomic,strong) WBStatus *status;

/** 原创微博整体*/
@property (nonatomic, assign) CGRect originalViewF;
/** 头像*/
@property (nonatomic, assign) CGRect iconViewF;
/** 配图*/
@property (nonatomic, assign) CGRect photoViewF;
/** 会员图标*/
@property (nonatomic, assign) CGRect vipViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 来源 */
@property (nonatomic, assign) CGRect sourceLabelF;
/** 正文 */
@property (nonatomic, assign) CGRect contentLabelF;
/**  cell高度*/
@property (nonatomic, assign) CGFloat cellHeight;
@end
