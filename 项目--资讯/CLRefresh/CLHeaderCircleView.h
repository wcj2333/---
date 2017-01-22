//
//  CLView.h
//  CLView
//
//  Created by 陈林 on 16/4/6.
//  Copyright © 2016年 陈林. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLHeaderCircleViewDelegate <NSObject>

- (void)startAnimation;
 
@end

@interface CLHeaderCircleView : UIView


{
    float radius; // 圆的半径
    CGPoint center; // 圆的中心
    float lineLength; //线的长度
 }


@property (nonatomic,assign) float pro;
@property (nonatomic,assign) BOOL isAnimation;


@property (nonatomic,assign) id <CLHeaderCircleViewDelegate>delegate;


- (void)didScrollWithProgress:(float)progress;

@end
