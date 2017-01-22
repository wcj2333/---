//
//  SetUserInfoTableViewController.m
//  项目--资讯
//
//  Created by tarena on 16/8/29.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "SetUserInfoTableViewController.h"
#import "CurrentBmobUser.h"
#import "QRadioButton.h"

@interface SetUserInfoTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,QRadioButtonDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usernameLB;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIImageView *bgIV;
@property (weak, nonatomic) IBOutlet UILabel *genderLB;
@property (weak, nonatomic) IBOutlet UILabel *birthLB;
@property (nonatomic) NSInteger row;
@property (nonatomic) QRadioButton *radioBtn;
@property (nonatomic) NSArray *radioBtns;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *cellLbs;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *cells;



@end

@implementation SetUserInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    for (UILabel *lb in self.cellLbs) {
        lb.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    }
    for (UITableViewCell *cell in self.cells) {
        cell.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
    }

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    BmobUser *user = [BmobUser currentUser];
    CurrentBmobUser *userObj = [[CurrentBmobUser alloc]initWithBmobUser:user];
    if (user) {
        self.usernameLB.text = userObj.userName;
        if (!userObj.headIVName) {
            self.headIV.hidden = YES;
        }else{
            self.headIV.hidden = NO;
            [self.headIV sd_setImageWithURL:userObj.headIVName];
        }
        self.nickName.text = userObj.nick;
        if (!userObj.bgIVName) {
            self.bgIV.hidden = YES;
        }else{
            self.bgIV.hidden = NO;
            [self.bgIV sd_setImageWithURL:userObj.bgIVName];
        }
        self.genderLB.text = userObj.gender;
        self.birthLB.text = userObj.birthday;
    }
    self.tableView.dk_separatorColorPicker = DKColorPickerWithKey(SEP);
}


//设置头部标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"基础信息";
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return NO;
    }
    return YES;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BmobUser *user = [BmobUser currentUser];

    if (indexPath.row == 1||indexPath.row == 3) {
        self.row = indexPath.row;//判断是哪一个触发的
        //选择头像/背景图
        //弹出对话框 设置头像
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
        //设置按键
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //封装方法，直接调用
            [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        [actionSheet addAction:cancle];
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    if (indexPath.row == 2) {
        //更改昵称
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            if (!self.nickName.text) {
                textField.placeholder = @"请填写昵称";
            }else{
                textField.text = self.nickName.text;
            }
        }];
        UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //填写以后保存
            [user setObject:alert.textFields[0].text forKey:@"nick"];
            //更新
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    self.nickName.text = [user objectForKey:@"nick"];
                }
            }];
        }];
        UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:a1];
        [alert addAction:a2];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (indexPath.row == 4) {
        //选择性别
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择性别\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
        QRadioButton *radio1 = [[QRadioButton alloc]initWithDelegate:self groupId:@"male"];
        radio1.frame= CGRectMake(45, 40, 100, 40);
        [radio1 setTitle:@"男" forState:UIControlStateNormal];
        [radio1 setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];

        [alert.view addSubview:radio1];
        [radio1 setChecked:YES];
        
        QRadioButton*radio2 = [[QRadioButton alloc]initWithDelegate:self groupId:@"female"];
        radio2.frame= CGRectMake(45, 85, 100, 40);
        [radio2 setTitle:@"女" forState:UIControlStateNormal];
        [radio2 setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        
        [alert.view addSubview:radio2];
        
        self.radioBtns = @[radio1,radio2];
        UIAlertAction *a1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //保存
            [user setObject:self.radioBtn.titleLabel.text forKey:@"gender"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    self.genderLB.text = self.radioBtn.titleLabel.text;
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }];
        UIAlertAction *a2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:a1];
        [alert addAction:a2];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    if (indexPath.row == 5) {
        //选择生日
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        //获取存着的日期
        NSString *str = [user objectForKey:@"birthday"];
        if (str) {
            [dateFormat setDateFormat: @"yyyy-MM-dd"];
            datePicker.date = [dateFormat dateFromString:str];
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择日期\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert.view addSubview:datePicker];
        datePicker.frame = CGRectMake(-35, 70, alert.view.bounds.size.width-2*Margin, 120);
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            //实例化一个NSDateFormatter对象
            [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
            NSString *dateString = [dateFormat stringFromDate:datePicker.date];
            //获取时间 保存
            [user setObject:dateString forKey:@"birthday"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    self.birthLB.text = dateString;
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:ok];
        
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId{
    if ([groupId isEqualToString:@"male"]) {
        [radio setChecked:YES];
        [self.radioBtns[1] setChecked:NO];
    }else{
        [radio setChecked:YES];
        [self.radioBtns[0] setChecked:NO];
    }
    
    self.radioBtn = radio;
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //NSLog(@"info:%@",info);
    //从字典中取出编辑好的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //赋值
    if (self.row == 1) {//头像
        self.headIV.image = image;
        [self saveImage:image andImageType:@"headPath"];
    }else{
        [self saveImage:image andImageType:@"bgPath"];
    }
}

-(void)saveImage:(UIImage *)image andImageType:(NSString *)imageType{
    //上传图片
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    BmobUser *user = [BmobUser currentUser];
    //设置上传菊花
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"正在上传图片";
    [BmobFile filesUploadBatchWithDataArray:@[@{@"filename":@"a.jpg",@"data":imageData}] progressBlock:^(int index, float progress) {
        hud.progress = progress;
    } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
        if(isSuccessful){
            //上传成功
            [hud hideAnimated:YES];
            BmobFile *file = [array firstObject];
            [user setObject:file.url forKey:imageType];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if(isSuccessful){
                    NSLog(@"%@",[user objectForKey:imageType]);
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
    }];

}

-(void)openImagePickerController:(UIImagePickerControllerSourceType)type/* (UIImagePickerController *)pickController*/{
    //取出图片编辑器对象
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    pickerController.sourceType = type;
    //设置图片编辑器可以编辑图片
    pickerController.allowsEditing = YES;
#warning 当编辑好后，编辑器并不会将照片传过来，因此需要委托
    pickerController.delegate = self;
    //进行跳转
    [self presentViewController:pickerController animated:YES completion:nil];
}


@end
