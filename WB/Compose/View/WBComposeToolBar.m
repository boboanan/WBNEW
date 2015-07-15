//
//  WBComposeToolBar.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/15.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBComposeToolBar.h"

@implementation WBComposeToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
    //初始化按钮
        [self setUpBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted"];
        [self setUpBtn:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted" ];
        [self setUpBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted"];
        [self setUpBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted"];
        [self setUpBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted"];
    
    
    }
    return self;
}

/**
 创建一个按钮
 */
-(void)setUpBtn:(NSString *)image highImage:(NSString *) highImage
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [self addSubview:btn];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    NSUInteger count = self.subviews.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    for(NSUInteger i = 0; i < count; i++){
        UIButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
}
@end
