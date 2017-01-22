//
//  CLFooterCircleView.h
//  刷新控件
//
//  Created by 陈林 on 16/4/7.
//  Copyright © 2016年 陈林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLFooterCircleViewDelegate <NSObject>

- (void)startAnimation;


@end

@interface CLFooterCircleView : UIView


{
    float radius; // 圆的半径
    CGPoint center; // 圆的中心
    float lineLength; //线的长度
}





@property (nonatomic,assign) float pro;
@property (nonatomic,assign) BOOL isAnimation;


@property (nonatomic,assign) id <CLFooterCircleViewDelegate>delegate;


- (void)didScrollWithProgress:(float)progress;

@end
