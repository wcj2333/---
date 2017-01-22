//
//  RefreshBaseView.m
//  刷新控件
//
//  Created by 陈林 on 16/4/1.
//  Copyright © 2016年 陈林. All rights reserved.
//

#import "RefreshBaseView.h"

@implementation RefreshBaseView
- (void)removeFromSuperview
{
    [self.superview removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [self.superview removeObserver:self forKeyPath:@"contentSize" context:nil];
    [super removeFromSuperview];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setStateText];
        [self addRefreshContentView];
        self.refreshState = RefreshStateNormal;
    }
    return self;
}



- (void)addRefreshContentView
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(0,-LoadingOffsetHeight , screenWidth, LoadingOffsetHeight);
    [self setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:self];
}

- (void)setStateText
{
    
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    if (_scrollView != scrollView) {
        _originalEdgeInset = scrollView.contentInset;
        [_scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
        [_scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
        _scrollView = scrollView;
        
        [_scrollView addSubview:self];
        [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [_scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];

        
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //正在刷新
    if(self.refreshState == RefreshStateLoading) {
        return;
    }
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewContentOffsetDidChange];
    } else if ([keyPath isEqualToString:@"contentSize"] ) {
        [self scrollViewContentSizeDidChange];
    }
}



- (void)scrollViewContentSizeDidChange
{
    
}

- (void)scrollViewContentOffsetDidChange
{
    
}

- (void)startRefresh
{
    
}

- (void)endRefresh
{
    self.refreshState = RefreshStateNormal;
}


@end
