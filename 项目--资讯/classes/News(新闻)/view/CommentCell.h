//
//  CommentCell.h
//  项目--资讯
//
//  Created by mis on 16/9/16.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BmobModel.h"

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nickLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;
@property (nonatomic) UILabel *textLB;
@property (nonatomic) UIImageView *commentIV;
@property (nonatomic) float cellHeight;

@property (nonatomic) BmobModel *model;

@end
