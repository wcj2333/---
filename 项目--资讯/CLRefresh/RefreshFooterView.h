//
//  RefreshFooterView.h
//  刷新控件
//
//  Created by 陈林 on 16/4/1.
//  Copyright © 2016年 陈林. All rights reserved.
//

#import "RefreshBaseView.h"

@interface RefreshFooterView : RefreshBaseView<CLFooterCircleViewDelegate>


/**
 *  是否自动加载更多，默认上拉超过scrollView的内容高度时，直接加载更多
 */
@property (nonatomic, unsafe_unretained) BOOL autoLoadMore;



+ (instancetype)footerWithRefreshHandler:(RefreshedHandler)refreshHandler;

//显示没有更多数据
- (void)showNoMoreData;
//重置没有更多的数据（消除没有更多数据的状态）
- (void)resetNoMoreData;


@end
