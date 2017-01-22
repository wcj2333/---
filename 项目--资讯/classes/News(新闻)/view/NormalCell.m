//
//  NormalCell.m
//  项目--资讯
//
//  Created by mis on 16/9/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "NormalCell.h"
#import "BmobUtils.h"
#import "BmobModel.h"

@implementation NormalCell

-(void)setHeadLineNews:(HeadLineNews *)headLineNews{
    _headLineNews = headLineNews;
    
    self.videoIV.hidden = YES;
    
    [self.imageIV sd_setImageWithURL:[NSURL URLWithString:headLineNews.imgsrc]];
    self.titleLB.text = headLineNews.title;
    
    [self.titleLB sizeToFit];
    self.titleLB.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.sourceLB.text = headLineNews.source;
    
    if ([self.sourceLB.text containsString:@"网易"]) {
        self.sourceLB.text = [self.sourceLB.text stringByReplacingOccurrencesOfString:@"网易" withString:@"介橙"];
    }
    //根据url查看评论人数
    [BmobUtils searchCommentWithNewsURL:headLineNews.docid andIsIncludeCurrentUser:NO andCallBack:^(id obj) {
        NSArray *arr = obj;
        if (arr.count>0) {
            self.commentLB.text = [NSString stringWithFormat:@"%ld评论",arr.count];
           
        }else{
            self.commentLB.text = @"0评论";
        }
        
        
    }];
    
    //设置字体
    if (self.fontStyle) {
        [self.titleLB setFont:[UIFont fontWithName:self.fontStyle size:17]];
        [self.sourceLB setFont:[UIFont fontWithName:self.fontStyle size:16]];
        [self.commentLB setFont:[UIFont fontWithName:self.fontStyle size:15]];

    }
    
    if (![headLineNews.TAG isEqualToString:@"photoset"]) {//存在
        NSLog(@"%@",headLineNews.TAG);
        //self.videoIV.hidden = NO;
        self.videoIV.image = [UIImage imageNamed:@"video"];
    }else{
        self.videoIV.hidden = YES;
    }
}
-(float)cellH{
    float imageH = self.imageIV.bounds.size.height+16;
    float lbH = self.titleLB.bounds.size.height+self.sourceLB.bounds.size.height+24;
    _cellH = imageH>lbH?imageH:lbH;
    return _cellH;
}

@end
