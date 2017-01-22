//
//  PhoneLoginView.m
//  项目--资讯
//
//  Created by mis on 16/9/5.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "PhoneLoginView.h"

@implementation PhoneLoginView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //用户名头像
        self.phoneIV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 18, 25, 25)];
        self.phoneIV.image = [UIImage imageNamed:@"手机"];
        [self addSubview:self.phoneIV];
        
        //用户名输入框
        self.phoneTF = [[UITextField alloc]initWithFrame:CGRectMake(51, 13,self.bounds.size.width-51-8, 40)];
        self.phoneTF.borderStyle = UITextBorderStyleNone;
        self.phoneTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入手机号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        self.phoneTF.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
        self.phoneTF.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        self.phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        //设置首字母是否大写
        self.phoneTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [self addSubview:self.phoneTF];
        
        
        //在两个tf中添加横线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.phoneTF.frame)+6, self.bounds.size.width, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self addSubview:lineView];
        
        //密码头像
        self.pwdIV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 75, 25, 25)];
        self.pwdIV.image = [UIImage imageNamed:@"注册密码"];
        [self addSubview:self.pwdIV];
        
        //密码输入框
        self.pwdTF = [[UITextField alloc]initWithFrame:CGRectMake(51, 69, self.bounds.size.width-51-8, 40)];
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
        
    }
    return self;
}

@end
