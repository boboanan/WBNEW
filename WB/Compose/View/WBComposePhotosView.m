//
//  WBComposePhotosView.m
//  WB
//
//  Created by 锄禾日当午 on 15/7/16.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import "WBComposePhotosView.h"
@interface WBComposePhotosView()

@end
@implementation WBComposePhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         _addedPhoto = [NSMutableArray array];
    }
    return self;
}
//-(NSMutableArray *)addedPhotoa
//{
//    if(!_addedPhotoa){
//        self.addedPhotoa = [NSMutableArray array];
//    }
//    return _addedPhotoa;
//}

-(void)addPhoto:(UIImage *)photo
{
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.image = photo;
    [self addSubview:photoView];
    [self.addedPhoto addObject:photo];
}

//-(NSArray *)photos
//{
//    NSMutableArray *photos = [NSMutableArray array];
//    for(UIImageView *imageView in self.subviews){
//        [photos addObject:imageView];
//    }
//    return photos;
//    return self.addedPhotoa;
//}

-(void)layoutSubviews
{
    
    [super layoutSubviews];
    
    
    NSUInteger photosCount = self.subviews.count;
    //最大列数
    NSUInteger maxCols = (photosCount);
    CGFloat imageWH = 70;
    CGFloat imageMargin = 10;
    //设置图片尺寸和位置
    for(int i = 0; i < photosCount; i++){
        UIImageView *photoView = self.subviews[i];
        int col = i % maxCols;
        photoView.x = col * (imageWH + imageMargin);
        
        int row = i / maxCols;
        photoView.y = row * (imageWH + imageMargin);
        photoView.width = imageWH;
        photoView.height = imageWH;
    }
    
}
@end
