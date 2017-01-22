//
//  NewsUtils.h
//  项目--资讯
//
//  Created by mis on 16/9/6.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^myBlock)(id obj);
@interface NewsUtils : NSObject

//获取不同类型的新闻
+(void)getHeadNewsWithItem:(NSString *)item WithIndex:(NSInteger)index andCompletion:(myBlock)callBack;
//获取图集的详细新闻内容
+(void)getHeadImageNewsWithPicID:(NSString *)picID andCompletion:(myBlock)callBack;
//获取正常新闻内容
+(void)getHeadLineNewsWithDocid:(NSString *)docID andCompletion:(myBlock)callBack;
//播放视频
+(void)getHeadLineVideoWithTid:(NSString *)tid andVideoID:(NSString *)videoID andCompletion:(myBlock)callBack;
//推荐内容
+(void)getRecommendWithSize:(NSInteger)size withCompletion:(myBlock)callBack;
//得到推荐页面中的订阅里的相关内容
+(void)getSubscribeWithTid:(NSString *)tid andIndex:(NSInteger)index andCompletion:(myBlock)callBack;
//获取评论下 图集标题与封面图
+(void)getPhotosetInfoWithSource:(NSString *)source andCallBack:(myBlock)callBack;

@end
