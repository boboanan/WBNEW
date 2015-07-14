//
//  WBNewFeatureViewController.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/10.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBNewFeatureViewController.h"
#import "WBTabBarViewController.h"

#define WBNewFeatureCount 4

@interface  WBNewFeatureViewController()<UIScrollViewDelegate>

@property (nonatomic, strong)UIPageControl *pageControl;
@end
@implementation WBNewFeatureViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建一个scrollView，现实所有新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    
    //添加图片到scrollView
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    
    for(int i = 0; i < WBNewFeatureCount; i++){
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
        
        NSString *name = [NSString stringWithFormat:@"new_feature_%d",i+1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        if(i == WBNewFeatureCount - 1){
            [self setUpLastImageView:imageView];
        }
    }
    
    //设置scollView的其他属性
    //如果想要某个方向不能滚动，这个方向尺寸数值传0即可
    scrollView.contentSize = CGSizeMake(WBNewFeatureCount * scrollW, 0);
    scrollView.bounces = NO;//去除弹簧效果
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    //添加pageControll，展示当前内容的页数
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = WBNewFeatureCount;
   // pageControl.backgroundColor = [UIColor redColor];
    pageControl.currentPageIndicatorTintColor = WBColor(253, 98, 42, 1.0);
    pageControl.pageIndicatorTintColor = WBColor(189, 189, 189, 1.0);
    
 
    //UIpageControll就算没有尺寸，里面的内容还是照常显示，子控件如果超过父控件，可以显示子空间大小；
    //如果父控件没有尺寸，子控件不能交互
    pageControl.centerX = scrollW * 0.5;
    pageControl.centerY = scrollH * 0.9;
    [self.view addSubview:pageControl];
    
    self.pageControl = pageControl;
}

-(void)setUpLastImageView:(UIImageView *)imageView
{
    //开启交互功能 ，重点啊
    imageView.userInteractionEnabled = YES;
    
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];

    shareBtn.width = 200;
    shareBtn.height = 30;
    shareBtn.centerX = imageView.width * 0.5;
    shareBtn.centerY = imageView.height * 0.65;
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:shareBtn];
    
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    //开始微博
    UIButton *startBtn = [[UIButton alloc] init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    startBtn.size = startBtn.currentBackgroundImage.size;
    startBtn.centerX = imageView.width * 0.5;
    startBtn.centerY = imageView.height * 0.75;
    [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
    
}

-(void)startClick
{
    //调用此方法后，原来的控制器会调用dealloc被销毁，而用modal方法不会调用dealloc
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[WBTabBarViewController alloc] init];
    
    WBLog(@"开始微博");
    
}

-(void)shareClick:(UIButton *)shareBtn
{
    shareBtn.selected = !shareBtn.isSelected;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double page = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(page + 0.5);
}

@end