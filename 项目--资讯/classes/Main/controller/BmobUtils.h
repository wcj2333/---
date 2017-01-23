//
//  BmobUtils.h
//  项目--资讯
//
//  Created by mis on 16/9/16.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeadLineNews.h"

typedef void(^myBlock) (id obj);

@interface BmobUtils : NSObject

//保存评论数据
+(void)saveCommentDatasAndNewsURL:(NSString *)ad_url andContent:(NSString *)text andImage:(UIImage *)commentImage andNewsAlbum:(NSString *)albumPath;
//根据新闻来源查询已有评论
+(void)searchCommentWithNewsURL:(NSString *)source andIsIncludeCurrentUser:(BOOL)isInclude andCallBack:(myBlock)callBack;

//保存发表的文章
+(void)saveArticleWithTitle:(NSString *)title andContent:(NSString *)content andCategory:(NSString *)category andAlbum:(UIImage *)image andCallBack:(myBlock)callBack;
//查看发表的文章
+(void)searchAllArticlesWithCurrentUser:(BOOL)isInclude andCallBack:(myBlock)callBack;
//解析上传上去的文章
+(void)parseArticleWithText:(NSString *)text andmutImgArray:(NSMutableArray *)mutImgArray  andimageSize:(CGSize)imageSize andCallBack:(myBlock)callBack;
//根据分类查找文章
+(void)seachAllArticlesWithCategory:(NSString *)category andCurrentUser:(BOOL)isInclude andCallBack:(myBlock)callBack;


+(void)showErrReason:(NSString *)text;

//保存意见反馈
+(void)saveConsultWithContent:(NSString *)content andName:(NSString *)name andPhone:(NSString *)phone andImages:(NSArray *)images andCallBack:(myBlock)callBack;

@end
