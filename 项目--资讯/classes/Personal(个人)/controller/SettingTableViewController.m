//
//  SettingTableViewController.m
//  项目--资讯
//
//  Created by tarena on 16/8/29.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "SettingTableViewController.h"
#import "ChangePwdViewController.h"
#import "SetUserInfoTableViewController.h"
#import "AboutSystemViewController.h"
#import "AboutSystemViewController.h"

@interface SettingTableViewController ()

@property (nonatomic) NSArray *dataArr;
@property (nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;


@end

@implementation SettingTableViewController

- (IBAction)logoutBtn:(id)sender {
    [BmobUser logout];
    //回到前一个页面即可
    _callBack(@"logout");
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.tableView.tableFooterView.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    [self.logoutBtn dk_setTitleColorPicker:DKColorPickerWithKey(TEXT) forState:UIControlStateNormal];
    self.logoutBtn.layer.cornerRadius = 5;
    self.logoutBtn.layer.borderWidth = 1;
    self.logoutBtn.layer.borderColor = [UIColor whiteColor].CGColor;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    NSArray *arr = self.dataArr[indexPath.section];
    cell.textLabel.text = arr[indexPath.row];
    cell.dk_backgroundColorPicker = DKColorPickerWithRGB(0xffffff, 0x343434, 0xfafafa);
    cell.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    if (indexPath.section == 1&&indexPath.row == 0) {
        //清理缓存处 添加详细的缓存信息
        [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
            NSString *message = [NSString stringWithFormat:@"%.2fM",totalSize/1024.0/1024];
            cell.detailTextLabel.text = message;
        }];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//个人信息
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"userInfo" bundle:[NSBundle mainBundle]];
            SetUserInfoTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SetUserInfoTableViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {
            //账号与密码设置
            //弹出框
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"账号与密码" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"修改密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //修改密码
                [self dismissViewControllerAnimated:YES completion:nil];
                ChangePwdViewController *vc = [ChangePwdViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:a1];
            [alert addAction:a2];
            [self presentViewController:alert animated:YES completion:nil];

        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
                NSString *message = [NSString stringWithFormat:@"您确认清除%.2fM缓存吗？",totalSize/1024.0/1024];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //清除内存缓存
                    [[SDImageCache sharedImageCache]clearMemory];
                    //清除磁盘缓存(SD卡里了)
                    [[SDImageCache sharedImageCache]clearDisk];
                    [self.tableView reloadData];
                    
                }];
                UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:a1];
                [alert addAction:a2];
                
                [self presentViewController:alert animated:YES completion:nil];
            }];

        }else{
            AboutSystemViewController *vc = [[AboutSystemViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    //修改字体
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"改变字体" object:@{@"font":@"stkaiti"}];
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"账号设置";
    }else{
        return @"系统设置";
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}



#pragma mark - 懒加载 Lazy Load
- (NSArray *)dataArr {
	if(_dataArr == nil) {
        NSArray *d1 = @[@"个人信息",@"账号与密码",@"切换账号"];
        NSArray *d2 = @[@"清理缓存",@"关于"];
        
		_dataArr = @[d1,d2];
	}
	return _dataArr;
}

@end
