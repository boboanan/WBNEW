//
//  WBStatusPhotoView.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/14.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBStatusPhotoView.h"
#import "WBPhoto.h"
#import "UIImageView+WebCache.h"

@interface WBStatusPhotoView()
@property (nonatomic, weak) UIImageView *gifView;
@end
@implementation WBStatusPhotoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIImageView *)gifView
{
    if(!_gifView){
        UIImage *image = [UIImage imageNamed:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:gifView];
        _gifView = gifView;
    }
    return _gifView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor yellowColor];
        
        /**
         UIViewContentModeScaleToFill,
         UIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
         UIViewContentModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.
         UIViewContentModeRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
         UIViewContentModeCenter,              // contents remain same size. positioned adjusted.
         UIViewContentModeTop,
         UIViewContentModeBottom,
         UIViewContentModeLeft,
         UIViewContentModeRight,
         UIViewContentModeTopLeft,
         UIViewContentModeTopRight,
         UIViewContentModeBottomLeft,
         UIViewContentModeBottomRight,
         
         规律
         带有scale单词，会拉伸
         带有aspect，图片会保持原来宽高比
         */
        //内容模式
        self.contentMode = UIViewContentModeScaleAspectFill;
       
        //超出边框的都会被裁减掉
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setPhoto:(WBPhoto *)photo
{
    _photo = photo;
    
    //设置图片
    [self sd_setImageWithURL:[NSURL URLWithString:self.photo.thumbnail_pic] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];

    //显示／隐藏gif控件\
    //是否有gif后缀
//    if([photo.thumbnail_pic hasSuffix:@"gif"]){
//        self.gifView.hidden = NO;
//    }else{
//        self.gifView.hidden = YES;
//    }
    WBLog(@"---%@",photo.thumbnail_pic);
    self.gifView.hidden = ![photo.thumbnail_pic.lowercaseString hasSuffix:@"gif"];//可能会有大些大写的GIF，先变成小写
}

//尺寸一旦改了，就用此方法
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifView.x = self.width - self.gifView.width;
    self.gifView.y = self.height - self.gifView.height;
}
@end
