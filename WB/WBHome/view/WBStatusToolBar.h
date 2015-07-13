//
//  WBStatusToolBar.h
//  WB
//
//  Created by 锄禾日当午 on 15/7/13.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  WBStatus;

@interface WBStatusToolBar : UIView

@property (nonatomic, strong)WBStatus *status;

+(instancetype)toolbar;
@end
