//
//  WBDropDownMenu.h
//  WB
//
//  Created by 锄禾日当午 on 15/7/7.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBDropDownMenu;
@protocol WBDropDownMenuDelegate <NSObject>

@optional
-(void)dropdownMenuDidDismiss:(WBDropDownMenu *)menu;
-(void)dropdownMenuDidShow:(WBDropDownMenu *)menu;
@end
@interface WBDropDownMenu : UIView

@property (nonatomic, weak) id<WBDropDownMenuDelegate> delegate;


@property (nonatomic, strong) UIView *content;
//内容控制器
@property (nonatomic, strong) UIViewController *contentController;


+(instancetype)menu;
-(void)showFrom:(UIView *)from;
-(void)dismiss;

@end
