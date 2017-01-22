//
//  NewsUtils.m
//  项目--资讯
//
//  Created by mis on 16/9/6.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "NewsUtils.h"
#import <JSONModel.h>
#import <AFNetworking.h>
#import "HeadLineNews.h"
#import "HeadImgeNews.h"
#import "NormalNewsParse.h"
#import "BaseNewsUtils.h"

@implementation NewsUtils

+(void)getHeadNewsWithItem:(NSString *)item WithIndex:(NSInteger)index andCompletion:(myBlock)callBack{
    //头条
    NSString *path = nil;
    if ([item isEqualToString:@"T1348647853363"]) {
        path = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/T1348647853363/%ld-%ld.html?from=toutiao&passport=tg%%2BXeARESp%%2BKk1cvff3CYYHneQ4Vgz8zRIWyqxFlJl4%%3D&devId=vLWbfIXxCa1CK9%%2B20Q0f98IOSn9ZTn2pjLRXOOBn3fttg3OsEQzfSL238z3USCkJ&size=20&version=5.5.0&spever=false&net=wifi&lat=&lon=&ts=1451223862&sign=W1v%%2BccS4kqTPNo1XoI1hRA7NJTZ9WFoR3TGwx3F1fDB48ErR02zJ6%%2FKXOnxX046I&encryption=1&canal=appstore",index,index+20];
    }else{
        path = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/list/%@/%ld-%ld.html?from=toutiao&passport=tg%%2BXeARESp%%2BKk1cvff3CYYHneQ4Vgz8zRIWyqxFlJl4%%3D&devId=vLWbfIXxCa1CK9%%2B20Q0f98IOSn9ZTn2pjLRXOOBn3fttg3OsEQzfSL238z3USCkJ&size=20&version=5.5.0&spever=false&net=wifi&lat=&lon=&ts=1451223862&sign=W1v%%2BccS4kqTPNo1XoI1hRA7NJTZ9WFoR3TGwx3F1fDB48ErR02zJ6%%2FKXOnxX046I&encryption=1&canal=appstore",item,index,index+20];
    }
    
    
    [BaseNewsUtils GET:path andParams:nil andCallBack:^(id obj) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:obj options:0 error:nil];
        NSArray *headArr = dic[item];
        NSArray *headNews = [HeadLineNews arrayOfModelsFromDictionaries:headArr error:nil];
        callBack(headNews);

    }];
    
}

+(void)getHeadImageNewsWithPicID:(NSString *)picID andCompletion:(myBlock)callBack{
    NSString *one = [picID substringFromIndex:4];
    NSArray *components = [one componentsSeparatedByString:@"|"];
    NSString *path = [@"http://c.m.163.com/photo/api/set/" stringByAppendingFormat:@"%@/%@.json",components[0],components[1]];
    [BaseNewsUtils GET:path andParams:nil andCallBack:^(id obj) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:obj options:0 error:nil];
        NSArray *photos = dic[@"photos"];
        NSArray *photoNews = [HeadImgeNews arrayOfModelsFromDictionaries:photos error:nil];
        callBack(photoNews);
        
    }];
    
}

+(void)getPhotosetInfoWithSource:(NSString *)source andCallBack:(myBlock)callBack{
    
    NSString *one = [source substringFromIndex:4];
    NSArray *components = [one componentsSeparatedByString:@"|"];
    NSString *path = [@"http://c.m.163.com/photo/api/set/" stringByAppendingFormat:@"%@/%@.json",components[0],components[1]];
    
    [BaseNewsUtils GET:path andParams:nil andCallBack:^(id obj) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:obj options:0 error:nil];
        NSString *title = dic[@"setname"];
        NSString *photo = dic[@"cover"];
        NSString *source = dic[@"source"];
        callBack(@[title,photo,source]);
    }];


}

+(void)getHeadLineNewsWithDocid:(NSString *)docID andCompletion:(myBlock)callBack{
    NSString *path = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",docID];
    
    [BaseNewsUtils GET:path andParams:nil andCallBack:^(id obj) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:obj options:0 error:nil];
        NSDictionary *contentDic = dic[docID];
        NormalNewsParse *parse = [[NormalNewsParse alloc]initWithParseNewsContentWithDic:contentDic];
        callBack(parse);
        
    }];
    
}

+(void)getHeadLineVideoWithTid:(NSString *)tid andVideoID:(NSString *)videoID andCompletion:(myBlock)callBack{
    NSString *path = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/list/%@/0-20.html",tid];
    
    
    [BaseNewsUtils GET:path andParams:nil andCallBack:^(id obj) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:obj options:0 error:nil];
        NSArray *dataArr = dic[tid];
        for (int i = 0; i<dataArr.count; i++) {
            NSDictionary *videoDic = dataArr[i];
            NSString *vid = videoDic[@"videoID"];
            if ([vid isEqualToString:videoID]) {
                NSDictionary *videoInfoDic = videoDic[@"videoinfo"];
                //获取对应视频的网址
                NSString *videoPath = videoInfoDic[@"mp4_url"];
                callBack(videoPath);
            }
            
        }
        
    }];

}
+(void)getRecommendWithSize:(NSInteger)size withCompletion:(myBlock)callBack{
    NSString *path = [NSString stringWithFormat:@"http://c.m.163.com/recommend/getSubDocPic?from=yuedu&passport=&devId=vLWbfIXxCa1CK9%%2B20Q0f98IOSn9ZTn2pjLRXOOBn3fttg3OsEQzfSL238z3USCkJ&size=%ld&version=5.5.0&spever=false&net=wifi&lat=&lon=&ts=1452345806&sign=Vf9VSXMe%%2FiPTnV%%2FkraURuEGN6C35Qa4lVvtutXIvCjJ48ErR02zJ6%%2FKXOnxX046I&encryption=1&canal=appstore",size];
    ;
    
    [BaseNewsUtils GET:path andParams:nil andCallBack:^(id obj) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:obj options:0 error:nil];
        NSArray *arr = dic[@"推荐"];
        NSArray *recomArr = [HeadLineNews arrayOfModelsFromDictionaries:arr error:nil];
        
        callBack(recomArr);
        
    }];

}
+(void)getSubscribeWithTid:(NSString *)tid andIndex:(NSInteger)index andCompletion:(myBlock)callBack{
    NSString *path = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/list/%@/%ld-%ld.html",tid,index,index+20];
    
    [BaseNewsUtils GET:path andParams:nil andCallBack:^(id obj) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:obj options:0 error:nil];
        NSArray *dataArr = dic[tid];
        NSArray *headNews = [HeadLineNews arrayOfModelsFromDictionaries:dataArr error:nil];
        callBack(headNews);
        
    }];

}


@end
