//
//  ImagesCell.h
//  项目--资讯
//
//  Created by mis on 16/9/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadLineNews.h"

@interface ImagesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (weak, nonatomic) IBOutlet UILabel *sourceLB;
@property (weak, nonatomic) IBOutlet UIImageView *videoIV;
@property (weak, nonatomic) IBOutlet UILabel *commentLB;
@property (nonatomic) float imageCellH;

@property (nonatomic) float cellH;
@property (nonatomic) HeadLineNews *headLineNews;
@property (nonatomic) NSString *fontStyle;

@end
