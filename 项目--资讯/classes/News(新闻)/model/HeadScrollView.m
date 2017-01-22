//
//  HeadScrollView.m
//  项目--资讯
//
//  Created by mis on 16/9/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HeadScrollView.h"
#import "NewsUtils.h"
#import "RecommendViewController.h"
#import "NormalNewsViewController.h"
#import "HeadLineNews.h"

@implementation HeadScrollView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.dk_backgroundColorPicker = DKColorPickerWithKey(WB);
}

#pragma mark method
-(void)setScrollNews:(NSArray *)scrollNews{
    _scrollNews = scrollNews;
    self.scrollView.delegate = self;
    [self scrollView];
    [self pageContoller];
}
-(void)setHeadRecommends:(NSArray *)headRecommends{
    _headRecommends = headRecommends;
    [self subscribeScrollView];
}
-(void)tapViewAction:(UITapGestureRecognizer *)gesture{
    UIView *view = gesture.view;
    NSDictionary *dic = self.headRecommends[view.tag-1];
    RecommendViewController *vc = [RecommendViewController new];
    vc.subDic = dic;
    [self.delegate.navigationController pushViewController:vc animated:YES];
}

#pragma mark 懒加载
-(UIScrollView *)subscribeScrollView{
    if (!_subscribeScrollView) {
        _subscribeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreenW, 180)];
        _subscribeScrollView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        for (int i = 0; i<self.headRecommends.count; i++) {
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(i*125+5*i+5, 10, 125, 160)];
            bgView.dk_backgroundColorPicker = DKColorPickerWithKey(WB);
            bgView.layer.cornerRadius = 5;
            bgView.layer.borderWidth = 1;
            bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            bgView.layer.masksToBounds = YES;
            [_subscribeScrollView addSubview:bgView];
            //给背景view添加点击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewAction:)];
            bgView.tag = i+1;
            [bgView addGestureRecognizer:tap];
            //设置图片视图
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 125, 100)];
            iv.image = [UIImage imageNamed:@"订阅.jpg"];
            [bgView addSubview:iv];
            UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iv.frame), 125, 60)];
            lb.textAlignment = NSTextAlignmentCenter;
            lb.font = [UIFont systemFontOfSize:13];
            
            NSDictionary *dic = self.headRecommends[i];
            lb.text = [NSString stringWithFormat:@"#%@#",dic[@"tname"]];
            //设置字体格式
            lb.font = [UIFont fontWithName:self.fontStyle size:13];
            lb.dk_textColorPicker = DKColorPickerWithKey(TEXT);
            [bgView addSubview:lb];
            
        }
        _subscribeScrollView.contentSize = CGSizeMake(self.headRecommends.count*65, 0);
        [self addSubview:_subscribeScrollView];

    }
    return _subscribeScrollView;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, MainScreenW, 180)];
        [self addSubview:_scrollView];
        //添加图片
        for (int i = 0; i< self.scrollNews.count; i++){
            NSDictionary *adsDic = self.scrollNews[i];
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(i*MainScreenW, 0, MainScreenW, 180)];
            NSString *imgsrc = adsDic[@"imgsrc"];
            [iv sd_setImageWithURL:[NSURL URLWithString:imgsrc]];
            //添加点击手势
            iv.tag = i;
            iv.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIV:)];
            [iv addGestureRecognizer:tap];

            [_scrollView addSubview:iv];
            
            //给label赋值
            self.titleLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 155, MainScreenW-50, 20)];
            self.titleLB.textColor = [UIColor whiteColor];
            self.titleLB.font = [UIFont systemFontOfSize:13];
            self.titleLB.font = [UIFont fontWithName:self.fontStyle size:13];
            [iv addSubview:self.titleLB];
            NSString *title = adsDic[@"title"];
            self.titleLB.text = title;
        }
        _scrollView.contentSize = CGSizeMake(MainScreenW*self.scrollNews.count, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}
-(UIPageControl *)pageContoller{
    if (!_pageContoller) {
        _pageContoller = [[UIPageControl alloc]initWithFrame:CGRectMake(MainScreenW-50, 160, 10, 10)];
        [self addSubview:_pageContoller];
        _pageContoller.numberOfPages = self.scrollNews.count;
        _pageContoller.currentPage = 0;
        _pageContoller.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageContoller.pageIndicatorTintColor = [UIColor grayColor];
    }
    return _pageContoller;
}
//点击图片
-(void)tapIV:(UITapGestureRecognizer *)gesture{
    //ImageNewsDetailViewController *vc = [ImageNewsDetailViewController new];
    UIImageView *iv = (UIImageView *)gesture.view;
    NSDictionary *adsDic = self.scrollNews[iv.tag];
    NormalNewsViewController *vc = [NormalNewsViewController new];
    if ([adsDic[@"tag"] isEqualToString:@"photoset"]) {//图集
        
        vc.ad_url = adsDic[@"url"];
        vc.type = @"photoset";
     }else{
        vc.ad_url = adsDic[@"url"];
    }
    HeadLineNews *news = [[HeadLineNews alloc]init];
    news.title = adsDic[@"title"];
    news.imgsrc = adsDic[@"imgsrc"];
    news.docid = adsDic[@"url"];
    news.TAG = adsDic[@"tag"];
    news.source = adsDic[@"tag"];
    vc.news = news;
    vc.hidesBottomBarWhenPushed = YES;
    [self.delegate.navigationController pushViewController:vc animated:YES];
}


#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageContoller.currentPage = lround(self.scrollView.contentOffset.x/MainScreenW);
}

@end
