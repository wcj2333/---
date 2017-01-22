//
//  RefreshFooterView.m
//  刷新控件
//
//  Created by 陈林 on 16/4/1.
//  Copyright © 2016年 陈林. All rights reserved.
//

#import "RefreshFooterView.h"

@implementation RefreshFooterView
@synthesize refreshState = _refreshState;

+ (instancetype)footerWithRefreshHandler:(RefreshedHandler)refreshHandler {
    
    RefreshFooterView *footer = [[RefreshFooterView alloc] init];
    footer.refreshHandler = refreshHandler;
    return footer;
}

- (void)setStateText {
    self.normalStateText = @"上拉加载更多";
    self.pullingStateText = @"松开可加载更多";
    self.loadingStqateText = @"正在加载更多...";
    self.noMoreDataStateText = @"没有更多数据";
}

- (void)addRefreshContentView {
    
 [super addRefreshContentView];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    //刷新状态
    _statusLabel = [[UILabel alloc] init];
    _statusLabel.frame = CGRectMake(0, 0, screenWidth, LoadingOffsetHeight);
    _statusLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    _statusLabel.textColor = FCXREFRESHTEXTCOLOR;
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_statusLabel];
    
    //箭头图片
    _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueArrow"]];
    _arrowImage.frame = CGRectMake(screenWidth/2.0 - 100, 12.5, 15, 40);
    //[self addSubview:_arrowImage];
    
    //转圈动画
//    _circleView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //_activityView.frame = _arrowImage.frame;
    _footerCircle = [[CLFooterCircleView alloc] initWithFrame:CGRectMake(screenWidth/2.0 - 100, (LoadingOffsetHeight - 40)/2.0 + 5, 30, 30)];
    _footerCircle.delegate = self;
    [self addSubview:_footerCircle];
    
}

- (void)setAutoLoadMore:(BOOL)autoLoadMore {
    
    _autoLoadMore = autoLoadMore;
    if (_autoLoadMore) {//自动加载更多不显示箭头
        [_arrowImage removeFromSuperview];
        _arrowImage = nil;
        self.normalStateText = @"正在加载更多...";
        self.pullingStateText = @"正在加载更多...";
        self.loadingStqateText = @"正在加载更多...";
    }
}

- (void)scrollViewContentSizeDidChange {
    
    CGRect frame = self.frame;
    frame.origin.y =  MAX(self.scrollView.frame.size.height, self.scrollView.contentSize.height);
    self.frame = frame;
}


- (void)scrollViewContentOffsetDidChange {
    
    float contentY = [self exceedScrollviewContentSizeHeight];
    float progress = contentY/LoadingOffsetHeight;
    
    progress = progress>1?1:progress;
    
    [_footerCircle  didScrollWithProgress:progress];
    
    if (self.refreshState == ReFreshStateNoMoreData) {//没有更多数据
        return;
    }
    
    if (self.autoLoadMore) {//如果是自动加载更多
        if ([self exceedScrollviewContentSizeHeight] > 1) {//大于偏移量1，转为加载更多loading
            self.refreshState = RefreshStateLoading;
        }
        return;
    }
    
    if (self.scrollView.isDragging) {
        
        if ([self exceedScrollviewContentSizeHeight] > LoadingOffsetHeight) {//大于偏移量，转为pulling
            self.refreshState = RefreshStatePulling;
        }else {//小于偏移量，转为正常normal
            self.refreshState = RefreshStateNormal;
        }
        
    } else {
        
        if (self.refreshState == RefreshStatePulling) {//如果是pulling状态，改为加载更多loading
            
            self.refreshState = RefreshStateLoading;
            
        }else if ([self exceedScrollviewContentSizeHeight] < LoadingOffsetHeight) {//如果小于偏移量，转为正常normal
            
            self.refreshState = RefreshStateNormal;
        }
        
    }
}

//超过scrollview的contentSize高度
- (CGFloat)exceedScrollviewContentSizeHeight {
    
    //获取scrollview实际显示内容高度
    CGFloat actualShowHeight = self.scrollView.frame.size.height - _originalEdgeInset.bottom - _originalEdgeInset.top;
    return self.scrollView.contentOffset.y - (self.scrollView.contentSize.height - actualShowHeight);
}

- (void)setRefreshState:(ReFreshState)refreshState {
    
    ReFreshState lastRefreshState = _refreshState;
    
    if (_refreshState != refreshState) {
        _refreshState = refreshState;
        
        __weak __typeof(self)weakSelf = self;
        
        switch (refreshState) {
            case RefreshStateNormal:
            {
                _statusLabel.text = self.normalStateText;
                if (lastRefreshState == RefreshStateLoading) {//之前是刷新过
                    _arrowImage.hidden = YES;
                } else {
                    _arrowImage.hidden = NO;
                }
                _arrowImage.hidden = NO;
                
               // [_activityView stopAnimating];
                [self resignNormal];

                
                [UIView animateWithDuration:0.2 animations:^{
                    _arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                    weakSelf.scrollView.contentInset = _originalEdgeInset;
                }];
                
                
            }
                break;
                
            case RefreshStatePulling:
            {
                _statusLabel.text = self.pullingStateText;
                
                [UIView animateWithDuration:0.2 animations:^{
                    _arrowImage.transform = CGAffineTransformIdentity;
                }];
                
            }
                break;
            case RefreshStateLoading:
            {
                _statusLabel.text = self.loadingStqateText;
              //  [_activityView startAnimating];
                _arrowImage.hidden = YES;
                _arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    UIEdgeInsets inset = weakSelf.scrollView.contentInset;
                    inset.bottom += LoadingOffsetHeight;
                    weakSelf.scrollView.contentInset = inset;
                    inset.bottom = self.frame.origin.y - weakSelf.scrollView.contentSize.height + LoadingOffsetHeight;
                    weakSelf.scrollView.contentInset = inset;
                    
                }];
                
                if (self.refreshHandler) {
                    self.refreshHandler(self);
                }
                
            }
                break;
            case ReFreshStateNoMoreData:
            {
                _statusLabel.text = self.noMoreDataStateText;
            }
                break;
        }
    }
}


- (void)resignNormal
{
    if (!  _footerCircle.isAnimation) {
        return;
    }
    [_footerCircle.layer removeAnimationForKey:@"rotationAnimation"];
    
    _footerCircle.isAnimation = NO;
    NSLog(@"关闭尾部动画");
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
    
    [_footerCircle.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    NSLog(@"打开尾部动画");
}


- (void)endRefresh {
    [self scrollViewContentSizeDidChange];
    [super endRefresh];
}

- (void)showNoMoreData {
    self.refreshState = ReFreshStateNoMoreData;
}

- (void)resetNoMoreData {
    self.refreshState = RefreshStateNormal;
}

@end
