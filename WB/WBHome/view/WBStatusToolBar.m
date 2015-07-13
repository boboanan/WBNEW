//
//  WBStatusToolBar.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/13.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBStatusToolBar.h"

@implementation WBStatusToolBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(instancetype)toolbar
{
    return [[self alloc] init];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //self.backgroundColor =
        
        [self setUpBtn:@"转发" icon:@"timeline_icon_retweet"];
        [self setUpBtn:@"评论" icon:@"timeline_icon_comment"];
        [self setUpBtn:@"赞" icon:@"timeline_icon_unlike"];
    }
    return self;
}

/** 
 初始化一个按钮
 */
-(void)setUpBtn:(NSString *)title icon:(NSString *)icon
{
    UIButton *retweetBtn = [[UIButton alloc]init];
    [retweetBtn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    retweetBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [retweetBtn setTitle:title forState:UIControlStateNormal];
    [self addSubview:retweetBtn];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    int count = self.subviews.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    for(int i = 0; i<count; i++){
        UIButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
}
@end
