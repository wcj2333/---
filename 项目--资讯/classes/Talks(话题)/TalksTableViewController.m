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
#import "CLRefresh.h"

@interface TalksTableViewController ()

@property (nonatomic) NSMutableArray *articles;
@property (nonatomic) RefreshFooterView *footerView;
@property (nonatomic) RefreshHeaderView *headerView;

@end

@implementation TalksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(WB);
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    self.articles = [NSMutableArray array];
    [self addRefreshView];
    [self.headerView startRefresh];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

- (void)addRefreshView {
    
    __weak __typeof (self)weakself = self;
    
    self.headerView = [self.tableView addHeaderWithRefreshHandler:^(RefreshBaseView *refreshView) {
        [weakself loadUpdateNews];
    }];
    
    
    self.footerView = [self.tableView addFooterWithRefreshHandler:^(RefreshBaseView *refreshView) {
        [weakself loadMoreNews];
        
    }];
}


-(void)loadUpdateNews{
    [BmobUtils searchAllArticlesWithCurrentUser:self.isIncludeCurrentUser andCallBack:^(id obj) {
        self.articles = [obj mutableCopy];
        [self.tableView reloadData];
        [self.headerView endRefresh];
    }];

}
-(void)loadMoreNews{
    
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

@end
