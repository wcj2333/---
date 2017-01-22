//
//  RegisterViewController.m
//  项目--资讯
//
//  Created by tarena on 16/8/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "RegisterViewController.h"
#import "EmailRegView.h"
#import "PhoneRegView.h"
#import "PersonalTableViewController.h"


@interface RegisterViewController ()

@property (nonatomic) EmailRegView *emailRegView;
@property (nonatomic) UIButton *regBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *regSegment;
@property (nonatomic) UILabel *errLB;
@property (nonatomic) PhoneRegView *phoneRegView;

@end

@implementation RegisterViewController

#pragma mark - 生命周期 life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    //self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:248/255.0 blue:253/255.0 alpha:1];
    self.errLB = [[UILabel alloc]initWithFrame:CGRectMake(Margin, 300, MainScreenW-2*Margin, 60)];
    self.regBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 200)];
    [self updateUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar.subviews firstObject].hidden = YES;
}

#pragma mark - 方法 methods
- (IBAction)changeValue:(UISegmentedControl *)sender {
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
    if (self.regSegment.selectedSegmentIndex == 0) {
        [self.phoneRegView removeFromSuperview];
        self.emailRegView = [[EmailRegView alloc]initWithFrame:CGRectMake(Margin*4, CGRectGetMaxY(self.regSegment.frame)+12, MainScreenW-16*4, 119)];
        [self.view addSubview:self.emailRegView];
        //self.emailRegView.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
        
        //添加注册按钮
        self.regBtn.frame = CGRectMake(Margin*5, CGRectGetMaxY(self.emailRegView.frame)+20, MainScreenW-16*5, 48);
    }else{
        [self.emailRegView removeFromSuperview];
        self.phoneRegView = [[PhoneRegView alloc]initWithFrame:CGRectMake(Margin*4, CGRectGetMaxY(self.regSegment.frame)+12, MainScreenW-16*4, 175)];
        [self.view addSubview:self.phoneRegView];
        //self.phoneRegView.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
        
        //添加注册按钮
        self.regBtn.frame = CGRectMake(Margin*5, CGRectGetMaxY(self.phoneRegView.frame)+20, MainScreenW-16*5, 48);
    }
    
    [self.regBtn setTitle:@"注册" forState:UIControlStateNormal];
    self.regBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.regBtn addTarget:self action:@selector(regAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.regBtn];
    self.regBtn.layer.cornerRadius = 10;
    self.regBtn.layer.borderWidth = 1;
    self.regBtn.layer.borderColor = [UIColor colorWithRed:38/255.0 green:125/255.0 blue:239/255.0 alpha:1].CGColor;
    [self.regBtn dk_setTitleColorPicker:DKColorPickerWithKey(GRAY) forState:UIControlStateNormal];
}
-(void)regAction{
    if (self.regSegment.selectedSegmentIndex == 0) {
        BmobUser *user = [[BmobUser alloc]init];
        user.username = self.emailRegView.userTF.text;
        user.password = self.emailRegView.pwdTF.text;
        BOOL emailValid = [self validateEmail:self.emailRegView.userTF.text];
        if (!emailValid) {//不正确
            //[self showErrReason:@"邮箱不正确"];
            [BaseNewsUtils toastview:@"邮箱不正确"];
        }else{
            user.email = self.emailRegView.userTF.text;
            [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {//注册成功
                    NSLog(@"注册成功");
                    //返回登录
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    NSString *errString = error.userInfo[NSLocalizedDescriptionKey];
                    NSLog(@"reg errString:%@",errString);
                    //[self showErrReason:@"邮箱已经被注册了"];
                    [BaseNewsUtils toastview:@"邮箱已经被注册了"];
                }
            }];
        }

    }else{
        [BmobUser signOrLoginInbackgroundWithMobilePhoneNumber:self.phoneRegView.phoneTF.text andSMSCode:self.phoneRegView.codeTF.text block:^(BmobUser *user, NSError *error) {
            if (user) {
                //跳转
                //[self showErrReason:@"注册成功"];
                [BaseNewsUtils toastview:@"注册成功"];
                [user setObject:self.phoneRegView.pwdTF.text forKey:@"password"];
                [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        //直接登录了 回到个人设置页面
                        NSInteger index = 0;
                        for (UIViewController *vc in self.navigationController.viewControllers) {
                            index ++;
                            if ([vc isKindOfClass:[PersonalTableViewController class]]) {
                                break;
                            }
                        }
                        [self.navigationController popToViewController:self.navigationController.viewControllers[index-1] animated:YES];
                    }
                }];
                
                
            } else {
                NSLog(@"%@",error);
                [BaseNewsUtils toastview:@"注册失败"];
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

//判断邮箱是否合法
-(BOOL) validateEmail:(NSString *)email{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}



@end
