//
//  UIScrollView+Refresh.h
//  刷新控件
//
//  Created by 陈林 on 16/4/1.
//  Copyright © 2016年 陈林. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "RefreshBaseView.h"

@class RefreshHeaderView;
@class RefreshFooterView;


@interface UIScrollView (Refresh)

- (RefreshHeaderView *)addHeaderWithRefreshHandler:(RefreshedHandler)refreshHandler;

- (RefreshFooterView *)addFooterWithRefreshHandler:(RefreshedHandler)refreshHandler;

@end
