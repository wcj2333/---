//
//  RefreshHeaderView.m
//  刷新控件
//
//  Created by 陈林 on 16/4/1.
//  Copyright © 2016年 陈林. All rights reserved.
//

#import "RefreshHeaderView.h"

@implementation RefreshHeaderView

@synthesize refreshState = _refreshState;

+(instancetype)headerWithRefreshHandler:(RefreshedHandler)refreshHandler
{
    RefreshHeaderView *header = [[RefreshHeaderView alloc] init];
    header.refreshHandler = refreshHandler;
    return header;
}

- (void)setStateText
{
    self.normalStateText = @"下拉刷新";
    self.pullingStateText = @"松开即可刷新";
    self.loadingStqateText = @"正在刷新...";
}

- (void)addRefreshContentView
{
    [super addRefreshContentView];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    //刷新状态
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.frame = CGRectMake(0, 15, screenWidth, 20);
    _statusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    _statusLabel.textColor = FCXREFRESHTEXTCOLOR;
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_statusLabel];
    
    //更新时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.frame = CGRectMake(0, 35, screenWidth, 20);
    _timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    _timeLabel.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_timeLabel];
    
    //箭头图片
    _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueArrow"]];
    _arrowImage.frame = CGRectMake(screenWidth/2.0 - 100, (LoadingOffsetHeight - 40)/2.0 + 5, 15, 40);
    // [self addSubview:_arrowImage];
    
    //转圈动画
    
    _headerCircle = [[CLHeaderCircleView alloc] initWithFrame:CGRectMake(screenWidth/2.0 - 100, (LoadingOffsetHeight - 40)/2.0 + 5, 30, 30)];
    _headerCircle.delegate = self;
    [self addSubview:_headerCircle];
    
    [self updateTimeLabelWitLastUpdateTime:[NSDate date]];
    
}

- (void)scrollViewContentOffsetDidChange{
    if (self.scrollView.isDragging) {   //判断是否正在拖拽
        float   progress = (-self.scrollView.contentOffset.y < LoadingOffsetHeight ?-self.scrollView.contentOffset.y:LoadingOffsetHeight )/LoadingOffsetHeight;
        progress =    progress >0 ? progress:0;
        [_headerCircle didScrollWithProgress:progress];
        if (self.scrollView.contentOffset.y < -LoadingOffsetHeight) {
            self.refreshState = RefreshStatePulling;
            
        } else {         //小于偏移量，转为正常状态
            self.refreshState = RefreshStateNormal;
        }
    }  else  {
        if (self.refreshState == RefreshStatePulling) { //如果书pulling状态
            self.refreshState =  RefreshStateLoading;
        } else if (self.scrollView.contentOffset.y > -LoadingOffsetHeight) {
            self.refreshState = RefreshStateNormal;
        }
        
    }
}



- (void)setRefreshState:(ReFreshState)refreshState
{
    ReFreshState lastRefreshState = _refreshState;
    if (_refreshState != refreshState) {
        _refreshState = refreshState;
        
        __weak  __typeof (self) weakSelf = self;
        
        
        switch (refreshState) {
            case RefreshStateNormal:        //正常状态
                
                
            {        _statusLabel.text = self.normalStateText;
                if (lastRefreshState == RefreshStateLoading) {  //加入之前是刷新了控件
                    [self updateTimeLabelWitLastUpdateTime:[NSDate date]];
                }
                _arrowImage.hidden = NO;
                //  [_activityView stopAnimating];
                
                
                [self resignNormal];
                
                
                [UIView animateWithDuration:0.2 animations:^{
                    _arrowImage.transform = CGAffineTransformIdentity;
                    
                    weakSelf.scrollView.contentInset = _originalEdgeInset;
                }];
            }
                
                break;
                
                
                
                
            case RefreshStatePulling:    //pulling 状态
            {
                _statusLabel.text = self.pullingStateText;
                [UIView animateWithDuration:0.2 animations:^{
                    _arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                }];
                
            }
                break;
            case RefreshStateLoading: {
                _statusLabel.text = self.loadingStqateText;
                
                //[_activityView startAnimating];
                _arrowImage.hidden = YES;
                _arrowImage.transform = CGAffineTransformIdentity;
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    UIEdgeInsets edgeInset = _originalEdgeInset;
                    edgeInset.top += LoadingOffsetHeight;
                    weakSelf.scrollView.contentInset = edgeInset;
                    
                }];
                
                if (self.refreshHandler) {
                    self.refreshHandler(self);
                }
                
                
            }
                break;
                
            case ReFreshStateNoMoreData: {
                
                
            }
                
                
            default:
                break;
        }
        
        
        
        
    }
    
    
}

- (void)resignNormal
{
    if (!  _headerCircle.isAnimation) {
        return;
    }
    [_headerCircle.layer removeAnimationForKey:@"rotationAnimation"];
    
    _headerCircle.isAnimation = NO;
    NSLog(@"关闭头部动画");
}


#pragma mark
- (void)startAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.8;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [_headerCircle.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    NSLog(@"打开头部动画");
}




- (void)startRefresh
{
    
    __weak __typeof (self)weakSelf = self;
    weakSelf.refreshState = RefreshStateLoading;
    
    [UIView animateWithDuration:.2 animations:^{
        weakSelf.scrollView.contentOffset = CGPointMake(0, -LoadingOffsetHeight);
    } completion:^(BOOL finished) {
        weakSelf.refreshState = RefreshStateLoading;
    }];
    
}


- (void)updateTimeLabelWitLastUpdateTime:(NSDate *)lastUpdateTime
{
    
    if (!lastUpdateTime){
        _timeLabel.text = @"最后更新：无记录";
        return;
    }
    
    //获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:lastUpdateTime];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    //格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day]) { // 今天
        formatter.dateFormat = @"今天 HH:mm";
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:lastUpdateTime];
    //显示日期
    _timeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
    
    
}








@end
