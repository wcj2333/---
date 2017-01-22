//
//  ChangePwdViewController.m
//  项目--资讯
//
//  Created by tarena on 16/8/30.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ChangePwdViewController.h"

@interface ChangePwdViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLB;

@property (weak, nonatomic) IBOutlet UITextField *oldPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *updatePwdTF;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;


@end

@implementation ChangePwdViewController

- (IBAction)clickBtn:(id)sender {
    
    BmobUser *user = [BmobUser currentUser];
    [user updateCurrentUserPasswordWithOldPassword:self.oldPwdTF.text newPassword:self.updatePwdTF.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {//修改成功
            NSLog(@"修改成功");
            //返回前一个页面进行登录
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSLog(@"修改失败 error:%@",error);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"密码不正确";
            [UIView animateWithDuration:3.0 animations:^{
                hud.alpha = 0;
            }];
        }
    }];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    BmobUser *user = [BmobUser currentUser];
    self.userNameLB.text = user.username;
    self.userNameLB.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    self.userNameLB.superview.dk_backgroundColorPicker = self.oldPwdTF.dk_textColorPicker = self.updatePwdTF.dk_textColorPicker = DKColorPickerWithKey(BAR);
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.clickBtn.layer.cornerRadius = 10;
    self.clickBtn.layer.borderWidth = 1;
    self.clickBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.clickBtn dk_setTitleColorPicker:DKColorPickerWithKey(GRAY) forState:UIControlStateNormal];
}




@end
