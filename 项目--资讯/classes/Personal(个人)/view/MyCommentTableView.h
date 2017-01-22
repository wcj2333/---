//
//  MyCommentView.h
//  项目--资讯
//
//  Created by 王陈洁 on 17/1/19.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCommentTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSArray *comments;
@property (nonatomic) NSArray *commentNews;
@property (nonatomic) NSArray *commentCounts;

@end
