//
//  PersonalTableViewController.m
//  项目--资讯
//
//  Created by tarena on 16/8/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "PersonalTableViewController.h"
#import "LoginViewController.h"
#import "SetUserInfoTableViewController.h"
#import "CurrentBmobUser.h"
#import "ModeCell.h"
#import "SettingTableViewController.h"
#import "SingleDayAndNight.h"
#import "Login1ViewController.h"
#import "SaveTableViewController.h"
#import "AppDelegate.h"
#import "TalksTableViewController.h"
#import "BmobUtils.h"
#import "MyCommentViewController.h"
#import "BmobModel.h"
#import <BmobSDK/Bmob.h>
#import "consultViewController.h"

@interface PersonalTableViewController ()<ModeCellDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userBgIv;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UIButton *userNameBtn;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (nonatomic) NSArray *contentArr;
@property (nonatomic) NSString *countTime;

@end

@implementation PersonalTableViewController

#pragma mark - 生命周期 life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"ModeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ModeCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UserCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"OtherCell"];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(BAR);
    
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.currentTime = [BaseNewsUtils getSystemCurrentTime]-delegate.currentTime;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"addUpTime"]) {
        NSNumber *timeNum = [[NSUserDefaults standardUserDefaults]objectForKey:@"addUpTime"];
        self.currentTime += timeNum.longValue;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addUpTime:) userInfo:nil repeats:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //获取当下登录的用户
    BmobUser *user = [BmobUser currentUser];
    CurrentBmobUser *userObj = [[CurrentBmobUser alloc]initWithBmobUser:user];
    if (user) {//登录了
        if (userObj.nick) {
            [self.userNameBtn setTitle:userObj.nick forState:UIControlStateNormal];
            
        }else{
            [self.userNameBtn setTitle:user.username forState:UIControlStateNormal];
        }
        [self.headIV sd_setImageWithURL:userObj.headIVName placeholderImage:[UIImage imageNamed:@"头像"]];
        self.headIV.layer.cornerRadius = 20;
        [self.userBgIv sd_setImageWithURL:userObj.bgIVName];
        //红色背景
        self.redView.backgroundColor = [UIColor clearColor];
    }else{
        [self.userNameBtn setTitle:@"点击登录" forState:UIControlStateNormal];
        self.redView.backgroundColor = [UIColor redColor];
    }
    
}

#pragma mark - 方法 methods
-(void)setIsActiveTimer:(NSString *)isActiveTimer{
    _isActiveTimer = isActiveTimer;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addUpTime:) userInfo:nil repeats:YES];
}
-(void)addUpTime:(NSTimer *)timer{
    self.currentTime += 1000;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.textLabel.text = [NSString stringWithFormat:@"当前累计时间为：%d:%.2d:%.2d",(int)self.currentTime/1000/3600,(int)self.currentTime/1000/60,(int)self.currentTime/1000%60];
}
-(void)clickIV{
    BmobUser *user = [BmobUser currentUser];
    if (user) {//登录了
        [self setUserInfo];
    }else{
        //没有登录 跳到登录页面
        Login1ViewController *vc = [Login1ViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//点击头像
- (IBAction)tapHeadIV:(id)sender {
    [self clickIV];
}
//点击背景
- (IBAction)tapBgIV:(id)sender {
    [self clickIV];
}

- (IBAction)loginBtn:(id)sender {
    if ([BmobUser currentUser]) {
        [self setUserInfo];
        
    }else{
        //登录
        //LoginViewController *vc = [LoginViewController new];
        Login1ViewController *vc = [Login1ViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
//转到设置个人页面
-(void)setUserInfo{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"userInfo" bundle:[NSBundle mainBundle]];
    SetUserInfoTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SetUserInfoTableViewController"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 5;
    }else{
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //模式设置
            ModeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModeCell" forIndexPath:indexPath];
            cell.modeCellDelegate = self;
            cell.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
            cell.dk_textColorPicker = DKColorPickerWithKey(TEXT);
            
            return cell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell"];
            if (indexPath.row == 1) {
                cell.textLabel.text = [NSString stringWithFormat:@"当前累计时间为：%d:%.2d:%.2d",(int)self.currentTime/1000/3600,(int)self.currentTime/1000/60,(int)self.currentTime/1000%60];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }else{
                cell.textLabel.text = self.contentArr[indexPath.row-1];
                [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
            }
            cell.imageView.image = [UIImage imageNamed:self.contentArr[indexPath.row-1]];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
            cell.dk_textColorPicker = DKColorPickerWithKey(TEXT);
            
            return cell;
        }
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OtherCell"];
        cell.textLabel.text = self.contentArr[indexPath.row+4];
        cell.imageView.image = [UIImage imageNamed:self.contentArr[indexPath.row+4]];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
        cell.dk_textColorPicker = DKColorPickerWithKey(TEXT);
        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //点击设置
            SettingTableViewController *vc = [SettingTableViewController new];
            vc.callBack = ^(id obj){
                //退出登录后返回 清空头像和背景图
                [self.userNameBtn setTitle:@"点击登录" forState:UIControlStateNormal];
                self.redView.backgroundColor = [UIColor redColor];
                self.headIV.image = [UIImage imageNamed:@"头像"];
                self.userBgIv.image = nil;
            };
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            consultViewController *vc = [[consultViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {//发表的文章
            TalksTableViewController *vc = [[TalksTableViewController alloc]init];
            vc.isIncludeCurrentUser = YES;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 3) {
            //显示收藏
            SaveTableViewController *vc = [SaveTableViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 4) {//我的评论
            MyCommentViewController *vc = [[MyCommentViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 12;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(void)chooseModeWithButton:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"夜间模式"]) {
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
        
    }else{//离线阅读
        
    }
}

#pragma mark - 懒加载 Lazy Load
- (NSArray *)contentArr {
    if(_contentArr == nil) {
        _contentArr = @[@"我的阅读",
                        @"我的文章",
                        @"我的收藏",
                        @"我的评论",
                        @"设置",
                        @"意见反馈"
                        ];
    }
    return _contentArr;
}

@end
