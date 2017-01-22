//
//  RefreshBaseView.h
//  刷新控件
//
//  Created by 陈林 on 16/4/1.
//  Copyright © 2016年 陈林. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CLFooterCircleView.h"
#import "CLHeaderCircleView.h"

typedef NS_ENUM( NSInteger, ReFreshState){
    RefreshStateNormal = 1,  //正常状态
    RefreshStatePulling = 2,      // 控件正在被拉动
    RefreshStateLoading = 3,     //正在加载中
    ReFreshStateNoMoreData = 4    //上拉提示没有更多数据
    
};


typedef NS_ENUM(NSInteger,RefreshViewType) {
    RefreshBaseViewTypeHeader = -1,
    RefreshBaseViewTypeFooter = 1
};


/// 刷新偏移量的高度
static const CGFloat LoadingOffsetHeight = 60;

/// 文本颜色
#define FCXREFRESHTEXTCOLOR [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0]


@class RefreshBaseView;
typedef void (^RefreshedHandler)(RefreshBaseView *refreshView);

@interface RefreshBaseView : UIView

{
    ///时间L
    UILabel *_timeLabel;
    
    UILabel *_statusLabel;
    UIImageView *_arrowImage;
    CLHeaderCircleView  * _headerCircle;
    CLFooterCircleView *_footerCircle;
    UIEdgeInsets _originalEdgeInset;
}



@property (nonatomic,weak) UIScrollView *scrollView; //需要添加刷新的滚动式图
@property (nonatomic,copy) RefreshedHandler refreshHandler;  //相应的当前事件
@property (nonatomic,unsafe_unretained) ReFreshState refreshState; // 刷新状态
@property (nonatomic,copy) NSString *normalStateText; //正常状态下的提示文本
@property (nonatomic,copy) NSString *pullingStateText ;  // 下拉状态下的提示文本
@property (nonatomic,copy) NSString *loadingStqateText; //加载状态下的提示文本
@property (nonatomic,copy) NSString *noMoreDataStateText; //没有更多数据状态时的提示文本

//设置各种状态的文本
- (void)setStateText;


//添加刷新界面
- (void)addRefreshContentView;

// 开始刷新
- (void)startRefresh;

// 结束刷新
- (void)endRefresh;

//当scrollView的contentOffset发生改变的时候调用
- (void)scrollViewContentOffsetDidChange;

//当ScrollView的contentSize发生改变的时候调用
- (void)scrollViewContentSizeDidChange;



@end
