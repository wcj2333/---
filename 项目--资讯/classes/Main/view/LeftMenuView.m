//
//  LeftMenuView.m
//  StoreManager
//
//  Created by 王陈洁 on 16/10/17.
//  Copyright © 2016年 hare. All rights reserved.
//

#import "LeftMenuView.h"
#import "MainTabBarController.h"

#define kThemeColor [UIColor redColor]


@implementation LeftMenuView

-(instancetype)init{
    self=[super init];
    if (self) {
        
        self.dk_backgroundColorPicker = DKColorPickerWithKey(WB);
        
        //初始化数组
        self.buttons = [NSMutableArray array];
        self.titles = [NSMutableArray array];
        
    }
    return self;
}

#pragma mark method
-(void)setMenus:(NSArray *)menus{
    _menus = menus;
    //每个button
    for (int i = 0; i<self.menus.count; i++) {
        //按钮
        UIButton *btn = [[UIButton alloc]init];
    
        [self addSubview:btn];
        btn.tag = i+1;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat margin = ([UIScreen mainScreen].bounds.size.width-self.menus.count*40)/(self.menus.count+1);
        if (i == self.menus.count/2) {
            //单独一个按钮
            [btn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(0);
                make.centerX.equalTo(0);
                make.height.width.equalTo(40);
            }];
            continue;
        }
        
        [btn setImage:[UIImage imageNamed:self.menus[i]] forState:UIControlStateNormal];
        //选中按钮时
        NSString *imageName = [NSString stringWithFormat:@"%@_hl",self.menus[i]];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.width.equalTo(40);
            make.height.equalTo(35);
            make.left.equalTo(margin*(i+1)+40*i);
        }];
        //添加进数组
        [self.buttons addObject:btn];
        
        //标签
        UILabel *titleLb = [[UILabel alloc]init];
        titleLb.font = [UIFont systemFontOfSize:10];
        titleLb.textColor = [UIColor grayColor];
        [self addSubview:titleLb];
        titleLb.tag = i+self.menus.count;
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.text = self.menus[i];
        [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_bottom).equalTo(0);
            make.width.equalTo(40);
            make.height.equalTo(15);
            make.left.equalTo(margin*(i+1)+40*i);
        }];
        
        //添加进数组
        [self.titles addObject:titleLb];
        
        //默认选中第一个
        if (i == 0) {
            [btn setSelected:YES];
            titleLb.textColor = kThemeColor;
        }

    }
    

}

-(void)clickBtn:(UIButton *)sender{
    //让tabBar跳转到某个控制器中
    MainTabBarController *tabBar = (MainTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if (sender.tag-1 == self.menus.count/2) {
        [self.leftMenuViewDelegate sendArticle];
        return;
    }else if (sender.tag-1 > self.menus.count/2){
        tabBar.selectedIndex = sender.tag-2;
    }else{
        tabBar.selectedIndex = sender.tag-1;
    }
    
    //点中效果
    UILabel *selectLB = (UILabel *)[self viewWithTag:sender.tag-1+self.menus.count];
    selectLB.textColor = [UIColor redColor];
    //选中按钮时
    [sender setSelected:YES];
    NSString *imageName = [NSString stringWithFormat:@"%@_hl",self.menus[sender.tag-1]];
    [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
    
    //其他取消选中状态
    for (UILabel *lb in self.titles) {
        if ([lb isEqual:selectLB]) {
            continue;
        }else{
            lb.textColor = [UIColor grayColor];
        }
    }
    
    for (UIButton *btn in self.buttons) {
        if ([btn isEqual:sender]) {
            continue;
        }else{
            [btn setSelected:NO];
        }
    }
}

@end
