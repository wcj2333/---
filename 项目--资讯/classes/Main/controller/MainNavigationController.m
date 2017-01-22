//
//  MainNavigationController.m
//  项目--资讯
//
//  Created by tarena on 16/8/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "MainNavigationController.h"
#import "LLSlideMenu.h"
#import "XFPublishView.h"
#import "SendArticleViewController.h"
#import "Login1ViewController.h"


@interface MainNavigationController ()<XFPublishViewDelegate>

@property (nonatomic) LLSlideMenu *menu;


@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //右边按钮
    if (self.viewControllers.count == 1) {
        //self.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];

    }
    self.topViewController.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithKey(BG);
    
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
}

//-(void)addAction{
//    XFPublishView *publishView = [[XFPublishView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    publishView.delegate = self;
//    [publishView show ];
//    
//}

-(void)didSelectBtnWithBtnTag:(NSInteger)tag
{
    if (tag==2)
    {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSInteger i = [ud integerForKey:@"index"];
        if (i%2 != 0) {//日间模式
            self.dk_manager.themeVersion = DKThemeVersionNormal;
        }else{//夜间模式
            self.dk_manager.themeVersion = DKThemeVersionNight;
        }
        i++;
        [ud setInteger:i forKey:@"index"];
        [ud synchronize];
        }
    if (tag == 1) {//发表文字
        if ([BmobUser currentUser]) {
            SendArticleViewController *vc = [SendArticleViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self pushViewController:vc animated:YES];
        }else{
            Login1ViewController *vc = [Login1ViewController new];
            [self pushViewController:vc animated:YES];
        }
        
    }
}


@end
