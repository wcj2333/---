//
//  ModeCell.m
//  项目--资讯
//
//  Created by tarena on 16/8/29.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ModeCell.h"
#import "SingleDayAndNight.h"

@implementation ModeCell

- (void)awakeFromNib {

    [super awakeFromNib];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    //在两者间添加竖的分割线
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(MainScreenW/2, 8, 1, 28)];
    [self addSubview:view];
    view.backgroundColor = [UIColor lightGrayColor];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, MainScreenW, 1)];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor lightGrayColor];
}

- (IBAction)readNews:(UIButton *)sender {
    [self.modeCellDelegate chooseModeWithButton:sender];
}
- (IBAction)nightReadAction:(UIButton *)sender {
    [self.modeCellDelegate chooseModeWithButton:sender];
}


@end
