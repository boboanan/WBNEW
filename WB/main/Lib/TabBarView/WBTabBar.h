//
//  WBTabBar.h
//  WB
//
//  Created by 锄禾日当午 on 15/7/7.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBTabBar;

@protocol WBTabBarDelegate <UITabBarDelegate>

-(void)tabBarDidClickPlusButton:(WBTabBar *)tabbar;

@end

@interface WBTabBar : UITabBar
@property (nonatomic, weak) id<WBTabBarDelegate> delegate;
@end
