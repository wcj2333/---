//
//  ArticleTopView.m
//  项目--资讯
//
//  Created by 王陈洁 on 17/1/13.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import "ArticleTopView.h"

@implementation ArticleTopView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainScreenW, 44)];
        titleLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        titleLabel.text = @"发表话题";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        self.cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        self.cancleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancleButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        [self addSubview:self.cancleButton];
        
        self.sendButton = [[UIButton alloc]initWithFrame:CGRectMake(MainScreenW-50, 0, 50, 40)];
        self.sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.sendButton setTitle:@"发表" forState:UIControlStateNormal];
        [self.sendButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        [self addSubview:self.sendButton];

    }
    return self;
}

@end
