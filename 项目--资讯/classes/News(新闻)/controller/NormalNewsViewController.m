//
//  NormalNewsViewController.m
//  项目--资讯
//
//  Created by mis on 16/9/10.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "NormalNewsViewController.h"
#import "NewsUtils.h"
#import "NormalNewsParse.h"
#import "ChooseLocationViewController.h"
#import "BmobUtils.h"
#import "CommentViewController.h"
#import "CLImageEditor.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import "ImageNewsScrollView.h"
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <MOBFoundation/MOBFoundation.h>
#import "SqliteUtils.h"
#import "Login1ViewController.h"



@interface NormalNewsViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate,UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) NormalNewsParse *parse;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic) UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITextView *commentTV;
@property (nonatomic) UIImage *commentImage;
@property (nonatomic) NSInteger index;
@property (nonatomic) NSMutableAttributedString *string;
@property (weak, nonatomic) IBOutlet UILabel *localLB;
@property (nonatomic) UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIView *userHeadView;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (nonatomic) NSMutableArray *articles;
@property (weak, nonatomic) IBOutlet UIButton *commentCountBtn;
@property (nonatomic) int commentCount;
@property (weak, nonatomic) IBOutlet UILabel *categoryLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewTop;
@property (weak, nonatomic) IBOutlet ImageNewsScrollView *imageScrollView;
@property (nonatomic) CGFloat normalCommentViewTop;


@property (nonatomic) NSURL *shareLinkUrl;


@end

@implementation NormalNewsViewController

#pragma mark life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bottomView.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
    self.commentView.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
    self.webView.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
    self.userHeadView.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
    self.nameLB.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    
    self.webView.delegate = self;
    self.normalCommentViewTop = self.bottomViewTop.constant;
    //设置加载出来的网页背景透明
    [self.webView setOpaque:NO];
    //显示图集
    //添加菊花
    if ([self.type isEqualToString: @"photoset"]) {
        self.imageScrollView.backgroundColor = [UIColor blackColor];
        self.imageScrollView.hidden = NO;
        self.userHeadView.hidden = YES;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        ImageNewsScrollView *scrollView = self.imageScrollView;
        [NewsUtils getHeadImageNewsWithPicID:self.ad_url andCompletion:^(id obj) {
            scrollView.photoNews = obj;
            hud.hidden = YES;
        }];
    }else{
        
        //不是图集
        if (self.bobj == nil) {//新闻数据
            self.userHeadView.hidden = YES;
            self.imageScrollView.hidden = YES;
            self.headViewH.constant = 0;
            //请求新闻数据
            [NewsUtils getHeadLineNewsWithDocid:self.ad_url andCompletion:^(id obj) {
                self.parse = obj;
                NSString *str = [self parseHtmlWithParse:self.parse];
                self.shareLinkUrl = self.parse.shareLink;
                [self.webView loadHTMLString:str baseURL:nil];
            }];
            
        }else{//自己发的文章
            self.imageScrollView.hidden = YES;
            self.articles = [NSMutableArray array];
            NSString *str = [self getHtmlWithParse:self.bobj];
            [self.webView loadHTMLString:str baseURL:nil];
            BmobUser *user = [self.bobj objectForKey:@"user"];
            NSString *imagePath = nil;
            if ([user objectForKey:@"headPath"]) {
                imagePath = [user objectForKey:@"headPath"];
                [self.headIV sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"头像"]];
            }else{
                self.headIV.image = [UIImage imageNamed:@"头像"];
            }
            if ([user objectForKey:@"nick"]) {//有昵称
                self.nameLB.text = [user objectForKey:@"nick"];
            }else{
                self.nameLB.text = user.username;
            }
            self.categoryLB.text = [self.bobj objectForKey:@"category"];
            
        }
                
    }
    
    
    //添加收藏按钮
    [[SqliteUtils shareManager]findAllPersons:^(id obj) {
        if (obj) {
            NSArray *newsArr = obj;
            for (HeadLineNews *news in newsArr) {
                if ([news.docid isEqualToString:self.news.docid]) {
                    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"已收藏"] style:UIBarButtonItemStylePlain target:self action:@selector(unSaveNews)];
                    break;
                }
            }
            if (![self.navigationItem.rightBarButtonItem.image isEqual:[UIImage imageNamed:@"已收藏"]]) {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"未收藏"] style:UIBarButtonItemStylePlain target:self action:@selector(saveNews)];
            }
            
        }else{
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"未收藏"] style:UIBarButtonItemStylePlain target:self action:@selector(saveNews)];
        }
        
    }];
    
    
    //创建表
    [[SqliteUtils shareManager]createTable];
    
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    self.webView.scrollView.bounces = NO;
    
    //监听键盘的弹起
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //监听评论发送成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sendActionSuccess) name:@"评论发送完成" object:nil];
    
    //发送按钮样式
    self.sendBtn.layer.cornerRadius = 5;
    self.sendBtn.layer.borderWidth = 1;
    self.sendBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.sendBtn.layer.masksToBounds = YES;
    
    //文本框样式
    self.commentTV.layer.cornerRadius = 5;
    self.commentTV.layer.borderColor = [UIColor grayColor].CGColor;
    self.commentTV.layer.borderWidth = 1;
    self.commentTV.layer.masksToBounds = YES;
    self.commentTV.dk_textColorPicker = DKColorPickerWithKey(TEXT);
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.commentImage) {//有图片
        //成为第一响应者
        [self.commentTV becomeFirstResponder];
        
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

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark method
//收藏网页
-(void)saveNews{
    //self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"已收藏"];
    //保存该网页信息
    //添加到数据库中
    [[SqliteUtils shareManager]savaPersonWithPerson:self.news];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"已收藏"] style:UIBarButtonItemStylePlain target:self action:@selector(unSaveNews)];
    
}
//取消收藏
-(void)unSaveNews{
    //self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"未收藏"];
    //从数据库中删除
    [[SqliteUtils shareManager]removeWithPerson:self.news];
    [[SqliteUtils shareManager]findAllPersons:^(id obj) {
        NSArray *arr = obj;
        NSLog(@"%ld",arr.count);
        //删除完以后
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"未收藏"] style:UIBarButtonItemStylePlain target:self action:@selector(saveNews)];
    }];
    
}

-(NSString *)getHtmlWithParse:(BmobObject *)parse{
    NSString *contentStr = [NSString stringWithFormat:@"<html><body><span style=\"font-size:20px;\"><B>%@</B></span><HR width=%f size=1px color=#CFCFCF SIZE=10/><p><font color=\"gray\">%@</font></p><p>%@</p></body></html>",[parse objectForKey:@"title"],MainScreenW-2*Margin,[self createTime:parse.createdAt],[parse objectForKey:@"content"]];
    return contentStr;
}
-(NSString *)createTime:(NSDate *)date{
    //得到发送的Date对象
    NSDate *createDate = date;
    NSDateFormatter *f = [NSDateFormatter new];
    f.dateFormat = @"yyyy年MM月dd日 HH:mm";
    return [f stringFromDate:createDate];
    
    
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
            [BmobUtils saveCommentDatasAndNewsURL:self.ad_url andContent:nil andImage:self.commentImage andNewsAlbum:self.news.imgsrc];
        }else{
            //保存
            [BmobUtils saveCommentDatasAndNewsURL:self.ad_url andContent:self.commentTV.attributedText.string andImage:self.commentImage andNewsAlbum:self.news.imgsrc];
        }
    }else{
        [BmobUtils saveCommentDatasAndNewsURL:self.ad_url andContent:self.commentTV.attributedText.string andImage:self.commentImage andNewsAlbum:self.news.imgsrc];
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
    //如果没登录 先登录
    if (![BmobUser currentUser]) {
        Login1ViewController *vc = [Login1ViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.commentTV becomeFirstResponder];
    }
    
}

-(void)keyboardChangeFrame:(NSNotification *)noti{
    
    if (self.bgView == nil) {
        self.bgView = [[UIView alloc]initWithFrame:self.webView.bounds];
    }
    
    CGRect keyboardFrame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    float keyboardH = keyboardFrame.size.height;
    if (keyboardFrame.origin.y == MainScreenH) {//没弹
        [self.bgView removeFromSuperview];
        self.bottomViewTop.constant = self.normalCommentViewTop;
        
    }else{
        
        self.bgView.backgroundColor = [UIColor blackColor];
        self.bgView.alpha = 0.5;
        [self.webView addSubview:self.bgView];
        
        self.bottomViewTop.constant = self.normalCommentViewTop-self.commentView.frame.size.height-keyboardH;
        
        
    }
    float duration = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(NSString *)parseHtmlWithParse:(NormalNewsParse *)parse{
    
    NSString *contentStr = [NSString stringWithFormat:@"<html><body><span style=\"font-family:%@;font-size:20px;\"><B>%@</B></span><p><span style=\"font-family:%@;font-size:12px;color:gray;\">%@%@</span></p><span style=\"font-family:%@;color:%@;\">%@</span></body></html>",self.fontStyle,parse.title,self.fontStyle,parse.source,parse.ptime,self.fontStyle,DKColorPickerWithKey(TEXT),parse.body];
    
    NSArray *images = parse.img;
    for (int i = 0; i<parse.img.count; i++) {
        NSDictionary *imgDic = images[i];
        float width = self.view.bounds.size.width-16;
        float widthSize = [[imgDic[@"pixel"] componentsSeparatedByString:@"*"][0] floatValue];
        float height = [[imgDic[@"pixel"] componentsSeparatedByString:@"*"][1] floatValue];
        NSString *imgSrc = [NSString stringWithFormat:@"<img src=\"%@\" width=\"%f\" height= \"%f\" />",imgDic[@"src"],width,width*height/widthSize];
        contentStr = [contentStr stringByReplacingOccurrencesOfString:imgDic[@"ref"] withString:imgSrc];
    }
    return contentStr;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


/*---------------分享------------------*/
- (IBAction)shareNews:(id)sender {
    
}

#pragma mark UIWebView delegate
-(void) webViewDidFinishLoad:(UIWebView *)webView{
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.body.style.backgroundColor = 'rgba(0,0,0,0)'"];
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

- (void)imageEditor:(CLImageEditor *)editor willDismissWithImageView:(UIImageView *)imageView canceled:(BOOL)canceled
{
    //[self refreshImageView];
}


@end
