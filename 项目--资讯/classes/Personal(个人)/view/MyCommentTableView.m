//
//  MyCommentView.m
//  项目--资讯
//
//  Created by 王陈洁 on 17/1/19.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import "MyCommentTableView.h"
#import "MyCommentCell.h"

@implementation MyCommentTableView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.dataSource = self;
        self.delegate = self;
        
        self.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
        self.tableFooterView = [[UIView alloc]init];
        
        [self registerNib:[UINib nibWithNibName:@"MyCommentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CommentCell"];
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.comments.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    if ([self.commentNews[indexPath.section] isKindOfClass:[NSArray class]]) {
        cell.photosets = self.commentNews[indexPath.section];
    }else{
        cell.newsParse = self.commentNews[indexPath.section];
    }
    cell.countNum = self.commentCounts[indexPath.section];
    cell.model = self.comments[indexPath.section];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BmobModel *model = self.comments[indexPath.section];
    
    return model.cellHeight+5+80;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MainScreenW, 10)];
    view.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.comments.count-1) {
        return 0;
    }
    return 10;
}


-(void)setCommentCounts:(NSArray *)commentCounts{
    _commentCounts = commentCounts;
    if (self.commentNews) {
        [self reloadData];
    }
}
-(void)setCommentNews:(NSArray *)commentNews{
    _commentNews = commentNews;
    if (self.commentCounts) {
        [self reloadData];
    }
}

@end
