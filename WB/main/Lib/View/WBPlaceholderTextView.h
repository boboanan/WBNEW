//
//  WBPlaceholderTextView.h
//  WB
//
//  Created by 锄禾日当午 on 15/7/15.
//  Copyright (c) 2015年 WWS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBPlaceholderTextView : UITextView

/**占位文字*/
@property (nonatomic, copy) NSString *placeholder;
/**占位文字颜色*/
@property (nonatomic, strong) UIColor *placeholderColor;
@end
