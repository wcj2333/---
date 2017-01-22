//
//  Login1ViewController.m
//  项目--资讯
//
//  Created by mis on 16/9/5.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "Login1ViewController.h"
#import "EmailRegView.h"
#import "PhoneLoginView.h"
#import "RegisterViewController.h"
#import "BaseNewsUtils.h"

@interface Login1ViewController ()

@property ( nonatomic) UILabel *errLB;
@property (weak, nonatomic) IBOutlet UISegmentedControl *loginSegment;
@property (nonatomic) EmailRegView *emailLogView;
@property (nonatomic) PhoneLoginView *phoneLogView;
@property (nonatomic) UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation Login1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.errLB = [[UILabel alloc]initWithFrame:CGRectMake(Margin, 300, MainScreenW-2*Margin, 60)];
    self.title = @"登录";
   // self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:248/255.0 blue:253/255.0 alpha:1];
    self.loginBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    
    [self updateUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar.subviews firstObject].hidden = YES;
    
}


- (IBAction)regBtn:(id)sender {
    RegisterViewController *vc = [RegisterViewController new];
    [self.navigationController pushViewController:vc animated:YES];

}


- (IBAction)segValueChange:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0://邮箱
            [self updateUI];
            break;
        case 1://手机号
            [self updateUI];
            break;
    }

}
-(void)updateUI{
    self.iconImageView.layer.cornerRadius = self.iconImageView.bounds.size.height/2;
    self.iconImageView.layer.masksToBounds = YES;
    if (self.loginSegment.selectedSegmentIndex == 0) {
        [self.phoneLogView removeFromSuperview];
        self.emailLogView = [[EmailRegView alloc]initWithFrame:CGRectMake(Margin*4, CGRectGetMaxY(self.loginSegment.frame)+12, MainScreenW-16*4, 119)];
        [self.view addSubview:self.emailLogView];
        //self.emailLogView.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
        self.emailLogView.userTF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
        
        //添加注册按钮
        self.loginBtn.frame = CGRectMake(Margin*5, CGRectGetMaxY(self.emailLogView.frame)+20, MainScreenW-16*5, 48);
    }else{
        [self.emailLogView removeFromSuperview];
        self.phoneLogView = [[PhoneLoginView alloc]initWithFrame:CGRectMake(Margin*4, CGRectGetMaxY(self.loginSegment.frame)+12, MainScreenW-16*4, 119)];
        [self.view addSubview:self.phoneLogView];
        //self.phoneLogView.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
        
        //添加注册按钮
        self.loginBtn.frame = CGRectMake(Margin*5, CGRectGetMaxY(self.phoneLogView.frame)+20, MainScreenW-16*5, 48);
    }
    
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.loginBtn addTarget:self action:@selector(regAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    
    self.loginBtn.layer.cornerRadius = 10;
    self.loginBtn.layer.borderWidth = 1;
    //38 125 239
    self.loginBtn.layer.borderColor = [UIColor colorWithRed:38/255.0 green:125/255.0 blue:239/255.0 alpha:1].CGColor;
    [self.loginBtn dk_setTitleColorPicker:DKColorPickerWithKey(GRAY) forState:UIControlStateNormal];
    
}
-(void)regAction{
    if (self.loginSegment.selectedSegmentIndex == 0) {
        [BmobUser loginInbackgroundWithAccount:self.emailLogView.userTF.text andPassword:self.emailLogView.pwdTF.text block:^(BmobUser *user, NSError *error) {
            if (user) {//如果有用户
                //验证是否有经过邮箱验证了
                //应用开启了邮箱验证功能
                if ([user objectForKey:@"emailVerified"]) {
                    //用户没验证过邮箱
                    if (![[user objectForKey:@"emailVerified"] boolValue]) {
                        NSLog(@"没有验证邮箱");
                        //[self showErrReason:@"没有验证邮箱"];
                        [BaseNewsUtils toastview:@"没有验证邮箱"];
                        
                    }else{
                        //[self showErrReason:@"登录成功"];
                        [BaseNewsUtils toastview:@"登录成功"];
                        //登录成功
                        [self.navigationController popViewControllerAnimated:YES];
                        //记住用户名 密码
                        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                        [ud setObject:self.emailLogView.userTF.text forKey:@"email"];
                        [ud synchronize];
                        
                    }
                }
            }else{//没有用户名
                
                //将错误信息打印出来
                NSString *errString = error.userInfo[NSLocalizedDescriptionKey];
                //[self showErrReason:errString];
                [BaseNewsUtils toastview:@"登录失败"];
            }
        }];
        
    }else{
        [BmobUser loginInbackgroundWithAccount:self.phoneLogView.phoneTF.text andPassword:self.phoneLogView.pwdTF.text block:^(BmobUser *user, NSError *error) {
            if (user) {//如果有用户
                //[self showErrReason:@"登录成功"];
                [BaseNewsUtils toastview:@"登录成功"];
                //登录成功
                [self.navigationController popViewControllerAnimated:YES];
                //记住用户名 密码
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:self.phoneLogView.phoneTF.text forKey:@"phone"];
                [ud synchronize];
                
            }else{//没有用户名
                
                //将错误信息打印出来
                NSString *errString = error.userInfo[NSLocalizedDescriptionKey];
                //[self showErrReason:errString];
                [BaseNewsUtils toastview:@"登录失败"];
            }
        }];
        
    }
}
//展示错误原因
-(void)showErrReason:(NSString *)text{
    self.errLB.text = text;
    self.errLB.backgroundColor = [UIColor blackColor];
    self.errLB.textColor = [UIColor whiteColor];
    self.errLB.layer.cornerRadius = 10;
    self.errLB.textAlignment = NSTextAlignmentCenter;
    [[UIApplication sharedApplication].keyWindow addSubview:self.errLB];
    [UIView animateWithDuration:5.0 animations:^{
        self.errLB.alpha = 0;
    }];
    
}



@end
