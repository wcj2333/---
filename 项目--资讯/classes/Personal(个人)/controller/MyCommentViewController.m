//
//  MyCommentViewController.m
//  项目--资讯
//
//  Created by 王陈洁 on 17/1/19.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import "MyCommentViewController.h"
#import "BmobModel.h"
#import <BmobSDK/Bmob.h>
#import "BmobUtils.h"
#import "MyCommentTableView.h"
#import "NormalNewsParse.h"
#import "NewsUtils.h"
#import "NormalNewsViewController.h"

@interface MyCommentViewController ()

@property (nonatomic) NormalNewsParse *parse;
@property (nonatomic) NSMutableArray *comments;
@property (nonatomic) NSMutableArray *commentNews;
@property (nonatomic) NSMutableArray *commentCounts;
@property (nonatomic) NSInteger index;
@property (nonatomic) NSInteger index2;
@property (nonatomic) MyCommentTableView *tableView;

@end

@implementation MyCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentNews = [NSMutableArray array];
    self.commentCounts = [NSMutableArray array];
    
    MyCommentTableView *tableView = [[MyCommentTableView alloc]initWithFrame:CGRectMake(0, 0, MainScreenW, MainScreenH)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [BmobUtils searchCommentWithNewsURL:nil andIsIncludeCurrentUser:YES andCallBack:^(id obj) {
        self.comments = [NSMutableArray array];
        for (BmobObject *object in obj) {
            BmobModel *model = [[BmobModel alloc]initWithObj:object];
            
            [self.comments addObject:model];
            //获取每一个的评论数
            
        }
        tableView.comments = self.comments;
        [self getCommentNewsInfoWithSource];
        [self setNewsCommentCount];
    }];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(seeNewsDetail:) name:@"评论新闻详情" object:nil];
}

//获取评论新闻的内容
-(void)getCommentNewsInfoWithSource{
    BmobModel *model = self.comments[self.index];
    //请求新闻数据
    if ([model.source containsString:@"|"]) {//图集
        [NewsUtils getPhotosetInfoWithSource:model.source andCallBack:^(id obj) {
            [self.commentNews addObject:obj];
            self.index ++;
            if (self.index == self.comments.count) {
                self.tableView.commentNews = self.commentNews;
            }else{
                [self getCommentNewsInfoWithSource];
            }
        }];
    }else{
        [NewsUtils getHeadLineNewsWithDocid:model.source andCompletion:^(id obj) {
            self.parse = obj;
            [self.commentNews addObject:self.parse];
            self.index ++;
            if (self.index == self.comments.count) {
                self.tableView.commentNews = self.commentNews;
            }else{
                [self getCommentNewsInfoWithSource];
            }
            
            
        }];
    }
}

-(void)setNewsCommentCount{
    BmobModel *model = self.comments[self.index2];
    [BmobUtils searchCommentWithNewsURL:model.source andIsIncludeCurrentUser:NO andCallBack:^(id obj) {
        NSArray *arr = obj;
        self.index2++;
        [self.commentCounts addObject:@(arr.count)];
        if (self.index2 == self.comments.count) {
            self.tableView.commentCounts = self.commentCounts;
        }else{
            [self setNewsCommentCount];
        }
    }];
}

-(void)seeNewsDetail:(NSNotification *)noti{
    NormalNewsViewController *vc = [NormalNewsViewController new];
    vc.ad_url = noti.object;
    NSString *str = noti.object;
    if ([str containsString:@"|"]) {
        vc.type = @"photoset";
    }
    vc.hidesBottomBarWhenPushed =YES;
    [self.navigationController pushViewController:vc animated:YES];

}


@end
