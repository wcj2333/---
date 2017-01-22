//
//  CLView.m
//  CLView
//
//  Created by 陈林 on 16/4/6.
//  Copyright © 2016年 陈林. All rights reserved.
//

#import "CLHeaderCircleView.h"




@implementation CLHeaderCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        radius = 10;
        lineLength = 70;
        _isAnimation = NO;
     }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGPoint CG = CGPointMake(rect.size.width/2, rect.size.height/2);
    center = CG;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetShouldSubpixelQuantizeFonts(ctx, YES);
    CGContextSetAllowsAntialiasing(ctx, YES);
    
    CGContextBeginPath(ctx);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    
    //画笔宽度
    CGContextSetLineWidth(ctx, 1);
    
    //绘线
    CGContextMoveToPoint(ctx, center.x, center.y- radius -lineLength*(1-_pro) );
    CGContextAddLineToPoint(ctx, center.x, center.y-radius  );
    
    //绘圆  (起始点-M_PI/2，终止点  M_PI/2 *3)
    CGContextAddArc(ctx, center.x, center.y, radius,  -M_PI/2 ,5.0/3.0*M_PI*_pro - M_PI_2, 0);
    CGContextDrawPath(ctx, kCGPathStroke);
}


- (void)didScrollWithProgress:(float)progress
{
    _pro = progress;
    if ((progress == 1) & !_isAnimation) {
        [self start];
        _isAnimation = YES;
    }
 
    [self setNeedsDisplay];
}

- (void)start{
    [_delegate startAnimation];
}






@end
