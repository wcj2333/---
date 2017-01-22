//
//  CommentViewController.m
//  项目--资讯
//
//  Created by mis on 16/9/16.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "CommentViewController.h"
#import "ChooseLocationViewController.h"
#import "BmobUtils.h"
#import "CommentCell.h"
#import "BmobModel.h"
#import "CLImageEditor.h"
#import "Login1ViewController.h"

@interface CommentViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITextView *commentTV;
@property (nonatomic) UIImage *commentImage;
@property (nonatomic) NSInteger index;
@property (nonatomic) NSMutableAttributedString *string;
@property (weak, nonatomic) IBOutlet UILabel *localLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewTop;
@property (nonatomic) CGFloat normalCommentViewTop;
@property (nonatomic) NSMutableArray *comments;
@property (nonatomic) UIButton *deleteBtn;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.title = @"评论";
    
    self.normalCommentViewTop = self.commentViewTop.constant;
    //监听键盘的弹起
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    //监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendActionSuccess) name:@"评论发送完成" object:nil];
    
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
    
    [self searchComments];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark method
-(void)searchComments{
    //查询已有评论
    [BmobUtils searchCommentWithNewsURL:self.source andIsIncludeCurrentUser:NO andCallBack:^(id obj) {
        NSArray *arr = obj;
        self.comments = [NSMutableArray array];
        for (BmobObject *obj in arr) {
            BmobModel *model = [[BmobModel alloc]initWithObj:obj];
            [self.comments addObject:model];
        }
        
        [self.tableView reloadData];
    }];

}

-(void)sendActionSuccess{
    //评论发送完成 重新查询
    [self searchComments];
    //清空textView中所有的东西
    self.commentTV.text = @"";
    self.commentImage = nil;
    [self.deleteBtn removeFromSuperview];
    
}
-(void)keyboardChangeFrame:(NSNotification *)noti{
    if (self.bgView == nil) {
        self.bgView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        self.bgView.userInteractionEnabled = YES;
    }
    
    CGRect keyboardFrame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    float keyboardH = keyboardFrame.size.height;
    if (keyboardFrame.origin.y == MainScreenH) {//没弹
        self.commentViewTop.constant = self.normalCommentViewTop;
        [self.bgView removeFromSuperview];
        
    }else{
        
        self.bgView.backgroundColor = [UIColor blackColor];
        self.bgView.alpha = 0.5;
        [self.tableView addSubview:self.bgView];
        self.commentViewTop.constant = self.normalCommentViewTop-self.commentView.frame.size.height-keyboardH;
    }
    
    float duration = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];

}
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

//发送评论
- (IBAction)sendAction:(id)sender {
    //发送评论
    [self.view endEditing:YES];
    if (self.commentImage) {//存在
        if (self.commentTV.attributedText.string.length-1 == 0) {
            //只有图片没有文字
            //保存
            [BmobUtils saveCommentDatasAndNewsURL:self.source andContent:nil andImage:self.commentImage andNewsAlbum:self.headNews.imgsrc];
        }else{
            //保存
            [BmobUtils saveCommentDatasAndNewsURL:self.source andContent:self.commentTV.attributedText.string andImage:self.commentImage andNewsAlbum:self.headNews.imgsrc];
        }
    }else{
        [BmobUtils saveCommentDatasAndNewsURL:self.source andContent:self.commentTV.attributedText.string andImage:self.commentImage andNewsAlbum:self.headNews.imgsrc];
    }
}


- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)CommentAction:(UIButton *)sender {
    if ([BmobUser currentUser]) {
        [self.commentTV becomeFirstResponder];
        //成为第一响应者 弹出键盘
    }else{
        Login1ViewController *vc = [Login1ViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark UITableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.model = self.comments[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BmobModel *model = self.comments[indexPath.row];
    
    return model.cellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击某一行 进行回复或点赞
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
