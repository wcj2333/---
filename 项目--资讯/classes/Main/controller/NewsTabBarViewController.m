//
//  NewsTabBarViewController.m
//  项目--资讯
//
//  Created by mis on 16/9/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "NewsTabBarViewController.h"
#import "NewsTableViewController.h"
#import "PullDownView.h"
#import "UIView+Extend.h"

@interface NewsTabBarViewController ()

@property (nonatomic) UIButton *btn;
@property (nonatomic) PullDownView *pullView;
@property (nonatomic) UILabel *pullLB;

@end

@implementation NewsTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTabBar];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.btn = [[UIButton alloc]initWithFrame:CGRectMake(screenSize.width-40, 64, 40, 44)];
    self.btn.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
    [self.btn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(addTitle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    
    self.pullView = [[PullDownView alloc]initWithFrame:CGRectMake(0, 104-[UIScreen mainScreen].bounds.size.height,self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-104)];
    self.pullView.delegate = self;
    [self.view addSubview:self.pullView];
    [self initViewControllers];

    self.pullLB = [[UILabel alloc]initWithFrame:self.tabBar.frame];
    self.pullLB.height = 40;
    self.pullLB.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
    
}

-(void)setTabBar{
    self.tabBar.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
    //设置
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 64, screenSize.width-40, 44)
        contentViewFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - 64 - 50)];
    
    self.tabBar.itemTitleColor = [UIColor lightGrayColor];
    self.tabBar.itemTitleSelectedColor = [UIColor redColor];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:15];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:15];
    self.tabBar.leftAndRightSpacing = 20;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = [UIColor redColor];
    
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(40, 15, 0, 15) tapSwitchAnimated:NO];
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:40];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];

}

//添加视图控制器
-(void)initViewControllers{
    NSMutableArray *pages = [NSMutableArray array];
    for (int i = 0; i<self.pullView.selectedTitles.count; i++) {
        NewsTableViewController *vc =[NewsTableViewController new];
        vc.yp_tabItemTitle = self.pullView.selectedTitles[i];
        vc.item = vc.yp_tabItemTitle;
        
        [pages addObject:vc];
    }
    self.viewControllers = pages;
    //选择栏目后，点击某一项就相应的选择该项
    self.selectedControllerIndex = self.selectIndex;
    self.tabBar.selectedItemIndex = self.selectIndex;
}

//添加标题
-(void)addTitle{

    if (![self.pullLB.text isEqualToString:@"栏目选择"]) {
        //self.viewControllers = nil;
        self.pullLB.text = @"栏目选择";
        self.pullLB.font = [UIFont systemFontOfSize:13];
        self.pullLB.textColor = [UIColor grayColor];
        [self.view addSubview:self.pullLB];
        //[[UIApplication sharedApplication].keyWindow addSubview:self.pullLB];
        self.pullLB.alpha = 0;
        [UIView animateWithDuration:1.0 animations:^{
            self.pullLB.alpha = 1;
            self.pullView.frame = CGRectMake(0, 104, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-104);
        } completion:^(BOOL finished) {
            [self.btn setImage:[UIImage imageNamed:@"上拉"] forState:UIControlStateNormal];
        }];

    }else{
        [UIView animateWithDuration:1.0 animations:^{
            self.pullView.frame = CGRectMake(0, 104-[UIScreen mainScreen].bounds.size.height,self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height-104);
            self.pullLB.alpha = 0;
            self.pullLB.text = @"";
            [self.pullLB removeFromSuperview];
            
        } completion:^(BOOL finished) {
            [self initViewControllers];
            [self.btn setImage:[UIImage imageNamed:@"下拉"] forState:UIControlStateNormal];
        }];
    }
    //选完以后
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.pullView.selectedTitles forKey:@"selectedTitles"];
    NSLog(@"%ld",self.pullView.selectedTitles.count);
    [ud setObject:self.pullView.unSelectedTitles forKey:@"unSelectedTitles"];
    [ud synchronize];

    
}


@end
