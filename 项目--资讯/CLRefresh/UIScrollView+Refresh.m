//
//  UIScrollView+Refresh.m
//  刷新控件
//
//  Created by 陈林 on 16/4/1.
//  Copyright © 2016年 陈林. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import "RefreshHeaderView.h"
#import "RefreshFooterView.h"

@implementation UIScrollView (Refresh)

- (RefreshHeaderView *)addHeaderWithRefreshHandler:(RefreshedHandler)refreshHandler
{
    RefreshHeaderView *header = [RefreshHeaderView headerWithRefreshHandler:refreshHandler];
    header.scrollView = self;
    return header;
}

- (RefreshFooterView *)addFooterWithRefreshHandler:(RefreshedHandler)refreshHandler{
    RefreshFooterView *footer = [RefreshFooterView footerWithRefreshHandler:refreshHandler];
    footer.scrollView = self;
    return footer;
}



@end
