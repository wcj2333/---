//
//  MyCommentCell.h
//  项目--资讯
//
//  Created by 王陈洁 on 17/1/19.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BmobModel.h"
#import "MyCommentNewsView.h"
#import "NormalNewsParse.h"

@interface MyCommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nickLB;
@property (weak, nonatomic) IBOutlet UILabel *detailLB;

@property (nonatomic) UILabel *textLB;
@property (nonatomic) UIImageView *commentIV;
@property (nonatomic) float cellHeight;

@property (nonatomic) BmobModel *model;
@property (nonatomic) MyCommentNewsView *commentNewsView;
@property (nonatomic) NormalNewsParse *newsParse;
@property (nonatomic) NSArray *photosets;
@property (nonatomic) NSNumber *countNum;

@end
