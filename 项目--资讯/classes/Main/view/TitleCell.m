//
//  TitleCell.m
//  项目--资讯
//
//  Created by mis on 16/9/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TitleCell.h"

@implementation TitleCell

- (void)awakeFromNib {
    self.titleLB.font = [UIFont systemFontOfSize:13];
    self.titleLB.layer.cornerRadius = 5;
    self.titleLB.layer.borderColor = [UIColor grayColor].CGColor;
    self.titleLB.layer.borderWidth = 1;
    self.titleLB.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.titleLB.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    //self.titleBtn.userInteractionEnabled = NO;

}

@end
