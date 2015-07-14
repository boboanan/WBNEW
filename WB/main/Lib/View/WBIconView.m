//
//  WBIconView.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/14.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBIconView.h"
#import "WBUser.h"
#import "UIImageView+WebCache.h"
@interface WBIconView()
@property (nonatomic, weak) UIImageView *verifiedView;
@end

@implementation WBIconView

-(UIImageView *)verifiedView
{
    if(!_verifiedView){
        UIImageView *verifiedView = [[UIImageView alloc] init];
        [self addSubview:verifiedView];
        self.verifiedView = verifiedView;
    }
    return _verifiedView;
}


-(void)setUser:(WBUser *)user
{
    _user = user;
    
    //下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    //设置加v图片
    switch (user.verified_type) {
//        case WBUserVerifiedTypeNone://没有任何认证
//            self.verifiedView.hidden = YES;
//            break;
        case WBUserVerifiedPersonal://个人认证
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
        case WBUserVerifiedOrgEnterprice://企业官方
        case WBUserVerifiedOrgMedia://媒体官方
        case WBUserVerifiedOrgWebsite://网站官方
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
        case WBUserVerifiedDaren://微博达人
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
            
        default:
            self.verifiedView.hidden = YES;
            break;
           
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.verifiedView.size = self.verifiedView.image.size;
    CGFloat scale = 0.6;
    self.verifiedView.x = self.width - self.verifiedView.width * scale;
    self.verifiedView.y = self.height - self.verifiedView.height * scale;
}

@end
