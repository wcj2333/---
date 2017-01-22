//
//  MyCommentNewsView.h
//  项目--资讯
//
//  Created by 王陈洁 on 17/1/19.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NormalNewsParse.h"

@interface MyCommentNewsView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *sourceLB;
@property (weak, nonatomic) IBOutlet UIImageView *videoIV;
@property (weak, nonatomic) IBOutlet UILabel *commentLB;

@property (nonatomic) NormalNewsParse *model;
@property (nonatomic) NSArray *photosets;
@property (nonatomic) NSString *albumPath;
@property (nonatomic) NSNumber *countNum;
@property (nonatomic) NSString *source;

@end
