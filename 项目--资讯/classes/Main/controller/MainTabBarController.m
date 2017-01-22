//
//  MainTabBarController.m
//  项目--资讯
//
//  Created by tarena on 16/8/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "MainTabBarController.h"
#import "NewsTableViewController.h"
#import "TalksTableViewController.h"
#import "PersonalTableViewController.h"
#import "MainNavigationController.h"
#import "NewsTabBarViewController.h"
#import "TalkViewController.h"
#import "LeftMenuView.h"
#import "SendArticleViewController.h"
#import "Login1ViewController.h"

@interface MainTabBarController ()<LeftMenuViewDelegate>

@property (nonatomic) LeftMenuView *leftMenuView;

@end

@implementation MainTabBarController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBar.dk_barTintColorPicker = DKColorPickerWithKey(BAR);
    
    [self.tabBar addSubview:self.leftMenuView];
    //隐藏tabBar
    //self.tabBar.hidden = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    NewsTabBarViewController *nvc =[NewsTabBarViewController new];
    //推荐页面
     NewsTableViewController *rvc = [NewsTableViewController new];
    rvc.type = @"推荐";
    TalksTableViewController *tvc = [TalksTableViewController new];
    PersonalTableViewController *pvc = [PersonalTableViewController new];
    
    nvc.title = @"新闻";
    rvc.title = @"推荐";
    tvc.title = @"话题";
    pvc.title = @"个人中心";

    
    self.viewControllers = @[[[MainNavigationController alloc]initWithRootViewController:nvc],
                             [[MainNavigationController alloc]initWithRootViewController:rvc],
                             [[MainNavigationController alloc]initWithRootViewController:tvc],
                             [[MainNavigationController alloc]initWithRootViewController:pvc],
    ];
}

-(LeftMenuView *)leftMenuView{
    if (_leftMenuView == nil) {
        _leftMenuView = [[LeftMenuView alloc]init];
        _leftMenuView.leftMenuViewDelegate = self;
        _leftMenuView.menus = @[@"新闻",@"推荐",@"添加",@"话题",@"我"];
        _leftMenuView.frame = CGRectMake(0, 0, MainScreenW, self.tabBar.frame.size.height);
    }
    return _leftMenuView;
}

-(void)sendArticle{
    if ([BmobUser currentUser]) {
        SendArticleViewController *vc = [SendArticleViewController new];
        [self.selectedViewController presentViewController:vc animated:YES completion:nil];
    }else{
        Login1ViewController *vc = [Login1ViewController new];
        MainNavigationController *navi = (MainNavigationController *)self.selectedViewController;
        vc.hidesBottomBarWhenPushed = YES;
        [navi pushViewController:vc animated:YES];
    }

}


@end
