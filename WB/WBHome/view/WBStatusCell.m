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
#import "WBPhoto.h"
#import "WBStatusToolBar.h"

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

/** 转发微博整体*/
@property (nonatomic, weak) UIView *retweetView;
/** 转发微博正文 + 昵称*/
@property (nonatomic, weak) UILabel *retweetContentLabel;
/** 转发配图 */
@property (nonatomic, weak) UIImageView *retweetPhotoView;

/** 工具条*/
@property (nonatomic, weak) WBStatusToolBar *toolbar;
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

///**
// 目的，是整个tableview向下移动WBStatusCellMargin
// */
//-(void)setFrame:(CGRect)frame
//{
//    frame.origin.y += WBStatusCellMargin;
//    [super setFrame:frame];
//}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        //点击cell时不变色
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //设置cell选中时的背景色
        UIView *bg = [[UIView alloc] init];
        bg.backgroundColor = WBColor(211, 211, 211, 1.0);
        self.selectedBackgroundView = bg;
   
        
        //初始化原创微博
        [self setUpOriginal];
        
        //初始化转发微博
        [self setUpRetweet];
        
        //初始化工具条
        [self setUpToolbar];
    }
    return self;
}

/** 初始化工具条*/
-(void)setUpToolbar
{
    WBStatusToolBar *toolbar = [WBStatusToolBar toolbar];
//    toolbar.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:toolbar];
    self.toolbar = toolbar;
    
}

/**
 初始化转发微博
 */
-(void)setUpRetweet
{
    /** 转发微博整体 */
    UIView *retweetView = [[UIView alloc] init];
    retweetView.backgroundColor = WBColor(247, 247, 247, 1.0);
    [self.contentView addSubview:retweetView];
    self.retweetView = retweetView;
    
    /** 转发微博正文＋昵称 */
    UILabel *retweetContentLabel = [[UILabel alloc] init];
    retweetContentLabel.font = WBStatusCellRetweetContentFont;
    retweetContentLabel.numberOfLines = 0;
    [retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel = retweetContentLabel;
    
    
    /** 转发配图 */
    UIImageView *retweetPhotoView = [[UIImageView alloc] init];
    [retweetView addSubview:retweetPhotoView];
    self.retweetPhotoView = retweetPhotoView;
    
}

/**
 初始化原创微博
 */
-(void) setUpOriginal
{
    /**原创微博的整体*/
    UIView *originalView = [[UIView alloc] init];
    originalView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:originalView];
    self.originalView = originalView;
    
    
    /** 头像*/
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.originalView addSubview:iconView];
    //        self.originalView.backgroundColor = [UIColor redColor];
    self.iconView = iconView;
    
    /** 配图*/
    UIImageView *photoView = [[UIImageView alloc] init];
    [self.originalView addSubview:photoView];
    self.photoView = photoView;
    
    /** 会员图标*/
    UIImageView *vipView = [[UIImageView alloc] init];
    vipView.contentMode = UIViewContentModeCenter;
    [self.originalView addSubview:vipView];
    self.vipView = vipView;
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = WBStatusCellNameFont;
    [self.originalView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = WBStatusCellTimeFont;
    [self.originalView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = WBStatusCellSourceFont;
    [self.originalView addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;
    
    /** 正文 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = WBStatusCellContentFont;
    contentLabel.numberOfLines = 0;
    [self.originalView addSubview:contentLabel];
    self.contentLabel = contentLabel;
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
    if(user.isVip){
        //hidden属性必不可少
        self.vipView.hidden = NO;
        
        self.vipView.frame = statusFrame.vipViewF;
        NSString *vipName = [NSString stringWithFormat:@"common_icon_membership_level%d",user.mbrank];
        self.vipView.image = [UIImage imageNamed:vipName];
        
        self.nameLabel.textColor = [UIColor orangeColor];
    }else{
        self.vipView.hidden = YES;
        
        self.nameLabel.textColor = [UIColor blackColor];
    }
  
    
    /** 配图*/
    if(status.pic_urls.count){
    self.photoView.frame = statusFrame.photoViewF;
       WBPhoto *photo = [status.pic_urls firstObject];
    [self.photoView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
        
        self.photoView.hidden = NO;
    }else{
        self.photoView.hidden = YES;
        
    }
    
    /** 昵称 */
    self.nameLabel.frame = statusFrame.nameLabelF;
    self.nameLabel.text = user.name;
    
    /** 时间 */
    self.timeLabel.frame = statusFrame.timeLabelF;
    self.timeLabel.text = status.created_at;
    
    /** 来源 */
    self.sourceLabel.frame = statusFrame.sourceLabelF;
    self.sourceLabel.text = status.source;
    
    /** 正文 */
    self.contentLabel.frame = statusFrame.contentLabelF;
    self.contentLabel.text = status.text;
    
    /** 被转发的微博*/
    if(status.retweeted_status){
        
        WBStatus *retweeted_status = status.retweeted_status;
        WBUser *retweeted_status_user = status.retweeted_status.user;
        
        /** 被转发微博的整体*/
        self.retweetView.frame = statusFrame.retweetViewF;
        
        /** 被转发微博的正文 */
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@",retweeted_status_user.name,status.retweeted_status.text];
        self.retweetContentLabel.frame = statusFrame.retweetContentLabelF;
        self.retweetContentLabel.text = retweetContent;
        
        
        /** 被转发微博的配图*/
        if(retweeted_status.pic_urls.count){
            self.retweetPhotoView.frame = statusFrame.retweetPhotoViewF;
            WBPhoto *photo = [retweeted_status.pic_urls firstObject];
            [self.retweetPhotoView sd_setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
            
            self.retweetPhotoView.hidden = NO;
        }else{
            self.retweetPhotoView.hidden = YES;
        }
        
       
            
        self.retweetView.hidden = NO;
    }else{
        
        self.retweetView.hidden = YES;
    }
    
    /** 工具条*/
    self.toolbar.frame = statusFrame.toolbarF;
    self.toolbar.status = status;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
