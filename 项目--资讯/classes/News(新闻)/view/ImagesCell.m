//
//  ImagesCell.m
//  项目--资讯
//
//  Created by mis on 16/9/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ImagesCell.h"
#import "UIView+Extend.h"

@implementation ImagesCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

-(void)setHeadLineNews:(HeadLineNews *)headLineNews{
    _headLineNews = headLineNews;
    self.titleLB.text = headLineNews.title;
    self.titleLB.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    for (int i = 0; i<self.imageViews.count; i++) {
        UIImageView *iv = self.imageViews[i];
        if (i == 2) {
            [iv sd_setImageWithURL:[NSURL URLWithString:headLineNews.imgsrc] placeholderImage:[UIImage imageNamed:@"背景3"]];
        }else{
            NSArray *imgnewextra = headLineNews.imgnewextra;
            if (imgnewextra.count>0) {
                NSDictionary *dic = imgnewextra[i];
                NSString *imagePath = dic[@"imgsrc"];
                [iv sd_setImageWithURL:[NSURL URLWithString:imagePath]];

            }else{
                [iv sd_setImageWithURL:[NSURL URLWithString:headLineNews.imgsrc] placeholderImage:[UIImage imageNamed:@"背景3"]];
            }

        }
    }
    self.sourceLB.text = headLineNews.source;
    if ([self.sourceLB.text containsString:@"网易"]) {
        self.sourceLB.text = [self.sourceLB.text stringByReplacingOccurrencesOfString:@"网易" withString:@"介橙"];
    }
    self.commentLB.text = @"0评论";
    if (headLineNews.TAG) {//存在
        self.videoIV.hidden = NO;
    }else{
        self.videoIV.hidden = YES;
    }
    
    //设置字体
    if (self.fontStyle) {
        [self.titleLB setFont:[UIFont fontWithName:self.fontStyle size:19]];
        [self.sourceLB setFont:[UIFont fontWithName:self.fontStyle size:16]];
        [self.commentLB setFont:[UIFont fontWithName:self.fontStyle size:15]];
        
    }

}

-(float)imageCellH{
    _imageCellH = self.titleLB.height+80+self.sourceLB.height+32;
    return _imageCellH;
}


@end
