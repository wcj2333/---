//
//  SaveTableViewController.m
//  项目--资讯
//
//  Created by mis on 16/9/23.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "SaveTableViewController.h"
#import "SqliteUtils.h"
#import "NormalCell.h"
#import "HeadLineNews.h"
#import "NormalNewsViewController.h"
#import "VideoPlayerViewController.h"

@interface SaveTableViewController ()

@property (nonatomic) NSMutableArray *newsArr;
@property (nonatomic) CGFloat normalCellH;

@end

@implementation SaveTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"收藏";
    self.tableView.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:@"NormalCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NormalCell"];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[SqliteUtils shareManager]findAllPersons:^(id obj) {
        self.newsArr = obj;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.newsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NormalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];
    HeadLineNews *news = self.newsArr[self.newsArr.count-1-indexPath.row];
    cell.headLineNews = news;
    self.normalCellH = cell.cellH;
    cell.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);

    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.normalCellH;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击查看详情
    HeadLineNews *news = self.newsArr[self.newsArr.count-1-indexPath.row];
    if ([news.TAG isEqualToString:@"photoset"]) {//存在
        NormalNewsViewController *vc = [NormalNewsViewController new];
        vc.ad_url = news.docid;
        vc.news = news;
        vc.type = @"photoset";
        [self.navigationController pushViewController:vc animated:YES];
    }else if(!news.videoID){//没有视频播放信息 那么该视频是有文本内容的
        NormalNewsViewController *vc = [NormalNewsViewController new];
        vc.ad_url = news.docid;
        vc.news = news;
        vc.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VideoPlayerViewController *vc = [VideoPlayerViewController new];
        vc.videoID = news.videoID;
        NSDictionary *videoInfoDic = news.videoinfo;
        NSDictionary *videoTopic = videoInfoDic[@"videoTopic"];
        vc.tid = videoTopic[@"tid"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
