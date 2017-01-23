//
//  AboutSystemViewController.m
//  项目--资讯
//
//  Created by 王陈洁 on 17/1/23.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import "AboutSystemViewController.h"

@interface AboutSystemViewController ()

@property (weak, nonatomic) IBOutlet UILabel *iconNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;


@end

@implementation AboutSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.iconNameLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.firstLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.secondLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.thirdLabel.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    
}


@end
