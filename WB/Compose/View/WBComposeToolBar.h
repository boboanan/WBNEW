//
//  WBComposeToolBar.h
//  WB
//
//  Created by 锄禾日当午 on 15/7/15.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WBComposeToolBarButtonTypeCamera,
    WBComposeToolBarButtonTypePicture,
    WBComposeToolBarButtonTypeMention,
    WBComposeToolBarButtonTypeTrend,
    WBComposeToolBarButtonTypeEmotion
} WBComposeToolBarButtonType;

@class WBComposeToolBar;

@protocol WBComposeToolBarDelegate <NSObject>

@optional

-(void)composeToolBar:(WBComposeToolBar *)toolbar didClickButton:(WBComposeToolBarButtonType)buttonType;

@end


@interface WBComposeToolBar : UIView

@property (nonatomic, weak) id<WBComposeToolBarDelegate> delegate;
@end
