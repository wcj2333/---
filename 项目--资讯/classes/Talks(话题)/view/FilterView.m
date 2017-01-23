//
//  FilterView.m
//  项目--资讯
//
//  Created by 王陈洁 on 17/1/23.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import "FilterView.h"

@implementation FilterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        
        self.filterButton = [[UIButton alloc]init];
        self.filterButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.filterButton dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
        [self.filterButton addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.filterButton setTitle:@"筛选" forState:UIControlStateNormal];
        [self addSubview:self.filterButton];
        [self.filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(-8);
            make.top.equalTo(8);
            make.width.equalTo(50);
        }];
        self.filterButton.layer.cornerRadius = 5;
        self.filterButton.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0].CGColor;
        self.filterButton.layer.borderWidth = 1;
    }
    return self;
}

-(void)filterAction:(UIButton *)sender{
    self.vc = [[UIViewController alloc]init];
    self.vc.preferredContentSize = CGSizeMake(100, self.categorys.count*20);
    self.vc.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *popVC = self.vc.popoverPresentationController;
    // 设置代理(iPhone必须设置代理才能显示)
    popVC.delegate = self;
    popVC.backgroundColor = [UIColor clearColor];
    popVC.sourceView = sender;
    popVC.sourceRect = sender.bounds;
    popVC.permittedArrowDirections = UIPopoverArrowDirectionUp;
    [self addDatePickerInView:self.vc.view];
    
    
    //将控制器以莫泰的方式出现
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.vc animated:YES completion:nil];
}


-(void)addDatePickerInView:(UIView *)view{
    UITableView *categoryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, view.bounds.size.width, view.bounds.size.height) style:UITableViewStyleGrouped];
    categoryTableView.bounces = NO;
    categoryTableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    categoryTableView.delegate = self;
    categoryTableView.dataSource = self;
    [view addSubview:categoryTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.categorys.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
        cell.dk_textColorPicker = DKColorPickerWithKey(TEXT);

    }
    cell.textLabel.text = self.categorys[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.vc dismissViewControllerAnimated:YES completion:nil];
    [self.filterViewDelegate searchArticlesWithCategory:self.categorys[indexPath.row]];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    // 此处为不适配(如果选择其他,会自动视频屏幕,上面设置的大小就毫无意义了)
    return UIModalPresentationNone;
}

#pragma mark lazyLoad
-(NSArray *)categorys{
    if (_categorys == nil) {
        _categorys = @[@"全部",@"无分类",@"头条",@"娱乐",@"体育",@"科技",@"轻松一刻",@"军事",@"财经",@"手机",@"游戏",@"历史",@"社会",@"电影",@"电视",@"NBA",@"足球",@"旅游",@"汽车",@"房产",@"iphone限免"];
    }
    return _categorys;
}


@end
