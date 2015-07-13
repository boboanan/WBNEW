//
//  WBStatusFrame.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/13.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBStatusFrame.h"
#import "WBStatus.h"
#import "WBUser.h"

//cell的边框宽度
#define WBStatusCellBorderW 10


@implementation WBStatusFrame

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    //maxSize为约束
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    //用MAXFLOAT表示没有最大宽度
    return [self sizeWithText:text font:font maxW:MAXFLOAT];
}


-(void)setStatus:(WBStatus *)status
{
    _status = status;
    WBUser *user = status.user;
    
    //cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /** 头像*/
    //抽取变量，方便下面使用
    CGFloat iconWH = 50;
    CGFloat iconX = WBStatusCellBorderW;
    CGFloat iconY = WBStatusCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
     /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + WBStatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [self sizeWithText:user.name font:WBStatusCellNameFont];
    //self.nameLabelF = CGRectMake(nameX, nameY, nameSize.width, nameSize.height);
    self. nameLabelF = (CGRect){{nameX,nameY},nameSize};
    
    /** 会员图标*/
    if(status.user.isVip){
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + WBStatusCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }

    
    /** 时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + WBStatusCellBorderW;
    CGSize timeSize = [self sizeWithText:status.created_at font:WBStatusCellTimeFont];
    self.timeLabelF = (CGRect){{timeX,timeY},timeSize};

    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + WBStatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [self sizeWithText:status.source font:WBStatusCellSourceFont];
    self.sourceLabelF = (CGRect){{sourceX,sourceY},sourceSize};
    
    /** 正文 */
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF) + WBStatusCellBorderW);
    
    CGFloat maxW = cellW - 2 * contentX;
    CGSize contentSize = [self sizeWithText:status.text font:WBStatusCellContentFont maxW:maxW];
    self.contentLabelF = (CGRect){{contentX,contentY},contentSize};
    
    /** 配图*/
    CGFloat originalH = 0;
    if(status.pic_urls.count){//有配图
        CGFloat photoX = contentX;
        CGFloat photoY = CGRectGetMaxY(self.contentLabelF) + WBStatusCellBorderW;
        CGFloat photoWH = 100;
        self.photoViewF = CGRectMake(photoX, photoY, photoWH, photoWH);
        
         originalH = CGRectGetMaxY(self.photoViewF) + WBStatusCellBorderW;
    }else{//无配图
        originalH = CGRectGetMaxY(self.contentLabelF) + WBStatusCellBorderW;
    }
    
    /**原创微博整体*/
    CGFloat originalX = 0;
    CGFloat originalY = 0;
    CGFloat originalW = cellW;
    //CGFloat originalH =CGRectGetMaxY(self.contentLabelF) + WBStatusCellBorderW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    
    /**被转发微博 */
    if(status.retweeted_status){
        
        WBStatus *retweeted_status = status.retweeted_status;
        WBUser *retweeted_status_user = retweeted_status.user;
        
        
        /** 被转发微博正文 */
        CGFloat retweetContentX = WBStatusCellBorderW;
        CGFloat retweetContentY = WBStatusCellBorderW;
        NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@",retweeted_status_user.name,status.retweeted_status.text];
        CGSize retweetContentSize = [self sizeWithText:retweetContent font:WBStatusCellRetweetContentFont maxW:maxW];
        self.retweetContentLabelF = (CGRect){{retweetContentX,retweetContentY},retweetContentSize};
        
        
        /** 被转发微博配图 */
        
        CGFloat retweetH = 0;
        if(retweeted_status.pic_urls.count){//转发微博用配图
            CGFloat retweetPhotoX = retweetContentX;
            CGFloat retweetPhotoY = CGRectGetMaxY(self.retweetContentLabelF) + WBStatusCellBorderW;
            CGFloat retweetPhotoWH = 100;
            self.retweetPhotoViewF = CGRectMake(retweetPhotoX, retweetPhotoY, retweetPhotoWH, retweetPhotoWH);
            
            retweetH = CGRectGetMaxY(self.retweetPhotoViewF) + WBStatusCellBorderW;
        }else{
            
            retweetH = CGRectGetMaxY(self.retweetContentLabelF) + WBStatusCellBorderW;
        }
        /** 被转发微博整体 */
        CGFloat retweetX = 0;
        CGFloat retweetY = CGRectGetMaxY(self.originalViewF);
        CGFloat retweetW = cellW;
       
        self.retweetViewF = CGRectMake(retweetX, retweetY, retweetW, retweetH);
    
        /**  cell高度*/
        self.cellHeight = CGRectGetMaxY(self.retweetViewF);
    }else{
        /**  cell高度*/
        self.cellHeight = CGRectGetMaxY(self.originalViewF);
    }
    

    
    
  
}
@end
