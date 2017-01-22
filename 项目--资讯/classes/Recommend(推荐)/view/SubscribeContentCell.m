//
//  SubscribeContentCell.m
//  项目--资讯
//
//  Created by mis on 16/9/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "SubscribeContentCell.h"

@implementation SubscribeContentCell

- (void)awakeFromNib {
    self.dk_backgroundColorPicker = DKColorPickerWithKey(WB);
    self.imgIV.layer.masksToBounds = YES;
}

-(void)setNews:(HeadLineNews *)news{
    _news = news;
    self.titleLB.text = news.title;
    [self.imgIV sd_setImageWithURL:[NSURL URLWithString:news.imgsrc] placeholderImage:[UIImage imageNamed:@"背景2.jpg"]];
    self.digestLB.text = news.digest;
}

@end
