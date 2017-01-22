//
//  PhoneRegView.m
//  项目--资讯
//
//  Created by tarena on 16/8/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "PhoneRegView.h"

@implementation PhoneRegView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //用户名头像
        self.phoneIV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 18, 25, 25)];
        self.phoneIV.image = [UIImage imageNamed:@"手机"];
        [self addSubview:self.phoneIV];
        
        //用户名输入框
        self.phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(51, 13, self.bounds.size.width-51-8-8-90, 40)];
        self.phoneTF.borderStyle = UITextBorderStyleNone;
        self.phoneTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入手机号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        self.phoneTF.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        self.phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        //设置首字母是否大写
        self.phoneTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self addSubview:self.phoneTF];
        
        //验证码按钮
        self.codeBtn = [[UIButton alloc]initWithFrame:CGRectMake(51+self.phoneTF.bounds.size.width+8, 15, 90, 30)];
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.codeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.codeBtn.layer.borderColor = [UIColor grayColor].CGColor;
        self.codeBtn.layer.cornerRadius = 5;
        self.codeBtn.layer.borderWidth = 1;
        [self.codeBtn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.codeBtn];
        
        //在两个tf中添加横线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.phoneTF.frame)+6, self.bounds.size.width, 1)];
        lineView.backgroundColor =  [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];;
        [self addSubview:lineView];
        
        //验证码头像
        self.codeIV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 75, 25, 25)];
        self.codeIV.image = [UIImage imageNamed:@"验证码"];
        [self addSubview:self.codeIV];
        
        //验证码输入框
        self.codeTF = [[UITextField alloc]initWithFrame:CGRectMake(51, 69, self.bounds.size.width-51-8, 40)];
        self.codeTF.borderStyle = UITextBorderStyleNone;
        self.codeTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入验证码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        self.codeTF.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        self.codeTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.codeTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self addSubview:self.codeTF];
        
        //在两个tf中添加横线
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.codeTF.frame)+6, self.bounds.size.width, 1)];
        lineView1.backgroundColor =  [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self addSubview:lineView1];

        
        //密码头像
        self.pwdIV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 130, 25, 25)];
        self.pwdIV.image = [UIImage imageNamed:@"注册密码"];
        [self addSubview:self.pwdIV];
        
        //密码输入框
        self.pwdTF = [[UITextField alloc]initWithFrame:CGRectMake(51, 125, self.bounds.size.width-51-8, 40)];
        self.pwdTF.borderStyle = UITextBorderStyleNone;
        self.pwdTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入密码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        self.pwdTF.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        self.pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.pwdTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self addSubview:self.pwdTF];
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pwdTF.frame)+6, self.bounds.size.width, 1)];
        lineView2.backgroundColor =  [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self addSubview:lineView2];

        
        self.backgroundColor = [UIColor clearColor];
        
        self.time = 60;
    }
    return self;
}

-(void)clickAction{
    //点击
    self.codeBtn.backgroundColor = [UIColor lightGrayColor];
    self.codeBtn.userInteractionEnabled = NO;
    [self.codeBtn setTitle:@"重新获取(60)" forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getCodeTime:) userInfo:nil repeats:YES];
    
    //获取验证码
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:@"18758105737" andTemplate:@"test" resultBlock:^(int number, NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                    UIAlertView *tip = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [tip show];
                } else {
                    //获得smsID
                    NSLog(@"sms ID：%d",number);
                    //设置不可点击
        
                }
    }];

}
-(void)getCodeTime:(NSTimer *)timer{
    [self.codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%d)",self.time--] forState:UIControlStateNormal];
    if (self.time == 0) {
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.codeBtn.userInteractionEnabled = YES;
        self.codeBtn.layer.borderColor = [UIColor grayColor].CGColor;
        self.codeBtn.layer.borderWidth = 1;
        [timer invalidate];
    }
    
}

@end
