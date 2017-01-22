//
//  EmailRegView.m
//  项目--资讯
//
//  Created by tarena on 16/8/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "EmailRegView.h"

@implementation EmailRegView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //用户名头像
        self.userIV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 17, 30, 30)];
        self.userIV.image = [UIImage imageNamed:@"邮箱"];
        [self addSubview:self.userIV];
        
        //用户名输入框
        self.userTF = [[UITextField alloc]initWithFrame:CGRectMake(51, 13, self.bounds.size.width-51-8, 40)];
        self.userTF.borderStyle = UITextBorderStyleNone;
        self.userTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入邮箱" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        //设置首字母是否大写
        self.userTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //x
        self.userTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.userTF.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        [self addSubview:self.userTF];
        
        //在两个tf中添加横线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.userTF.frame)+6, self.bounds.size.width, 1)];
        lineView.backgroundColor =  [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];

        [self addSubview:lineView];
        
        //密码头像
        self.pwdIV = [[UIImageView alloc]initWithFrame:CGRectMake(13, 73, 30, 30)];
        self.pwdIV.image = [UIImage imageNamed:@"密码"];
        [self addSubview:self.pwdIV];
        
        //密码输入框
        self.pwdTF = [[UITextField alloc]initWithFrame:CGRectMake(51, 69, self.bounds.size.width-51-8, 40)];
        self.pwdTF.borderStyle = UITextBorderStyleNone;
        self.pwdTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入密码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        self.userTF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.pwdTF.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        [self addSubview:self.pwdTF];
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pwdTF.frame)+6, self.bounds.size.width, 1)];
        lineView2.backgroundColor =  [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        [self addSubview:lineView2];
        
        self.backgroundColor = [UIColor clearColor];
//        self.layer.cornerRadius = 10;
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = [UIColor grayColor].CGColor;

    }
    return self;
}

@end
