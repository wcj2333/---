//
//  SendArticleViewController.m
//  项目--资讯
//
//  Created by mis on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "SendArticleViewController.h"
#import "HeadView.h"
#import "CLImageEditor.h"
#import "UIView+Extend.h"
#import "BmobUtils.h"
#import "CategoryViewController.h"
#import "ArticleTopView.h"

@interface SendArticleViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLImageEditorDelegate, CLImageEditorTransitionDelegate, CLImageEditorThemeDelegate,HeadViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic) HeadView *headView;
@property (nonatomic) UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *chooseBtns;
@property (nonatomic) UIImage *albumImage;
@property (nonatomic) NSMutableAttributedString *string;

@property (nonatomic,strong)NSMutableDictionary *mutImgDict;
@property (nonatomic,strong)NSMutableArray *mutImgArray;
@property (nonatomic,strong)NSMutableArray *imgArray;//最终确定照片URl数组
@property (nonatomic) CGSize imageSize;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;

@property (nonatomic) NSString *openImagePicker;


@end

@implementation SendArticleViewController

#pragma mark life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    ArticleTopView *topView = [[ArticleTopView alloc]initWithFrame:CGRectMake(0, 20, MainScreenW, MainScreenH-20)];
    [topView.cancleButton addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView.sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:topView];
    
    //添加头部视图
    self.headView = [[NSBundle mainBundle]loadNibNamed:@"HeadView" owner:self options:nil][0];
    self.headView.headViewDelegate = self;
    self.headView.frame = CGRectMake(0, 64, MainScreenW, 100);
    [self.view addSubview:self.headView];
    
    //设置选择按钮样式
    for (UIButton *btn in self.chooseBtns) {
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.layer.masksToBounds = YES;
    }
    
    //添加内容
    self.contentTV = [[UITextView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame)+8, MainScreenW, MainScreenH-self.headView.height-8-self.bottomView.height-64)];
    [self.view addSubview:self.contentTV];
    [self.view sendSubviewToBack:self.bottomView];
    //self.contentTV.backgroundColor = [UIColor redColor];
    
    //监听
    //键盘弹起时 textField变短
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTextFieldH:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //self.headView.height = 100;
    self.headView.frame = CGRectMake(0, 64, MainScreenW, 100);

}

#pragma mark method
-(void)cancleAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickAction:(UIButton *)sender {
    if (sender.tag == 1) {//选择图片
        UIImagePickerController *pickerController = [UIImagePickerController new];
        pickerController.delegate = self;
        [self presentViewController:pickerController animated:YES completion:nil];
    }else{//选择分类
        CategoryViewController *vc = [CategoryViewController new];
        vc.categoryCallBack = ^(NSString *content){
            [self.categoryBtn setTitle:content forState:UIControlStateNormal];
        };
        [self presentViewController:vc animated:YES completion:nil];
    }
}

//发送
-(void)sendAction:(UIButton *)sender{
    //去掉空格
    NSString *title = [self.headView.titleTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *content = [self.contentTV.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([title isEqualToString:@""]||[content isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写标题或内容" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        __block NSString *textStr = [[self textStringWithSymbol:@"[图片]" attributeString:self.contentTV.attributedText] mutableCopy];
        

        //通过替换
        if ([textStr containsString:@"图片"]) {
            [BmobUtils parseArticleWithText:textStr andmutImgArray:self.mutImgArray andimageSize:self.imageSize andCallBack:^(id obj) {
                //进行保存
                [BmobUtils saveArticleWithTitle:self.headView.titleTF.text andContent:obj andCategory:self.categoryBtn.titleLabel.text andAlbum:self.albumImage andCallBack:^(id obj) {
                    self.albumImage = nil;
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }];
        
        
        }else{//纯文章
        
            //保存
            [BmobUtils saveArticleWithTitle:self.headView.titleTF.text andContent:textStr  andCategory:self.categoryBtn.titleLabel.text andAlbum:self.albumImage andCallBack:^(id obj) {
                self.albumImage = nil;
                [self.navigationController popViewControllerAnimated:YES];
            }];

        }

    }
    
}

- (void)changeCellHeight{
    self.headView.height = 160;
    self.contentTV.frame = CGRectMake(0, CGRectGetMaxY(self.headView.frame)+8, MainScreenW, MainScreenH-self.headView.height-8-self.bottomView.height-64);
    [self.view reloadInputViews];
}
-(void)changeTextFieldH:(NSNotification *)noti{
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float keyboardH = keyboardFrame.size.height;
    if (keyboardFrame.origin.y == MainScreenH) {
        self.contentTV.height = MainScreenH-self.headView.height-8-self.bottomView.height-64;
        NSLog(@"%f",self.headView.height);
        self.bottomView.transform = CGAffineTransformIdentity;
    }else{
        self.contentTV.height = MainScreenH-self.headView.height-8-self.bottomView.height-64-keyboardH;
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, -keyboardH);
    }
}

#pragma mark UIImagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if ([self.openImagePicker isEqualToString:@"album"]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        self.headView.albumIV.hidden = NO;
        self.headView.albumIV.image = image;
        self.albumImage = image;
        [self dismissViewControllerAnimated:YES completion:nil];
        self.openImagePicker = nil;
        
        return;
    }
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
    editor.delegate = self;
    
    [picker pushViewController:editor animated:YES];
    
}

#pragma mark- CLImageEditor delegate
- (void)imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
{
    
    self.string = [[NSMutableAttributedString alloc] initWithAttributedString:self.contentTV.attributedText];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil] ;
    textAttachment.image = image; //要添加的图片
    //获取原图片的宽高比
    float originalW = image.size.width;
    float originalH = image.size.height;
    // 设置图片大小
    textAttachment.bounds = CGRectMake(0, 0, MainScreenW-2*Margin, (MainScreenW-2*Margin)*originalH/originalW);
    self.imageSize = CGSizeMake(MainScreenW-2*Margin, (MainScreenW-2*Margin)*originalH/originalW);
    NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [self.string insertAttributedString:textAttachmentString atIndex:self.contentTV.selectedRange.location];//index为用户指定要插入图片的位置
    self.contentTV.attributedText = self.string;
    //self.albumImage = image;
    [editor dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 富文本转换操作
/** 将富文本转换为带有图片标志的纯文本*/
- (NSString *)textStringWithSymbol:(NSString *)symbol attributeString:(NSAttributedString *)attributeString{
    NSString *string = attributeString.string;
    
    string = [self stringDeleteString:@"\n" frontString:@"[图片]" inString:string];
    //最终纯文本
    NSMutableString *textString = [NSMutableString stringWithString:string];
    //替换下标的偏移量
    __block NSUInteger base = 0;
    
    //遍历
    [attributeString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributeString.length)
                                options:0
                             usingBlock:^(id value, NSRange range, BOOL *stop) {
                                 //检查类型是否是自定义NSTextAttachment类
                                 if (value && [value isKindOfClass:[NSTextAttachment class]]) {
                                     //替换
                                     [textString replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:symbol];
                                     //增加偏移量
                                     base += (symbol.length - 1);
                                     //将富文本中最终确认的照片取出来
                                     NSTextAttachment *attachmentImg = (NSTextAttachment *)value;
                                    [self.mutImgArray addObject:attachmentImg.image];
                                 }
                             }];
    return textString;
}
/** 删除字符串*/
- (NSString *)stringDeleteString:(NSString *)deleteString frontString:(NSString *)frontString inString:(NSString *)inString{
    NSArray *ranges = [self rangeOfSymbolString:frontString inString:inString];
    NSMutableString *mutableString = [inString mutableCopy];
    NSUInteger base = 0;
    for (NSString *rangeString in ranges) {
        NSRange range = NSRangeFromString(rangeString);
        [mutableString deleteCharactersInRange:NSMakeRange(range.location - deleteString.length + base, deleteString.length)];
        base -= deleteString.length;
    }
    return [mutableString copy];
}
/** 统计文本中所有图片资源标志的range*/
- (NSArray *)rangeOfSymbolString:(NSString *)symbol inString:(NSString *)string {
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSString *string1 = [string stringByAppendingString:symbol];
    NSString *temp;
    for (int i = 0; i < string.length; i ++) {
        temp = [string1 substringWithRange:NSMakeRange(i, symbol.length)];
        if ([temp isEqualToString:symbol]) {
            NSRange range = {i, symbol.length};
            [rangeArray addObject:NSStringFromRange(range)];
        }
    }
    return rangeArray;
}

#pragma mark HeadImage delegate
-(void)chooseAlbumImage{
    self.openImagePicker = @"album";
    UIImagePickerController *vc =[UIImagePickerController new];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 懒加载
- (NSMutableArray *)mutImgArray
{
    if (!_mutImgArray) {
        _mutImgArray = [NSMutableArray array];
    }
    return _mutImgArray;
}
- (NSMutableDictionary *)mutImgDict
{
    if (!_mutImgDict) {
        _mutImgDict = [NSMutableDictionary dictionary];
    }
    return _mutImgDict;
}
-(NSMutableArray *)imgArray
{
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}


@end
