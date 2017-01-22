//
//  LoginViewController.m
//  项目--资讯
//
//  Created by tarena on 16/8/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "PersonalTableViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property ( nonatomic) UILabel *errInfoLB;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.errInfoLB = [[UILabel alloc]initWithFrame:CGRectMake(Margin, 300, MainScreenW-2*Margin, 60)];
    self.title = @"登录";
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    [self updateUI];
}

#pragma mark - 方法 methods
-(void)updateUI{
    //在两个tf中添加横线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userNameTF.frame)+8, self.bgView.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:lineView];
    
    //背景边框
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //登录按钮边框
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.borderWidth = 1;
    self.loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.loginBtn dk_setTitleColorPicker:DKColorPickerWithKey(GRAY) forState:UIControlStateNormal];

    self.userNameTF.superview.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
    
}

- (IBAction)clickBtn:(UIButton *)sender {
    if (sender.tag == 0) {
        [BmobUser loginInbackgroundWithAccount:self.userNameTF.text andPassword:self.pwdTF.text block:^(BmobUser *user, NSError *error) {
            if (user) {//如果有用户
                //验证是否有经过邮箱验证了
                //应用开启了邮箱验证功能
                if ([user objectForKey:@"emailVerified"]) {
                    //用户没验证过邮箱
                    if (![[user objectForKey:@"emailVerified"] boolValue]) {
                        NSLog(@"没有验证邮箱");
                        [self showErrReason:@"没有验证邮箱"];
                        
                    }else{
                        [self showErrReason:@"登录成功"];
                        //登录成功
                        [self.navigationController popViewControllerAnimated:YES];
                        //记住用户名 密码
                        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                        [ud setObject:self.userNameTF.text forKey:@"userName"];
                        [ud synchronize];
                        
                    }
                }
            }else{//没有用户名
                
                //将错误信息打印出来
                NSString *errString = error.userInfo[NSLocalizedDescriptionKey];
                [self showErrReason:errString];
            }
        }];

    }else{
        RegisterViewController *vc = [RegisterViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
//展示错误原因
-(void)showErrReason:(NSString *)text{
    self.errInfoLB.text = text;
    self.errInfoLB.backgroundColor = [UIColor blackColor];
    self.errInfoLB.textColor = [UIColor whiteColor];
    self.errInfoLB.layer.cornerRadius = 10;
    self.errInfoLB.textAlignment = NSTextAlignmentCenter;
    [[UIApplication sharedApplication].keyWindow addSubview:self.errInfoLB];
    [UIView animateWithDuration:5.0 animations:^{
        self.errInfoLB.alpha = 0;
    }];
    
}


@end
