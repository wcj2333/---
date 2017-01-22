//
//  NewsTableViewController.m
//  项目--资讯
//
//  Created by tarena on 16/8/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "NewsTableViewController.h"
#import "NewsUtils.h"
#import "UIImageView+WebCache.h"
#import "HeadLineNews.h"
#import "HeadLineNews.h"
#import "HeadScrollView.h"
#import "NormalCell.h"
#import "ImagesCell.h"
#import "ImageNewsDetailViewController.h"
#import "NormalNewsViewController.h"
#import "VideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "CLRefresh.h"
#import "TNRefreshFooterView.h"
#import "TNRefreshHeaderView.h"
#import "UIScrollView+LDRefresh.h"

@interface NewsTableViewController ()

@property (nonatomic) NSMutableArray *headNews;
@property (nonatomic) NSInteger index;
@property (nonatomic) NSArray *scrollNews;
@property (nonatomic) float normalCellH;
@property (nonatomic) NSMutableArray *recommendArr;
@property (nonatomic) HeadScrollView *scrollView;
@property (nonatomic) NSString *fontStyle;
@property (nonatomic) NSDictionary *newsItemDic;
@property (nonatomic) RefreshHeaderView *headerView;
@property (nonatomic) RefreshFooterView *footerView;
@property (nonatomic) NSInteger recommentIndex;

@end

@implementation NewsTableViewController

#pragma mark life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.headNews = [NSMutableArray array];
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.scrollView = (HeadScrollView *)self.tableView.tableHeaderView;
    self.scrollView.delegate = self;
    
    if ([self.type isEqualToString:@"推荐"]) {
        
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }else{
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    }
    self.tableView.backgroundColor = [UIColor whiteColor];
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"NormalCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NormalCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ImagesCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ImagesCell"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeFontSystem:) name:@"改变字体" object:nil];
    
    [self addRefreshView];
    //[self loadUpdateNews];
    //[self.tableView.refreshHeader startRefresh];
    [self.headerView startRefresh];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGRect frame = self.tableView.tableHeaderView.frame;
    if ([self.type isEqualToString:@"推荐"]) {
        frame.size.height = 100;
    }else{
        frame.size.height = 180;
    }
    self.tableView.tableHeaderView.frame = frame;
    [self.tableView reloadData];
}


#pragma mark method
- (void)addRefreshView {
    
    __weak __typeof (self)weakself = self;
    
    //下拉刷新
    self.headerView = [self.tableView addHeaderWithRefreshHandler:^(RefreshBaseView *refreshView) {
        [weakself loadUpdateNews];
    }];
    
//    self.tableView.refreshFooter = [self.tableView addRefreshFooterWithHandler:^ {
//        [weakself loadMoreNews];
//    }];

    self.footerView = [self.tableView addFooterWithRefreshHandler:^(RefreshBaseView *refreshView) {
        [weakself loadMoreNews];
        
    }];
}
-(void)changeFontSystem:(NSNotification *)noti{
    self.fontStyle = noti.object[@"font"];
    self.scrollView.fontStyle = self.fontStyle;
    [self.scrollView reloadInputViews];
    
    [self.tableView reloadData];
}


//获取新内容
-(void)loadUpdateNews{
    if ([self.type isEqualToString:@"推荐"]) {
        [NewsUtils getRecommendWithSize:20 withCompletion:^(id obj){
            self.recommendArr = [NSMutableArray array];
            NSArray *recommends = obj;
            for (int i = 0; i<recommends.count; i++) {
                if (i == 0) {
                    //获取头部的一堆订阅信息
                    HeadLineNews *content = recommends[0];
                    self.scrollView.headRecommends = content.dingyue;
                }else{
                    [self.recommendArr addObject:recommends[i]];
                }
            }
            [self.tableView reloadData];
            [self.headerView endRefresh];
            self.recommentIndex = 0;

        }];
        
    }else{
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        NSString *newsItem = self.newsItemDic[self.item];
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//        hud.mode = MBProgressHUDModeIndeterminate;
        [NewsUtils getHeadNewsWithItem:newsItem WithIndex:0 andCompletion:^(id obj) {
            NSArray *arr = (NSArray *)obj;
            for (int i = 0; i< arr.count; i++) {
                if (i == 0) {
                    //轮播图
                    HeadLineNews *newObj = arr[0];
                    if (newObj.ads) {//有轮播图的话
                        self.scrollView.scrollNews = newObj.ads;
                    }else{
                        //就不要轮播图了
                        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"背景.jpg"]];
                        self.tableView.tableHeaderView = iv;
                    }
                    
                }else{
                    [self.headNews addObject:obj[i]];
                }
            }
            [self.tableView reloadData];
           // [hud hideAnimated:YES];
            [self.headerView endRefresh];
            self.index = 0;
        }];
    }

}

//获取更多的内容
-(void)loadMoreNews{
    self.index += 20;
    if (![self.type isEqualToString:@"推荐"]) {
         NSString *newsItem = self.newsItemDic[self.item];
        [NewsUtils getHeadNewsWithItem:newsItem WithIndex:self.index andCompletion:^(id obj) {
            [self.headNews addObjectsFromArray:obj];
            [self.tableView reloadData];
//            [self.tableView.refreshFooter endRefresh];
//            self.tableView.refreshFooter.loadMoreEnabled = NO;
            [self.footerView endRefresh];
        }];

    }else{
//        self.index+=20;
//        if (self.index>40) {
//            [self.tableView.refreshFooter endRefresh];
//            self.tableView.refreshFooter.loadMoreEnabled = NO;
//        }else{
        self.recommentIndex +=20;
            [NewsUtils getRecommendWithSize:self.recommentIndex withCompletion:^(id obj) {
            [self.recommendArr removeAllObjects];
            NSArray *arr = obj;
            for (int i = 0; i<arr.count; i++) {
                if (i>0) {
                    [self.recommendArr addObject:arr[i]];
                }
            }
                [self.tableView reloadData];
//                [self.tableView.refreshFooter endRefresh];
//                self.tableView.refreshFooter.loadMoreEnabled = NO;
                [self.footerView endRefresh];
            }];
//        }
    }
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.type isEqualToString:@"推荐"]) {
        return  self.recommendArr.count;
    }
    return self.headNews.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HeadLineNews *news = nil;
    if ([self.type isEqualToString:@"推荐"]) {
        news = self.recommendArr[indexPath.row];
    }else{
        news = self.headNews[indexPath.row];
    }
        if (!news.imgnewextra) {//没值
            NormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
            cell.headLineNews = news;
            cell.fontStyle = self.fontStyle;
            self.normalCellH = cell.cellH;
            cell.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);

            
            return cell;
        }else{
            ImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImagesCell"];
            cell.headLineNews = news;
            cell.fontStyle = self.fontStyle;
            cell.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
            cell.dk_textColorPicker = DKColorPickerWithKey(TEXT);
            self.normalCellH = cell.imageCellH;
            
            return cell;
        }

    //}
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HeadLineNews *news = nil;
    if ([self.type isEqualToString:@"推荐"]) {
        news = self.recommendArr[indexPath.row];
    }else{
        news = self.headNews[indexPath.row];
    }
    
    if ([news.tag isEqualToString:@"photoset"]) {//存在
        //ImageNewsDetailViewController *vc = [ImageNewsDetailViewController new];
        NormalNewsViewController *vc = [NormalNewsViewController new];
        vc.ad_url = news.skipID;
        vc.news = news;
        vc.type = @"photoset";
        [self.navigationController pushViewController:vc animated:YES];
    }else if(!news.videoID){//没有视频播放信息 那么该视频是有文本内容的
        NormalNewsViewController *vc = [NormalNewsViewController new];
        vc.ad_url = news.docid;
        vc.news = news;
        vc.fontStyle = self.fontStyle;
        vc.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
//        VideoPlayerViewController *vc = [VideoPlayerViewController new];
//        vc.videoID = news.videoID;
//        NSDictionary *videoInfoDic = news.videoinfo;
//        NSDictionary *videoTopic = videoInfoDic[@"videoTopic"];
//        vc.tid = videoTopic[@"tid"];
//        [self.navigationController pushViewController:vc animated:YES];
        NSDictionary *videoInfoDic = news.videoinfo;
        NSDictionary *videoTopic = videoInfoDic[@"videoTopic"];
        AVPlayerViewController *vc = [AVPlayerViewController new];
        [NewsUtils getHeadLineVideoWithTid:videoTopic[@"tid"] andVideoID:news.videoID andCompletion:^(id obj) {
            //创建网络地址的播放项 给个网址就可以了
            NSString *urlString = obj;
            vc.player = [AVPlayer playerWithURL:[NSURL URLWithString:urlString]];
            [vc.player play];
            [self presentViewController:vc animated:YES completion:nil];
        }];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HeadLineNews *news = nil;
    if ([self.type isEqualToString:@"推荐"]) {
        news = self.recommendArr[indexPath.row];
    }else{
        news = self.headNews[indexPath.row];
    }
    
    if (news.imgnewextra) {
        return self.normalCellH;
    }
    return self.normalCellH;
}

#pragma mark lazyLoad
-(NSDictionary *)newsItemDic{
    if (_newsItemDic == nil) {
        _newsItemDic = @{@"头条":@"T1348647853363",@"娱乐":@"T1348648517839",@"轻松一刻":@"T1350383429665",@"体育":@"T1348649079062",@"科技":@"T1348649580692",@"军事":@"T1348648141035",@"财经":@"T1348648756099",@"手机":@"T1348649654285",@"游戏":@"T1348654151579",@"历史":@"T1368497029546",@"社会":@"T1348648037603",@"电影":@"T1348648650048",@"电视":@"T1348648673314",@"NBA":@"T1348649145984",@"足球":@"T1348649176279",@"旅游":@"T1348654204705",@"汽车":@"T1348654060988",@"房产":@"T1348654085632",@"iPhone限免":@"T1364203460717"};
    }
    return _newsItemDic;
}

@end
