//
//  WBHomeViewController.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/6.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBHomeViewController.h"
#import "WBDropDownMenu.h"
#import "WBTitleMenuViewController.h"
#import "AFNetworking.h"
#import "WBAccountTool.h"
#import "WBAccount.h"
#import "WBTitleButton.h"
#import "MJExtension.h"
#import "WBStatus.h"
#import "WBUser.h"
#import "UIImageView+WebCache.h"
#import "WBLoadMoreFooter.h"
#import "WBStatusCell.h"
#import "WBStatusFrame.h"

@interface WBHomeViewController ()<WBDropDownMenuDelegate>
/**
 *  微博数组（里面放的都是HWStatusFrame模型，一个HWStatusFrame对象就代表一条微博）
 */
@property (nonatomic, strong) NSMutableArray *statusFrames;
@end

@implementation WBHomeViewController

-(NSMutableArray *)statusFrames
{
    if(!_statusFrames){
        self.statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.tableView.backgroundColor = WBColor(211, 211, 211, 1.0);
//    self.tableView.contentInset = UIEdgeInsetsMake(WBStatusCellMargin, 0, 0, 0);
    
    //设置导航栏内容
    [self setUpNav];
    
    //获得用户信息
    [self setUpUserInfo];
    
 
    
    //集成下拉刷新控件
    [self setUpDownRefresh];
    
    //集成上拉拉刷新控件
    [self setUpUprefresh];
    
    // 获得未读数
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
    // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件）
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    WBLog(@"viewDidAppear --- %@",NSStringFromUIEdgeInsets(self.tableView.contentInset));
}

/**
 *  获得未读数
 */
- (void)setupUnreadCount
{
    //通知NSNotification  不可见
    //本地通知
    //远程推送通知
    
    
    //    HWLog(@"setupUnreadCount");
    //    return;
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    WBAccount *account = [WBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 3.发送请求
    [mgr GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 微博的未读数
        //        int status = [responseObject[@"status"] intValue];
        // 设置提醒数字
        //        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", status];
        
        // @20 --> @"20"
        // NSNumber --> NSString
        // 设置提醒数字(微博的未读数)
        NSString *status = [responseObject[@"status"] description];
        if ([status isEqualToString:@"0"]) { // 如果是0，得清空数字
            self.tabBarItem.badgeValue = nil;
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else { // 非0情况
            self.tabBarItem.badgeValue = status;
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        WBLog(@"请求失败-%@", error);
    }];
}


/**
 *  集成上拉刷新控件
 */
-(void)setUpUprefresh
{
    WBLoadMoreFooter *footer = [WBLoadMoreFooter footer];
    footer.hidden = YES;
    self.tableView.tableFooterView = footer;
}


/**
*  集成下拉刷新控件
*/
-(void)setUpDownRefresh
{
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    
    //只有用户通过手动下啦刷新，才会触发UIControlEventValueChanged
    [control addTarget:self action:@selector(loadNewStatus:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
    
    
    //马上进入刷新状态（仅仅是显示刷新状态，并不会出发UIControlEventValueChanged事件）
    [control beginRefreshing];
    
    //马上加载数据
    [self loadNewStatus:control];
}

/**
 *  加载更多的微博数据
 */
-(void)loadMoreStatus
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    WBAccount *account = [WBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博（最新的微博，ID最大的微博）
    WBStatusFrame *lastStatusF = [self.statusFrames lastObject];
    if (lastStatusF) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatusF.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [WBStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        //将WBStatus数组，转为WBStatusFrame数组
        NSArray *newFrames = [self statusFramesWithStatuses:newStatuses];
        
        
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:newFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        self.tableView.tableFooterView.hidden = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        WBLog(@"请求失败-%@", error);
        
        // 结束刷新
        self.tableView.tableFooterView.hidden = YES;
    }];

}

//将WBStatus模型转换为WBStatusFrame模型
-(NSArray *)statusFramesWithStatuses:(NSArray *)statues
{
    //将WBStatus数组，转为WBStatusFrame数组
    NSMutableArray *frames = [NSMutableArray array];
    for(WBStatus *status in statues){
        WBStatusFrame *f = [[WBStatusFrame alloc] init];
        f.status = status;
        [frames addObject:f];
    }
    return frames;
}

/**
 UIRefreshControl进入到刷新状态，加载最新的数据
 */
-(void)loadNewStatus:(UIRefreshControl *)control
{
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    WBAccount *account = [WBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    // params[@"count"] = @1 //默认是20
    
    
    //取出最前面的微博（最新的微博，ID最大的微博）
    WBStatusFrame *firstStatusF = [self.statusFrames firstObject];
   
    if (firstStatusF) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstStatusF.status.idstr;
    }
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/statuses/friends_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        //取得微博数组
        //        NSArray *dictArray = responseObject[@"statuses"];
        
        //        for(NSDictionary *dict in dictArray){
        //            WBstatus *status = [WBstatus objectWithKeyValues:dict];
        //            [self.statuses addObject:status];
        //        }
        NSArray *newStatuses = [WBStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        
        
        //将WBStatus数组，转为WBStatusFrame数组
        NSArray *newFrames = [self statusFramesWithStatuses:newStatuses];
        
        //将最新的微博数据，添加到总数组的最前面
#warning  如何
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:set];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [control endRefreshing];
        
        //显示最新微博数量
        [self showNewStatusCount:newStatuses.count];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        WBLog(@"refresh请求失败-%@", error);
    }];

}

/**
 显示最新微博的数量
 */
-(void)showNewStatusCount:(int)count
{
    // 刷新成功(清空图标数字)
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    //创建label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];//平铺
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    
    //设置其他属性
    if (count == 0) {
        label.text = [NSString stringWithFormat:@"没有新的微博"];
    }else{
        label.text = [NSString stringWithFormat:@"共有%d条新的微博",count];
    }
    
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    
    //添加
    
    //先利用1s事件，让label往下移动一段距离
    label.y = 64 - label.height;
    //将label添加到导航控制器的view中，并且是盖在导航栏下面
    //[self.navigationController.view addSubview:label];
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    //动画
    CGFloat duration = 1.0; //动画的时间
    [UIView animateWithDuration:duration animations:^{
        
       // label.y += label.height;
        label.transform = CGAffineTransformMakeTranslation(0, label.height);
        
    } completion:^(BOOL finished) {
        CGFloat delay = 1.0;  //延迟1s
        //延迟1s，让label往上移动一段距离
        
        //UIViewAnimationCurveLinear匀速
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationCurveLinear animations:^{
            
            label.transform = CGAffineTransformIdentity;//回到原来样子
            //label.y -= label.height;
            
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
        
    }];
    
    //如果某个动画智聪完毕后，又要回到动画执行前的状态，建议使用transform来做动画
}



//设置导航栏内容
-(void)setUpNav
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:nil action:nil image:@"navigationbar_friendsearch" HighlightedImage:@"navigationbar_friendsearch_highlighted" ];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:nil action:nil image:@"navigationbar_pop" HighlightedImage:@"navigationbar_pop_highlighted" ];
 
    
    //导航栏中间按钮
    WBTitleButton *titleButton = [[WBTitleButton alloc] init];
    

 
    NSString *name = [WBAccountTool account].name;
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];
   
    
  
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = titleButton;
}

/**
 *  获得用户信息（昵称）
 */
- (void)setUpUserInfo
{
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    WBAccount *account = [WBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 3.发送请求
    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        // 标题按钮
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        // 设置名字
        WBUser *user = [WBUser objectWithKeyValues:responseObject];
        [titleButton setTitle:user.name forState:UIControlStateNormal];
        
        // 存储昵称到沙盒中
        account.name = user.name;
        [WBAccountTool saveAccount:account];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        WBLog(@"请求失败-%@", error);
    }];
}

-(void)titleClick:(UIButton *)titleButton
{
    
    WBDropDownMenu *menu = [WBDropDownMenu menu];

    //设置内容
    WBTitleMenuViewController *vc = [[WBTitleMenuViewController alloc] init];
    vc.view.height = 150;

    menu.contentController = vc;
    menu.delegate = self;
    [menu showFrom:titleButton];
    WBLog(@"click");

}

#pragma mark WBDropDownDelegate
-(void)dropdownMenuDidDismiss:(WBDropDownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = NO;
}

-(void)dropdownMenuDidShow:(WBDropDownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    titleButton.selected = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.statusFrames.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获得cell
   WBStatusCell *cell = [WBStatusCell cellWithTableView:tableView];
    
    //给cell传递微博数据
    cell.statusFrame = self.statusFrames[indexPath.row];
   
//    // 取出这行对应的微博字
//    WBStatus *status = self.statuses[indexPath.row];
//    
//    // 取出这条微博的作者（用户）
//    WBUser *user = status.user;
//    cell.textLabel.text = user.name;
//    
//    // 设置微博的文字
//    cell.detailTextLabel.text = status.text;
//    
//    // 设置头像
//    UIImage *placehoder = [UIImage imageNamed:@"avatar_default_small"];
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:placehoder];
    
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    scrollView == self.tableView == self.view
    // 如果tableView还没有数据，就直接返回
    if (self.statusFrames.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 当最后一个cell完全显示在眼前时，contentOffset的y值
#warning 注意
    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
 
    if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
        // 显示footer
        self.tableView.tableFooterView.hidden = NO;
        
        // 加载更多的微博数据
        [self loadMoreStatus];
    }
    
    /*
     contentInset：除具体内容以外的边框尺寸
     contentSize: 里面的具体内容（header、cell、footer），除掉contentInset以外的尺寸
     contentOffset:
     1.它可以用来判断scrollView滚动到什么位置
     2.指scrollView的内容超出了scrollView顶部的距离（除掉contentInset以外的尺寸）
     */
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WBStatusFrame *frame = self.statusFrames[indexPath.row];
    return frame.cellHeight; 
}
@end
