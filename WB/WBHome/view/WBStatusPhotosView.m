//
//  WBStatusPhotosView.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/14.
//  Copyright (c) 2015年 WWS. All rights reserved.


#import "WBStatusPhotosView.h"
#import "WBPhoto.h"
#import "UIImageView+WebCache.h"
#import "WBStatusPhotoView.h"

#define WBStatusPhotoWH 70
#define WBStatusPhotoMargin 10
#define WBStatusPhotoMaxCol(count) ((count==4)?2:3)

@implementation WBStatusPhotosView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    //因为会调用get方法，所以直接赋值，调用一次就行了
    //但不能单独赋值self.subview.count,因为他经常会改变
    int photosCount = photos.count;
    
     //创建足够数量imageView
    //创建缺少的imageView
    while (self.subviews.count < photosCount) {
       WBStatusPhotoView *photoView = [[WBStatusPhotoView alloc] init];
        photoView.backgroundColor = [UIColor blackColor];
        [self addSubview:photoView];
    }
  
    //遍历图片控件，设置图片
    //注意：cell是循环利用的,cell可能保留有上一个用的cell的数据
    for(int i = 0; i < self.subviews.count; i++){
       WBStatusPhotoView *photoView = self.subviews[i];
        
        if(i < photosCount){//显示
            photoView.photo = photos[i];
            photoView.hidden = NO;
            
                   }else{//隐藏，因为是循环利用，隐藏就好了
            photoView.hidden = YES;
            
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
   
    int photosCount = self.photos.count;
    //最大列数
    int maxCols = WBStatusPhotoMaxCol(photosCount);
    //设置图片尺寸和位置
    for(int i = 0; i < photosCount; i++){
       WBStatusPhotoView *photoView = self.subviews[i];
        int col = i % maxCols;
        photoView.x = col * (WBStatusPhotoWH + WBStatusPhotoMargin);
        
        int row = i / maxCols;
        photoView.y = row * (WBStatusPhotoWH + WBStatusPhotoMargin);
        photoView.width = WBStatusPhotoWH;
        photoView.height = WBStatusPhotoWH;
    }
    
}



+ (CGSize)sizeWithCount:(int)count
{
    
    //最大列数
    int maxCols = WBStatusPhotoMaxCol(count);
    
    //列数
    int cols = (count >= maxCols) ? maxCols :count;
    CGFloat photosW = cols * WBStatusPhotoWH + (cols - 1) * WBStatusPhotoMargin;
    
    //行数
    //    int rows = count % 3 ;
    //    if(rows != 0){
    //        rows = count / 3 + 1;
    //    }
    int rows = (count + maxCols -1) / maxCols;
    CGFloat photosH = rows * WBStatusPhotoWH + (rows - 1) * WBStatusPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}

@end
