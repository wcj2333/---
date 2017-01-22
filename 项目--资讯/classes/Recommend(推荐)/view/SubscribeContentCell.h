//
//  SubscribeContentCell.h
//  项目--资讯
//
//  Created by mis on 16/9/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadLineNews.h"

@interface SubscribeContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UIImageView *imgIV;
@property (weak, nonatomic) IBOutlet UILabel *digestLB;

@property (nonatomic) HeadLineNews *news;

@end
