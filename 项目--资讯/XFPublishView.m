//
//  XFPublishView.m
//
//
//  Created by LMJ on 16/2/25.
//  Copyright © 2016年 LMJ. All rights reserved.
//

#import "XFPublishView.h"
#define LSCREENH [UIScreen mainScreen].bounds.size.height
#define LSCREENW [UIScreen mainScreen].bounds.size.width
#define ShareH 300
@interface XFPublishView ()

@end
@implementation XFPublishView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor =[[UIColor blackColor]colorWithAlphaComponent:0.6];
        
        UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, ShareH, LSCREENW, LSCREENH-ShareH)];
        [self addSubview:view];
        
    
        float btnWidth = (self.bounds.size.width-15*2-50*2)/3;
        float top = 150;
        //发表文字
        UIButton *nightBtn = [self btnAnimateWithFrame:CGRectMake(LSCREENW/4-30, (LSCREENH-ShareH-60+150)/2, 60, 100) imageName:@"" animateFrame:CGRectMake(15,top, btnWidth, btnWidth) delay:0.0];
        [nightBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        nightBtn.tag=1;
        [view addSubview:nightBtn];

        
        UIImageView * nightIV = [[UIImageView alloc]initWithFrame:CGRectMake((btnWidth-70)/2, 0, 70, 70)];
        nightIV.image = [UIImage imageNamed:@"文字"];
        [nightBtn addSubview:nightIV];
        
        UILabel *nightLB = [[UILabel alloc]initWithFrame:CGRectMake((btnWidth-70)/2, 78, 70, 20)];
        nightLB.text = @"发表文字";
        nightLB.textAlignment = NSTextAlignmentCenter;
        nightLB.font = [UIFont systemFontOfSize:15];
        nightLB.textColor = [UIColor lightGrayColor];
        [nightBtn addSubview:nightLB];
        
        
        //夜间模式
        UIButton *textBtn = [self btnAnimateWithFrame:CGRectMake(LSCREENW/4-30, (LSCREENH-ShareH-60+150)/2, 60, 100) imageName:@"" animateFrame:CGRectMake(50+btnWidth+15,top, btnWidth, btnWidth) delay:0.0];
        textBtn.tag=2;
        [textBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:textBtn];
        
        NSInteger index = [[NSUserDefaults standardUserDefaults]integerForKey:@"index"];
        UIImageView * textIV = [[UIImageView alloc]initWithFrame:CGRectMake((btnWidth-70)/2, 0, 70, 70)];
        [textBtn addSubview:textIV];
        UILabel *textLB = [[UILabel alloc]initWithFrame:CGRectMake((btnWidth-70)/2, 78, 70, 20)];

        //判断哪个是夜间/日用
        if (index%2 == 0) {
            textIV.image = [UIImage imageNamed:@"夜间模式1"];
            textLB.text = @"夜间模式";
        }else{
            textIV.image = [UIImage imageNamed:@"日间模式"];
            textLB.text = @"日间模式";
        }
        
        textLB.textAlignment = NSTextAlignmentCenter;
        textLB.font = [UIFont systemFontOfSize:15];
        textLB.textColor = [UIColor lightGrayColor];
        [textBtn addSubview:textLB];
        
        
        //签到
        UIButton *regBtn = [self btnAnimateWithFrame:CGRectMake(LSCREENW/4-30, (LSCREENH-ShareH-60+150)/2, 60, 100) imageName:@"" animateFrame:CGRectMake(15+100+2*btnWidth,top, btnWidth, btnWidth) delay:0.0];
        regBtn.tag=3;
        [regBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:regBtn];
        
        
        UIImageView * regIV = [[UIImageView alloc]initWithFrame:CGRectMake((btnWidth-70)/2, 0, 70, 70)];
        regIV.image = [UIImage imageNamed:@"签到"];
        [regBtn addSubview:regIV];
        
        UILabel *regLB = [[UILabel alloc]initWithFrame:CGRectMake((btnWidth-70)/2, 78, 70, 20)];
        regLB.text = @"签到";
        regLB.textAlignment = NSTextAlignmentCenter;
        regLB.font = [UIFont systemFontOfSize:15];
        regLB.textColor = [UIColor lightGrayColor];
        [regBtn addSubview:regLB];

        

        
        UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
        plus.frame = CGRectMake((LSCREENW-25)/2 ,LSCREENH-50, 25, 25);
        [plus setImage:[UIImage imageNamed:@"关掉"] forState:UIControlStateNormal];
        [plus addTarget:self action:@selector(cancelAnimation) forControlEvents:UIControlEventTouchUpInside];
        plus.tag =3;
        [self addSubview:plus];
        [UIView animateWithDuration:0.2 animations:^{
            
            plus.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
        
      
    }
    return self;
}
-(void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}
-(UIButton *)btnAnimateWithFrame:(CGRect)frame imageName:(NSString *)imageName animateFrame:(CGRect)aniFrame delay:(CGFloat)delay
{
    UIButton * btn =[[UIButton alloc]init];
    btn.frame =frame;
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self  addSubview:btn];
    
    [UIView animateWithDuration:1 delay:delay usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        btn.frame  = aniFrame;
        
    } completion:^(BOOL finished) {
        
    }];
    return btn;
    
    //usingSpringWithDamping :弹簧动画的阻尼值，也就是相当于摩擦力的大小，该属性的值从0.0到1.0之间，越靠近0，阻尼越小，弹动的幅度越大，反之阻尼越大，弹动的幅度越小，如果大道一定程度，会出现弹不动的情况。
    //initialSpringVelocity :弹簧动画的速率，或者说是动力。值越小弹簧的动力越小，弹簧拉伸的幅度越小，反之动力越大，弹簧拉伸的幅度越大。这里需要注意的是，如果设置为0，表示忽略该属性，由动画持续时间和阻尼计算动画的效果。
    
}
-(void)BtnClick:(UIButton*)btn
{
    for (NSInteger i = 0; i<self.subviews.count; i++)
    {
        UIView *view = self.subviews[i];
        if ([view isKindOfClass:[UIButton class]])
        {
            [UIView animateWithDuration:0.3 delay:0.1*i options:UIViewAnimationOptionTransitionCurlDown animations:^{
                view.frame = CGRectMake(view.frame.origin.x, LSCREENH, 60, 60);
            } completion:^(BOOL finished) {
            }];
        }
    }
  
    [self performSelector:@selector(removeView:) withObject:btn afterDelay:0.5];
    
}
-(void)removeView:(UIButton*)btn
{
     [self removeFromSuperview];
     [self.delegate didSelectBtnWithBtnTag:btn.tag];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPosition = [touch locationInView:self];
    
    CGFloat deltaY = currentPosition.y;
    if (deltaY<(LSCREENH-ShareH))
    {
        [self cancelAnimation];
    }
}
-(void)cancelAnimation
{
    UIButton * cancelBtn =(UIButton*)[self viewWithTag:3];
    [UIView animateWithDuration:0.2 animations:^{
        
        cancelBtn.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }];
   
    for (NSInteger i = 0; i<self.subviews.count; i++)
    {
        UIView *view = self.subviews[i];
        if ([view isKindOfClass:[UIButton class]])
        {
            [UIView animateWithDuration:0.3 delay:0.1*i options:UIViewAnimationOptionTransitionCurlDown animations:^{
                view.frame = CGRectMake(view.frame.origin.x, LSCREENH, 60, 60);
            } completion:^(BOOL finished) {
                
                [self removeFromSuperview];
            }];
        }
    }
}



@end
