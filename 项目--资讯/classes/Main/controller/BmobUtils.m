//
//  BmobUtils.m
//  项目--资讯
//
//  Created by mis on 16/9/16.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "BmobUtils.h"
#import "MyCommentObject.h"

@implementation BmobUtils

+(void)saveCommentDatasAndNewsURL:(NSString *)ad_url andContent:(NSString *)text andImage:(UIImage *)commentImage andNewsAlbum:(NSString *)albumPath{
    
    BmobObject *bObj = [BmobObject objectWithClassName:@"CommentNews"];
    //谁发的
    [bObj setObject:[BmobUser currentUser] forKey:@"user"];
    //评论的对象->哪条新闻
    [bObj setObject:ad_url forKey:@"source"];
    
    //封面图路径
    [bObj setObject:albumPath forKey:@"albumPath"];

    //判断是否有位置信息
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    CGFloat lon = [ud floatForKey:@"lon"];
    CGFloat lat = [ud floatForKey:@"lat"];
    if (lon!=0&&lat!=0) {//有位置
        //进行保存 ->位置有特殊的保存方式
        BmobGeoPoint *point = [[BmobGeoPoint alloc]initWithLongitude:lon WithLatitude:lat];
        [bObj setObject:point forKey:@"location"];
    }
    //判断是否有文字信息
    if (text) {//有文字内容
        [bObj setObject:text forKey:@"content"];
    }
    
    
    //保存一下先
    [bObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"除图片外的保存成功");
            
            //增加评论量
            //[self addCommentCount:bObj];
            
            //判断是否有图片
            if (commentImage) {//有
                {
                    
                    NSData *imageData = UIImageJPEGRepresentation(commentImage, 0.5);
                    //添加菊花
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
                    hud.label.text = @"正在上传图片";
                    [BmobFile filesUploadBatchWithDataArray:@[@{@"filename":@"a.jpg",@"data":imageData}] progressBlock:^(int index, float progress) {
                        hud.progress = progress;
                        hud.label.text = [NSString stringWithFormat:@"%d/%d",index+1,1];
                    } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {//上传成功
                            [hud hideAnimated:YES];
                            //保存图片
                            NSString *imagePath = nil;
                            BmobFile *file = array.firstObject;
                            imagePath =file.url;
                            
                            [bObj setObject:imagePath forKey:@"imagePath"];
                            
                            [bObj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                if (isSuccessful) {//更新成功
                                    NSLog(@"保存成功");
                                    [BmobUtils showErrReason:@"发送成功"];
                                    [[NSNotificationCenter defaultCenter]postNotificationName:@"评论发送完成" object:nil];
                                }else{
                                    NSLog(@"保存失败");
                                }
                            }];
                        }
                    }];
                }
                
            }else{
                [BmobUtils showErrReason:@"发送成功"];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"评论发送完成" object:nil];

            }
            
        }else{
            NSLog(@"评论:err:%@",error);
        }
    }];

    
}

+(void)addCommentCount:(BmobObject *)obj{
    //自动加1来添加字段
    [obj incrementKey:@"commentCount"];
    
    
    //更新时 对象类型的字段需要重新赋值
    [obj setObject:[BmobUser currentUser] forKey:@"user"];
    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //更新成功
            NSLog(@"发评论成功");
        }
    }];
    
}

+(void)searchCommentWithNewsURL:(NSString *)source andIsIncludeCurrentUser:(BOOL)isInclude andCallBack:(myBlock)callBack{
    BmobQuery *queue = [BmobQuery queryWithClassName:@"CommentNews"];
    //根据时间来
    [queue includeKey:@"user"];
    [queue orderByDescending:@"createdAt"];
    if (source) {
        [queue whereKey:@"source" equalTo:source];
    }
    if (isInclude == YES) {
        [queue whereKey:@"user" equalTo:[BmobUser currentUser]];
    }
    [queue findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            NSArray *comments = array;
            callBack(comments);
    }];
}

+(void)saveArticleWithTitle:(NSString *)title andContent:(NSString *)content andCategory:(NSString *)category andAlbum:(UIImage *)image andCallBack:(myBlock)callBack{
    BmobObject *bobj = [BmobObject objectWithClassName:@"Article"];
    [bobj setObject:[BmobUser currentUser] forKey:@"user"];
    //保存标题
    [bobj setObject:title forKey:@"title"];
    //保存内容
    [bobj setObject:content forKey:@"content"];
    //保存分类
    if ([category isEqualToString:@"选择分类"]) {
        //就默认存储无分类
        [bobj setObject:@"无分类" forKey:@"category"];
    }else{
        [bobj setObject:category forKey:@"category"];
    }
    
    //先保存一下
    [bobj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {//保存成功
            if (image) {//如果
                {//有
                    {
                        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                        //添加菊花
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                        hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
                        hud.label.text = @"正在上传图片";
                        [BmobFile filesUploadBatchWithDataArray:@[@{@"filename":@"a.jpg",@"data":imageData}] progressBlock:^(int index, float progress) {
                            hud.progress = progress;
                            //hud.label.text = [NSString stringWithFormat:@"%d/%d",index+1,1];
                        } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {//上传成功
                                [hud hideAnimated:YES];
                                //保存图片
                                NSString *imagePath = nil;
                                BmobFile *file = array.firstObject;
                                imagePath =file.url;
                                
                                [bobj setObject:imagePath forKey:@"imagePath"];
                                
                                [bobj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                    if (isSuccessful) {//更新成功
                                        NSLog(@"保存成功");
                                        [BmobUtils showErrReason:@"发送成功"];

                                    }else{
                                        NSLog(@"保存失败");
                                    }
                                }];
                            }else{
                                NSLog(@"error:%@",error);
                            }
                        }];
                    }
                    
                }
                callBack(nil);
            }else{
                [BmobUtils showErrReason:@"发送成功"];
                callBack(nil);
            }
        }else{
            NSLog(@"error:%@",error);
        }
    }];
}

+(void)saveConsultWithContent:(NSString *)content andName:(NSString *)name andPhone:(NSString *)phone andImages:(NSArray *)images andCallBack:(myBlock)callBack{
    BmobObject *bobj = [BmobObject objectWithClassName:@"Consult"];
    [bobj setObject:[BmobUser currentUser] forKey:@"user"];
    //保存内容
    [bobj setObject:content forKey:@"content"];
    //保存联系人
    [bobj setObject:name forKey:@"name"];
    //保存联系电话
    [bobj setObject:phone forKey:@"phone"];
    //是否处理
    [bobj setObject:@"处理中" forKey:@"handle"];
    
    //先保存一下
    [bobj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {//保存成功
            if (images) {//如果有图片
                
                NSMutableArray *imageDatas = [NSMutableArray array];
                for (UIImageView *iv in images) {
                    NSData *imageData = UIImageJPEGRepresentation(iv.image, 0.5);
                    NSDictionary *dic = @{@"filename":@"a.jpg",@"data":imageData};
                    [imageDatas addObject:dic];
                }
                
                //添加菊花
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
                hud.label.text = @"正在上传图片";
                [BmobFile filesUploadBatchWithDataArray:imageDatas progressBlock:^(int index, float progress) {
                    hud.progress = progress;
                    hud.label.text = [NSString stringWithFormat:@"%d/%d",index+1,1];
                } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {//上传成功
                        [hud hideAnimated:YES];
                        //保存图片
                        //准备装图片路径的数组
                        NSMutableArray *imagePaths = [NSMutableArray array];
                        for (BmobFile *file in array) {
                            [imagePaths addObject:file.url];
                            NSLog(@"imagePath:%@",file.url);
                        }
                        [bobj setObject:imagePaths forKey:@"imagePaths"];
                        
                        [bobj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {//更新成功
                                NSLog(@"保存成功");
                                [BaseNewsUtils toastview:@"发送成功"];
                                callBack(@"成功");
                                
                            }else{
                                callBack(nil);
                                NSLog(@"保存失败");
                            }
                        }];
                    }else{
                        callBack(nil);
                        NSLog(@"error:%@",error);
                    }
                }];
            }
        }else{
            callBack(nil);
            NSLog(@"error:%@",error);
        }
    }];

}

+(void)searchAllArticlesWithCurrentUser:(BOOL)isInclude andCallBack:(myBlock)callBack{
    BmobQuery *queue = [BmobQuery queryWithClassName:@"Article"];
    //根据时间来
    [queue includeKey:@"user"];
    queue.limit = 10;
    [queue orderByDescending:@"createdAt"];
    if (isInclude == YES) {//查看当前用户发表的文章
        [queue whereKey:@"user" equalTo:[BmobUser currentUser]];
    }
    [queue findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        NSArray *comments = array;
        callBack(comments);
    }];

}

+(void)parseArticleWithText:(NSString *)text andmutImgArray:(NSMutableArray *)mutImgArray andimageSize:(CGSize)imageSize andCallBack:(myBlock)callBack{
    __block NSString *textStr = text;
    __block int index = 0;
    NSMutableArray *imageDatas = [NSMutableArray array];
    //获取所有图片的路径
    for (UIImage *image in mutImgArray) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        [imageDatas addObject:@{@"filename":@"a.jpg",@"data":imageData}];
    }
    [BmobFile filesUploadBatchWithDataArray:imageDatas progressBlock:^(int index, float progress) {
        
    } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {//上传成功
            //成功以后
            NSMutableArray *imagePaths = [NSMutableArray array];
            for (BmobFile *file in array) {
                [imagePaths addObject:file.url];
            }
            for(int i = 0;i<textStr.length;i++){
            //保存好以后就要回传
            NSMutableString *tempStr = [[textStr substringWithRange:NSMakeRange(i, 1)] mutableCopy];
            if ([tempStr isEqualToString:@"["]) {
                [tempStr appendString:[textStr substringWithRange:NSMakeRange(i+1, 3)]];
                if ([tempStr isEqualToString:@"[图片]"]) {
                    NSString *imgStr = [NSString stringWithFormat:@"<img src = '%@'  width=\"%f\" height=\"%f\"  />",imagePaths[index],imageSize.width,imageSize.height];
                    NSRange range = NSMakeRange(i,4);
                    textStr = [textStr stringByReplacingCharactersInRange:range withString:imgStr];
                    //textStr = [textStr stringByReplacingOccurrencesOfString:@"[图片]" withString:imgStr];
                    index++;
                    i+=imgStr.length;
                    }
                }
            }
            callBack(textStr);
        }
    }];    
    
}

+(void)showErrReason:(NSString *)text{
    UILabel *errLB = [[UILabel alloc]initWithFrame:CGRectMake(Margin, 200, MainScreenW-2*Margin, 60)];
    errLB.text = text;
    errLB.backgroundColor = [UIColor blackColor];
    errLB.textColor = [UIColor whiteColor];
    errLB.layer.cornerRadius = 10;
    errLB.textAlignment = NSTextAlignmentCenter;
    [[UIApplication sharedApplication].keyWindow addSubview:errLB];
    [UIView animateWithDuration:5.0 animations:^{
        errLB.alpha = 0;
    }];
    
}

@end
