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

@interface WBHomeViewController ()<WBDropDownMenuDelegate>

@property (nonatomic, strong) NSMutableArray *statuses;
@end

@implementation WBHomeViewController

-(NSMutableArray *)statuses
{
    if(!_statuses){
        self.statuses = [[NSMutableArray alloc] init];
    }
    return _statuses;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //设置导航栏内容
    [self setUpNav];
    
    //获得用户信息
    [self setUpUserInfo];
    
//    //加载最新的微博数据
//    [self loadNewStatus];
//    
    
    //即成刷新控件
    [self setUpRefresh];
}


-(void)setUpRefresh
{
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
}

/**
 UIRefreshControl进入到刷新状态，加载最新的数据
 */
-(void)refreshStateChange:(UIRefreshControl *)control
{
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    WBAccount *account = [WBAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    // params[@"count"] = @1 //默认是20
    
    
    //取出最前面的微博（最新的微博，ID最大的微博）
    WBStatus *firstStatus = [self.statuses firstObject];
   
    if (firstStatus) {
        // 若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
        params[@"since_id"] = firstStatus.idstr;
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
        
        //将最新的微博数据，添加到总数组的最前面
#warning  如何
        NSRange range = NSMakeRange(0, newStatuses.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statuses insertObjects:newStatuses atIndexes:set];
        
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [control endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        WBLog(@"refresh请求失败-%@", error);
    }];

}


/**
 加载最新的微博数据
 */
//-(void)loadNewStatus
//{
//    //请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    
//    // 2.拼接请求参数
//    WBAccount *account = [WBAccountTool account];
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"access_token"] = account.access_token;
//   // params[@"count"] = @1 //默认是20
//    
//    // 3.发送请求
//    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//        //取得微博数组
////        NSArray *dictArray = responseObject[@"statuses"];
//        
////        for(NSDictionary *dict in dictArray){
////            WBstatus *status = [WBstatus objectWithKeyValues:dict];
////            [self.statuses addObject:status];
////        }
//        NSArray *newStatuses = [WBstatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
//        
//        //将最新的微博数据，添加到总数组的最后面
//        [self.statuses addObjectsFromArray:newStatuses];
//        //刷新表格
//        [self.tableView reloadData];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        WBLog(@"请求失败-%@", error);
//    }];
//
//}

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
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.statuses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"status";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
  
    
    // 取出这行对应的微博字
    WBStatus *status = self.statuses[indexPath.row];
    
    // 取出这条微博的作者（用户）
    WBUser *user = status.user;
    cell.textLabel.text = user.name;
    
    // 设置微博的文字
    cell.detailTextLabel.text = status.text;
    
    // 设置头像
    UIImage *placehoder = [UIImage imageNamed:@"avatar_default_small"];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:placehoder];
    
    
    return cell;
}

@end
