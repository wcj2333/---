//
//  NormalCell.h
//  项目--资讯
//
//  Created by mis on 16/9/8.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadLineNews.h"

@interface NormalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *sourceLB;
@property (weak, nonatomic) IBOutlet UIImageView *videoIV;
@property (weak, nonatomic) IBOutlet UILabel *commentLB;

@property (nonatomic) float cellH;
@property (nonatomic) HeadLineNews *headLineNews;
@property (nonatomic) NSString *fontStyle;

@end
