//
//  TalksTableViewController.m
//  项目--资讯
//
//  Created by tarena on 16/8/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TalksTableViewController.h"
#import "BmobUtils.h"
#import "ArticleCell.h"
#import "NormalNewsViewController.h"
#import "UIViewController+Example.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "FilterView.h"

@interface TalksTableViewController ()<FilterViewDelegate>

@property (nonatomic) NSMutableArray *articles;
@property (nonatomic) FilterView *filterView;
@property (nonatomic) NSArray *categorys;

@end

@implementation TalksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(WB);
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    
    self.filterView = [[FilterView alloc]initWithFrame:CGRectMake(0, 0, MainScreenW, 40)];
    self.filterView.filterViewDelegate = self;
    self.tableView.tableHeaderView = self.filterView;
        
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    self.articles = [NSMutableArray array];
    
    [self addRefreshView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

- (void)addRefreshView {
    
    __weak __typeof (self)weakself = self;
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadUpdateNews];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
}


-(void)loadUpdateNews{
    [BmobUtils searchAllArticlesWithCurrentUser:self.isIncludeCurrentUser andCallBack:^(id obj) {
        self.articles = [obj mutableCopy];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.articles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.bobj = self.articles[indexPath.section];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NormalNewsViewController *vc =[NormalNewsViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.bobj = self.articles[indexPath.section];
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 225;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenW, 10)];
    footerView.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.articles.count-1) {
        return .1;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return .1;
}

-(void)searchArticlesWithCategory:(NSString *)category{
    [BmobUtils seachAllArticlesWithCategory:category andCurrentUser:self.isIncludeCurrentUser andCallBack:^(id obj) {
        self.articles = [obj mutableCopy];
        [self.tableView reloadData];
    }];
}


@end
