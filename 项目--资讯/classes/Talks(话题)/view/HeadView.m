//
//  HeadView.m
//  项目--资讯
//
//  Created by mis on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.albumIV.hidden = YES;
    self.titleTF.placeholder = @"这里可以输入标题";
}


- (IBAction)addAlbumAction:(id)sender {
    //添加封面
    [self.headViewDelegate chooseAlbumImage];
}



@end
