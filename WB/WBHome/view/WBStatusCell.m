//
//  WBStatusCell.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/12.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBStatusCell.h"
#import "WBStatusFrame.h"
#import "WBStatus.h"
#import "WBUser.h"
#import "UIImageView+WebCache.h"

@interface WBStatusCell()

//原创微博
/** 原创微博整体*/
@property (nonatomic, weak) UIView *originalView;
/** 头像*/
@property (nonatomic, weak) UIImageView *iconView;
/** 配图*/
@property (nonatomic, weak) UIImageView *photoView;
/** 会员图标*/
@property (nonatomic, weak) UIImageView *vipView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文 */
@property (nonatomic, weak) UILabel *contentLabel;
@end

@implementation WBStatusCell


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[WBStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

/**
 cell的初始化方法，一个cell只会调用一次
 一般在这里添加所有可能的子控件，以及子控件的一次性设置
 */
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        /**原创微博的整体*/
        /** 原创微博整体*/
        UIView *originalView = [[UIView alloc] init];
        [self.contentView addSubview:originalView];
        self.originalView = originalView;
        
        
        /** 头像*/
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.originalView addSubview:originalView];
        self.iconView = iconView;
        
        /** 配图*/
        UIImageView *photoView = [[UIImageView alloc] init];
        [self.originalView addSubview:photoView];
        self.photoView = photoView;
        
        /** 会员图标*/
        UIImageView *vipView = [[UIImageView alloc] init];
        [self.originalView addSubview:vipView];
        self.vipView = vipView;
        
        /** 昵称 */
        UILabel *nameLabel = [[UILabel alloc] init];
        [self.originalView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        /** 时间 */
        UILabel *timeLabel = [[UILabel alloc] init];
        [self.originalView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        /** 来源 */
        UILabel *sourceLabel = [[UILabel alloc] init];
        [self.originalView addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        
        /** 正文 */
        UILabel *contentLabel = [[UILabel alloc] init];
        [self.originalView addSubview:contentLabel];
        self.contentLabel = contentLabel;
    }
    return self;
}

-(void)setStatusFrame:(WBStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    WBStatus *status = statusFrame.status;
    WBUser *user = status.user;
    
    /** 原创微博整体*/
    self.originalView.frame = statusFrame.originalViewF;
    
    /** 头像*/
    self.iconView.frame = statusFrame.iconViewF;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    /** 会员图标*/
    self.vipView.frame = statusFrame.vipViewF;
    self.vipView.image = [UIImage imageNamed:@"common_icon_membership_level1"];
    
    /** 配图*/
    self.photoView.frame = statusFrame.photoViewF;
    self.photoView.backgroundColor = [UIColor yellowColor];
    /** 昵称 */
    self.nameLabel.frame = statusFrame.nameLabelF;
    self.nameLabel.text = user.name;
    
    /** 时间 */
    self.timeLabel.frame = statusFrame.timeLabelF;
    self.timeLabel.text = user.name;
    
    /** 来源 */
    self.sourceLabel.frame = statusFrame.sourceLabelF;
    
    /** 正文 */
    self.contentLabel.frame = statusFrame.contentLabelF;
    self.contentLabel.text = status.text;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
