//
//  CategoryViewController.h
//  项目--资讯
//
//  Created by mis on 16/9/21.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^block)(NSString *content);

@interface CategoryViewController : UIViewController

@property (nonatomic,copy) block categoryCallBack;

@end
