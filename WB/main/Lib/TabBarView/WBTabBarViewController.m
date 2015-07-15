//
//  WBTabBarViewController.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/6.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBTabBarViewController.h"
#import "WBDiscoverViewController.h"
#import "WBHomeViewController.h"
#import "WBMessageCenterViewController.h"
#import "WBProfileViewController.h"
#import "WBNavigationController.h"
#import "WBTabBar.h"
#import "WBComposeViewController.h"

@interface WBTabBarViewController ()<WBTabBarDelegate>

@end

@implementation WBTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WBHomeViewController *home = [[WBHomeViewController alloc] init];
    [self addChildVc:home Title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    WBDiscoverViewController *discover = [[WBDiscoverViewController alloc] init];
    [self addChildVc:discover Title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    
    WBMessageCenterViewController *messageCenter = [[WBMessageCenterViewController alloc] init];
    [self addChildVc:messageCenter Title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    WBProfileViewController *profile = [[WBProfileViewController alloc] init];
    [self addChildVc:profile Title:@"个人" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    WBTabBar *tabBar = [[WBTabBar alloc] init];
    tabBar.delegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];

    
}


-(void)addChildVc:(UIViewController *)childVc Title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    
    childVc.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置文字样式
    NSMutableDictionary *textAttrs = [[NSMutableDictionary alloc] init];
    textAttrs[NSForegroundColorAttributeName] = WBColor(123,123,123,1.0);
    NSMutableDictionary *selectedTextAttrs = [[NSMutableDictionary alloc] init];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    WBNavigationController *nav = [[WBNavigationController alloc] initWithRootViewController:childVc];
    
    //添加自控制器
    [self addChildViewController:nav];
    
}

#pragma mark - WBTabBardelegate
-(void)tabBarDidClickPlusButton:(WBTabBar *)tabbar
{
    WBComposeViewController *compose = [[WBComposeViewController alloc] init];
   
    
    WBNavigationController *nav = [[WBNavigationController alloc] initWithRootViewController:compose];
    
    [self presentViewController:nav animated:YES completion:nil];
}





@end
