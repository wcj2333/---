//
//  ImageNewsScrollView.m
//  项目--资讯
//
//  Created by mis on 16/9/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ImageNewsScrollView.h"
#import "HeadImgeNews.h"
#import "PhotoBroswerVC.h"

@implementation ImageNewsScrollView

-(void)setPhotoNews:(NSArray *)photoNews{
    _photoNews = photoNews;
    self.contentSize = CGSizeMake(MainScreenW*self.photoNews.count, 0);
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    for (int i = 0; i<self.photoNews.count; i++) {
        HeadImgeNews *news = self.photoNews[i];
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(MainScreenW*i, 50, MainScreenW, 350)];
        //对图片添加点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNewsImageAction:)];
        self.imageView.userInteractionEnabled = YES;
        self.imageView.tag = i;
        [self.imageView addGestureRecognizer:tap];
        [self addSubview:self.imageView];
        self.titleTV = [[UITextView alloc]initWithFrame:CGRectMake(MainScreenW*i, CGRectGetMaxY(self.imageView.frame)+8, MainScreenW, 100)];
        self.titleTV.backgroundColor = [UIColor blackColor];
        self.titleTV.textColor = [UIColor whiteColor];
        self.titleTV.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.titleTV];

        //赋值
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:news.imgurl]];
        if ([news.note containsString:@"网易"]) {
            news.note = [news.note stringByReplacingOccurrencesOfString:@"网易" withString:@"介橙"];
            self.titleTV.text = [NSString stringWithFormat:@"%d/%ld     %@",i+1,self.photoNews.count,news.note];
        }
    }

}
//新闻图片的点击事件
-(void)tapNewsImageAction:(UITapGestureRecognizer *)gesture{
    [self.superview endEditing:YES];
    UIImageView *iv = (UIImageView *)gesture.view;
    [PhotoBroswerVC show:[UIApplication sharedApplication].keyWindow.rootViewController type:PhotoBroswerVCTypeZoom index:iv.tag photoModelBlock:^NSArray *{
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:self.photoNews.count];
        
        for (NSUInteger i = 0; i< self.photoNews.count; i++) {
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            
            HeadImgeNews *news = self.photoNews[i];
            NSString *path = news.imgurl;
            
            //设置查看大图的时候的图片地址
            pbModel.image_HD_U = path;
            
            //源图片的frame
            UIImageView *imageV =(UIImageView *) self.subviews[i];
            pbModel.sourceImageView = imageV;
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
        
    }];

}

@end
