//
//  RecommendViewController.m
//  项目--资讯
//
//  Created by mis on 16/9/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "RecommendViewController.h"
#import "NewsUtils.h"
#import "SubscribeContentCell.h"
#import "UIScrollView+JElasticPullToRefresh.h"
#import "VideoPlayerViewController.h"
#import "NormalNewsViewController.h"

@interface RecommendViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UIView *headBgView;
@property (nonatomic) NSArray *subsribes;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation RecommendViewController

#pragma mark life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadNewContent];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.title = self.subDic[@"tname"];
    self.titleLB.text = [NSString stringWithFormat:@"#%@#",self.subDic[@"alias"]];
    self.titleLB.layer.cornerRadius = 5;
    self.titleLB.layer.borderWidth = 1;
    self.titleLB.layer.borderColor = [UIColor grayColor].CGColor;
    self.headIV.image = [UIImage imageNamed:@"订阅.jpg"];
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"SubscribeContentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    //下拉刷新
    // 初始化
    JElasticPullToRefreshLoadingViewCircle *loadingViewCircle = [[JElasticPullToRefreshLoadingViewCircle alloc] init];
    loadingViewCircle.tintColor = [UIColor whiteColor];
    __weak __typeof(self)weakSelf = self;
    [self.tableView addJElasticPullToRefreshViewWithActionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //获取数据
            [self loadNewContent];
            [weakSelf.tableView stopLoading];
        });
    } LoadingView:loadingViewCircle];
    //15 63 95
    [self.tableView setJElasticPullToRefreshFillColor:[UIColor colorWithRed:20/255.0 green:67/255.0 blue:100/255.0 alpha:1.0]];
    [self.tableView setJElasticPullToRefreshBackgroundColor:self.tableView.backgroundColor];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // [self.navigationController.navigationBar.subviews firstObject].hidden = NO;
//    self.navigationController.navigationBar.userInteractionEnabled = NO;
//    [self.navigationController setNavigationBarHidden:YES];

}


-(void)loadNewContent{
    [NewsUtils getSubscribeWithTid:self.subDic[@"tid"] andIndex:0 andCompletion:^(id obj) {
        self.subsribes = obj;
        [self.tableView reloadData];

    }];

}

#pragma mark UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.subsribes.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SubscribeContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.news = self.subsribes[indexPath.section];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HeadLineNews *news = self.subsribes[indexPath.section];
    if(!news.videoID){//没有视频播放信息 那么该视频是有文本内容的
        NormalNewsViewController *vc = [NormalNewsViewController new];
        vc.ad_url = news.docid;
        vc.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VideoPlayerViewController *vc = [VideoPlayerViewController new];
        vc.videoID = news.videoID;
        NSDictionary *videoInfoDic = news.videoinfo;
        NSDictionary *videoTopic = videoInfoDic[@"videoTopic"];
        vc.tid = videoTopic[@"tid"];
        [self.navigationController pushViewController:vc animated:YES];
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 205;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

@end
