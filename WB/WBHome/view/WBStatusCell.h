//
//  WBStatusCell.h
//  WB
//
//  Created by 锄禾日当午 on 15/7/12.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBStatusFrame;

@interface WBStatusCell : UITableViewCell

@property (nonatomic, strong)WBStatusFrame *statusFrame;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
