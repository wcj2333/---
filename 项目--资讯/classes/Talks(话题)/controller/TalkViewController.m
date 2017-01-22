//
//  TalkViewController.m
//  项目--资讯
//
//  Created by mis on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TalkViewController.h"
#import "BmobUtils.h"

@interface TalkViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) NSMutableArray *articles;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;



@end

@implementation TalkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.articles = [NSMutableArray array];
    NSString *str = [self parseHtmlWithParse:self.bobj];
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


}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.webView.scrollView.bounces = NO;
}

-(NSString *)parseHtmlWithParse:(BmobObject *)parse{
    //NSString *content = [parse objectForKey:@"content"];
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


@end
