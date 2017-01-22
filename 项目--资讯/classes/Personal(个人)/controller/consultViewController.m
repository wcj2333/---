//
//  consultViewController.m
//  项目--资讯
//
//  Created by 王陈洁 on 17/1/22.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import "consultViewController.h"
#import "CLImageEditor.h"
#import "BmobUtils.h"
#define chooseImageViewW (MainScreenW-4*10)/3

@interface consultViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate>

@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (nonatomic) UIButton *addButton;
@property (nonatomic) NSMutableArray *chooseImages;

@end

@implementation consultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.chooseImages = [NSMutableArray array];
    self.consultTextView.layer.borderColor = [UIColor blackColor].CGColor;
    self.consultTextView.layer.borderWidth = 1;
    self.phoneTextField.layer.borderWidth = 1;
    self.phoneTextField.layer.borderColor = [UIColor blackColor].CGColor;
    self.nameTextField.layer.borderColor = [UIColor blackColor].CGColor;
    self.nameTextField.layer.borderWidth = 1;
    
    self.submitButton.layer.cornerRadius = 5;
    self.submitButton.layer.masksToBounds = YES;
    
    self.addButton = [[UIButton alloc]init];
    [self.addButton addTarget:self action:@selector(chooseImagesAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.addButton setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [self.chooseView addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(0);
        make.width.equalTo(chooseImageViewW);
    }];
    [self.chooseImages insertObject:self.addButton atIndex:0];
    
}

- (IBAction)submitAction:(id)sender {
    if ([self.consultTextView.text isEqualToString:@""]||[self.phoneTextField.text isEqualToString:@""]||[self.nameTextField.text isEqualToString:@""]) {//如果有一个为空
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请完善资料" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *a = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:a];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        if ([BaseNewsUtils isMobile:self.phoneTextField.text] == NO) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号不正确" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *a = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:a];
            [self presentViewController:alert animated:YES completion:nil];
        }else{//提交意见反馈
            if (self.chooseImages.count>1) {
                [self.chooseImages removeLastObject];
                [BmobUtils saveConsultWithContent:self.consultTextView.text andName:self.nameTextField.text andPhone:self.phoneTextField.text andImages:self.chooseImages andCallBack:^(id obj) {
                    if ([obj isEqualToString:@"成功"]) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [BaseNewsUtils toastview:@"发送失败"];
                    }
                }];
                
            }else{
                [BmobUtils saveConsultWithContent:self.consultTextView.text andName:self.nameTextField.text andPhone:self.phoneTextField.text andImages:nil andCallBack:^(id obj) {
                    if ([obj isEqualToString:@"成功"]) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        [BaseNewsUtils toastview:@"发送失败"];
                    }
                }];

            }
        }
    }
    
}
-(void)deleteAction:(UIButton *)sender{
    UIImageView *iv = (UIImageView *)sender.superview;
    [self.chooseImages removeObject:iv];
    [iv removeFromSuperview];
    for (int i = 0; i<self.chooseImages.count; i++) {
        UIView *view = self.chooseImages[i];
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo((chooseImageViewW+10)*i);
            make.top.bottom.equalTo(0);
            make.width.equalTo(chooseImageViewW);
        }];
    }
    
}

- (void)chooseImagesAction:(UIButton *)sender {
    [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}
//打开
-(void)openImagePickerController:(UIImagePickerControllerSourceType)sourceType{
    //取出图片编辑器对象
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]init];
    pickerController.sourceType = sourceType;
    //设置图片编辑器可以编辑图片
    pickerController.allowsEditing = NO;
    pickerController.delegate = self;
    //进行跳转
    [self presentViewController:pickerController animated:YES completion:nil];
}
#pragma mark UIImagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
    editor.delegate = self;
    
    [picker pushViewController:editor animated:YES];
    
}

#pragma mark- CLImageEditor delegate
- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image{
    UIImageView *iv = [[UIImageView alloc]init];
    iv.image = image;
    iv.userInteractionEnabled = YES;
    [self.chooseView addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(0);
        make.width.equalTo(chooseImageViewW);
    }];
    //图片上面添加删除键
    UIButton *deleteButton = [[UIButton alloc]init];
    [deleteButton setTitle:@"x" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [iv addSubview:deleteButton];
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(3);
        make.right.equalTo(-3);
        make.width.height.equalTo(15);
    }];
    
    [self.chooseImages insertObject:iv atIndex:0];
    for (int i = 0; i<self.chooseImages.count; i++) {
        UIView *view = self.chooseImages[i];
        if (i > 0) {
            [view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo((chooseImageViewW+10)*i);
                make.top.bottom.equalTo(0);
                make.width.equalTo(chooseImageViewW);
            }];
        }
    }
    
    [editor dismissViewControllerAnimated:YES completion:nil];
}




@end
