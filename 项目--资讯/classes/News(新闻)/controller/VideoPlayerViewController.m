//
//  VideoPlayerViewController.m
//  项目--资讯
//
//  Created by mis on 16/9/12.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "NewsUtils.h"

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSURL *sourceMovieURL = [NSURL URLWithString:@"http://flv2.bn.netease.com/videolib3/1609/12/AvaoJ7550/SD/AvaoJ7550-mobile.mp4"];
//    
//    AVAsset *movieAsset    = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
//    //[AVURLAsset URLAssetWithURL:sourceMovieURLoptions:nil];
//    
//    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
//    
//    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
//    
//    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
//    
//    playerLayer.frame = self.view.layer.bounds;
//    
//    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//    
//    [self.view.layer addSublayer:playerLayer];
//    
//    
//    [player play];
    [NewsUtils getHeadLineVideoWithTid:self.tid andVideoID:self.videoID andCompletion:^(id obj) {
        //创建网络地址的播放项 给个网址就可以了
        NSString *urlString = obj;
        AVPlayerItem *webItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlString]];
        
        //创建播放器对象
        AVPlayer *player = [AVPlayer playerWithPlayerItem:webItem];
        //创建一个播放层--layer
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
        layer.frame = CGRectMake(0, 100, 375, 200);
        //视频播放的层 加到视图层中
        [self.view.layer addSublayer:layer];
        //播放
        [player play];

    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
