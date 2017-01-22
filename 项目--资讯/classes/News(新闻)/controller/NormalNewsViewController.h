//
//  NormalNewsViewController.h
//  项目--资讯
//
//  Created by mis on 16/9/10.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadLineNews.h"

@interface NormalNewsViewController : UIViewController

@property (nonatomic) NSString *ad_url;
@property (nonatomic) NSString *fontStyle;
//查看别人发送的文章传过来的值
@property (nonatomic) BmobObject *bobj;

@property (nonatomic) HeadLineNews *news;
@property (nonatomic) NSString *type;


@end
