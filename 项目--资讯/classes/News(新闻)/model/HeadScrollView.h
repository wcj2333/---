//
//  HeadScrollView.h
//  项目--资讯
//
//  Created by mis on 16/9/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageNewsDetailViewController.h"
#import "NewsTableViewController.h"


@interface HeadScrollView : UIView<UIScrollViewDelegate>

@property (nonatomic) NSArray *scrollNews;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIScrollView *subscribeScrollView;
@property (nonatomic) UIPageControl *pageContoller;
@property (nonatomic) UILabel *titleLB;
@property (nonatomic,weak) NewsTableViewController *delegate;

@property (nonatomic) NSArray *headRecommends;
@property (nonatomic) NSString *fontStyle;
@end
