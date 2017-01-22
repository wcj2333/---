//
//  ImageNewsDetailViewController.m
//  项目--资讯
//
//  Created by mis on 16/9/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ImageNewsDetailViewController.h"
#import "NewsUtils.h"
#import "HeadImgeNews.h"
#import "ImageNewsScrollView.h"
#import "NormalNewsParse.h"
#import "BmobUtils.h"
#import "CommentViewController.h"
#import "ChooseLocationViewController.h"
#import "CLImageEditor.h"

@interface ImageNewsDetailViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate>

@property (nonatomic) NSArray *photoNews;
@property (weak, nonatomic) IBOutlet ImageNewsScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITextView *commentTV;
@property (nonatomic) UIImage *commentImage;
@property (weak, nonatomic) IBOutlet UILabel *localLB;
@property (nonatomic) UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentCountBtn;
@property (nonatomic) NSMutableAttributedString *string;
@property (nonatomic) NSMutableArray *articles;


@end

@implementation ImageNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor blackColor];
    //添加菊花
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    ImageNewsScrollView *scrollView = self.scrollView;
    if ([self.type isEqualToString: @"photoset"]) {
        [NewsUtils getHeadImageNewsWithPicID:self.ad_url andCompletion:^(id obj) {
            scrollView.photoNews = obj;
            hud.hidden = YES;
        }];
    }
    
    
    //监听键盘的弹起
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //监听评论发送成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendActionSuccess) name:@"评论发送完成" object:nil];
    
    //发送按钮样式
    self.sendBtn.layer.cornerRadius = 5;
    self.sendBtn.layer.borderWidth = 1;
    self.sendBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.sendBtn.layer.masksToBounds = YES;
    
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.commentImage) {//有图片
        //成为第一响应者
        [self.commentTV becomeFirstResponder];
        //同时添加一个删除按钮
        UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 10, 10)];
        [self.commentTV addSubview:deleteBtn];
        self.deleteBtn = deleteBtn;
        [deleteBtn setTitle:@"x" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        deleteBtn.backgroundColor = [UIColor whiteColor];
        [deleteBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.layer.cornerRadius = 5;
        deleteBtn.layer.masksToBounds = YES;
    }
    //获取选择好的地理位置
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud floatForKey:@"lon"] == 0 && [ud floatForKey:@"lat"] == 0) {
        self.localLB.text = @"";
    }else{
        self.localLB.text = [NSString stringWithFormat:@"%f,%f",[ud floatForKey:@"lon"],[ud floatForKey:@"lat"]];
    }
    
    //请求一下数据
    [BmobUtils searchCommentWithNewsURL:self.ad_url andIsIncludeCurrentUser:NO andCallBack:^(id obj) {
        NSArray *arr = obj;
        if (arr.count>0) {
            [self.commentCountBtn setTitle:[NSString stringWithFormat:@"%ld评论",arr.count] forState:UIControlStateNormal];
            
        }else{
            [self.commentCountBtn setTitle:@"0评论" forState:UIControlStateNormal];
        }
        
        
    }];
    
    
}


#pragma mark method
-(void)deleteImage:(UIButton *)sender{
    NSString *text = self.commentTV.text;
    //删除图片
    NSRange range = {0,1};
    [self.string deleteCharactersInRange:range];
    self.commentImage = nil;
    self.commentTV.attributedText = self.string;
    self.commentTV.text = text;
    [sender removeFromSuperview];
    
    
}

-(void)sendActionSuccess{
    //清空textView中所有的东西
    self.commentTV.text = @"";
    self.commentImage = nil;
    [self.deleteBtn removeFromSuperview];
    //请求一下数据
    [BmobUtils searchCommentWithNewsURL:self.ad_url andIsIncludeCurrentUser:NO andCallBack:^(id obj) {
        NSArray *arr = obj;
        if (arr.count>0) {
            [self.commentCountBtn setTitle:[NSString stringWithFormat:@"%ld评论",arr.count] forState:UIControlStateNormal];
            
        }else{
            [self.commentCountBtn setTitle:@"0评论" forState:UIControlStateNormal];
        }
        
        
    }];
    
    
}

- (IBAction)clickCommentBtn:(id)sender {
    //查看评论
    CommentViewController *vc = [CommentViewController new];
    vc.source = self.ad_url;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)clickIconAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1://点击照相机
            [self openImagePickerController:UIImagePickerControllerSourceTypeCamera];
            break;
        case 2://点击图片
            [self openImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        case 3://点击位置
        {
            ChooseLocationViewController *vc = [ChooseLocationViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
            
    }
    
}
- (IBAction)sendAction:(id)sender {
    //发送评论
    [self.view endEditing:YES];
    
    if (self.commentImage) {//存在
        if (self.commentTV.attributedText.string.length-1 == 0) {
            //只有图片没有文字
            //保存
            [BmobUtils saveCommentDatasAndNewsURL:self.ad_url andContent:nil andImage:self.commentImage andNewsAlbum:nil];
        }else{
            //保存
            [BmobUtils saveCommentDatasAndNewsURL:self.ad_url andContent:self.commentTV.attributedText.string andImage:self.commentImage andNewsAlbum:nil];
        }
    }else{
        [BmobUtils saveCommentDatasAndNewsURL:self.ad_url andContent:self.commentTV.attributedText.string andImage:self.commentImage andNewsAlbum:nil];
    }
    
    
    
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



- (IBAction)commentAction:(id)sender {
    [self.commentTV becomeFirstResponder];
}

-(void)keyboardChangeFrame:(NSNotification *)noti{
    CGRect keyboardFrame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    float keyboardH = keyboardFrame.size.height;
    if (keyboardFrame.origin.y == MainScreenH) {//没弹
        self.bottomViewH.constant += self.bottomView.frame.size.height+keyboardH;
        
        
    }else{
        
        self.bottomViewH.constant = self.bottomViewH.constant-self.bottomView.frame.size.height-keyboardH;
    }
}

#pragma mark UIImagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
    editor.delegate = self;
    
    [picker pushViewController:editor animated:YES];
    
}

#pragma mark- CLImageEditor delegate
- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    
    self.string = [[NSMutableAttributedString alloc] initWithAttributedString:self.commentTV.attributedText];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
    textAttachment.image = image; //要添加的图片
    // 设置图片大小
    textAttachment.bounds = CGRectMake(0, 0, 40, 40);
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    NSRange range = {0,1};
    if (self.commentImage) {
        [self.string deleteCharactersInRange:range];
    }
    
    [self.string insertAttributedString:textAttachmentString atIndex:0];//index为用户指定要插入图片的位置
    self.commentTV.attributedText = self.string;
    self.commentImage = image;
    
    
    [editor dismissViewControllerAnimated:YES completion:nil];
}



@end
