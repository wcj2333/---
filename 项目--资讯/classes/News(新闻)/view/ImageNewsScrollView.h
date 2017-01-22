//
//  ImageNewsScrollView.h
//  项目--资讯
//
//  Created by mis on 16/9/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NormalNewsParse.h"


@interface ImageNewsScrollView : UIScrollView

@property (nonatomic) UITextView *titleTV;
@property (nonatomic) UIImageView *imageView;

//如果是图集 获取图片
@property (nonatomic) NSArray *photoNews;

@end
