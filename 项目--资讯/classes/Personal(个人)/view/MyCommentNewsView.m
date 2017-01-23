//
//  MyCommentNewsView.m
//  项目--资讯
//
//  Created by 王陈洁 on 17/1/19.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import "MyCommentNewsView.h"
#import "BmobUtils.h"

@implementation MyCommentNewsView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentNews:)];
    [self addGestureRecognizer:tap];
    
}

-(void)setModel:(NormalNewsParse *)model{//    _model = model;
    [self.imageIV sd_setImageWithURL:[NSURL URLWithString:self.albumPath]];
    self.titleLB.text = model.title;
    self.titleLB.font = [UIFont systemFontOfSize:13];
    
    [self.titleLB sizeToFit];
    self.titleLB.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.sourceLB.text = model.source;
    
    if ([self.sourceLB.text containsString:@"网易"]) {
        self.sourceLB.text = [self.sourceLB.text stringByReplacingOccurrencesOfString:@"网易" withString:@"介橙"];
    }

}
-(void)setPhotosets:(NSArray *)photosets{
    _photosets = photosets;
    [self.imageIV sd_setImageWithURL:[NSURL URLWithString:photosets[1]]];
    self.titleLB.text = photosets[0];
    self.titleLB.font = [UIFont systemFontOfSize:13];
    
    [self.titleLB sizeToFit];
    self.titleLB.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    if ([photosets[2] isEqualToString:@""]) {
        self.sourceLB.text = @"图集";
    }else{
        self.sourceLB.text = photosets[2];
    }
    
    if ([self.sourceLB.text containsString:@"网易"]) {
        self.sourceLB.text = [self.sourceLB.text stringByReplacingOccurrencesOfString:@"网易" withString:@"介橙"];
    }

}

-(void)setAlbumPath:(NSString *)albumPath{
    _albumPath = albumPath;
    [self.imageIV sd_setImageWithURL:[NSURL URLWithString:albumPath]];
}
-(void)setCountNum:(NSNumber *)countNum{
    _countNum = countNum;
    self.commentLB.text = [NSString stringWithFormat:@"%@评论",countNum];
}

-(void)commentNews:(UITapGestureRecognizer *)gesture{
    if (self.model) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"评论新闻详情" object:@[self.titleLB.text,self.sourceLB.text,self.albumPath,self.source,@""]];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"评论新闻详情" object:@[self.titleLB.text,self.sourceLB.text,self.photosets[1],self.source,@""]];
    }
    
}

@end
