//
//  WBStatusToolBar.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/13.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBStatusToolBar.h"
#import "WBStatus.h"
@interface WBStatusToolBar()
/**里面存放所有按钮
 */
@property (nonatomic, strong) NSMutableArray *btns;

/**分割线*/
@property (nonatomic, strong)NSMutableArray *dividers;

@property (nonatomic, weak) UIButton *repostBtn;
@property (nonatomic, weak) UIButton *commendBtn;
@property (nonatomic, weak) UIButton *attitudeBtn;

@end
@implementation WBStatusToolBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(NSMutableArray *)btns
{
    if(!_btns)_btns = [NSMutableArray array];
    return _btns;
}

-(NSMutableArray *)dividers
{
    if(!_dividers)_dividers = [NSMutableArray array];
    return _dividers;
}

+(instancetype)toolbar
{
    return [[self alloc] init];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_card_bottom_background"]];
        
        //添加按钮
        self.attitudeBtn = [self setUpBtn:@"转发" icon:@"timeline_icon_retweet"];
        self.commendBtn = [self setUpBtn:@"评论" icon:@"timeline_icon_comment"];
        self.attitudeBtn = [self setUpBtn:@"赞" icon:@"timeline_icon_unlike"];
        
        //添加分割线
        [self setUpDivider];
        [self setUpDivider];
    }
    return self;
}

/**
 设置分割线
 */
-(void)setUpDivider
{
    UIImageView *divider = [[UIImageView alloc]init];
    divider.image = [UIImage imageNamed:@"timeline_card_bottom_line"];
    [self addSubview:divider];
    
    [self.dividers addObject:divider];
}

/** 
 初始化一个按钮
 */
-(UIButton *)setUpBtn:(NSString *)title icon:(NSString *)icon
{
    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"timeline_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:btn];
    
    [self.btns addObject:btn];
    
    return btn;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置按钮的frame
    NSUInteger btnCount = self.btns.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for(int i = 0; i<btnCount; i++){
        UIButton *btn = self.btns[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
    
    //设置分割线的frame
    NSUInteger dividerCount = self.dividers.count;
    for(int i = 0; i<dividerCount; i++){
        UIImageView *divider = self.dividers[i];
        divider.width = 1;
        divider.height = btnH;
        divider.x = (i + 1) * btnW;
        divider.y = 0;
    }
}

-(void)setStatus:(WBStatus *)status
{
    _status = status;
    
    //转发
    [self setUpBtnCount:status.reposts_count btn:self.repostBtn Title:@"转发"];
    
    //评论
    [self setUpBtnCount:status.comments_count btn:self.commendBtn Title:@"评论"];
    
    //赞
     [self setUpBtnCount:status.reposts_count btn:self.attitudeBtn Title:@"赞"];
}

-(void)setUpBtnCount:(int)count btn:(UIButton *)btn Title:(NSString *)title
{
    if(count){//数字不为0
        if(count < 10000){
        //title被覆盖
            title = [NSString stringWithFormat:@"%d",count];
        }else{
            double wan = count / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万",wan];
            //将字符串里面的.0去掉
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }
            [btn setTitle:title forState:UIControlStateNormal];
        /**
         不足10000，直接显示数字
         达到10000，显示xx.x万
         */
    }else{//数字为0
        [btn setTitle:title forState:UIControlStateNormal];
    }
}
@end
