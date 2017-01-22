//
//  NormalNewsParse.m
//  项目--资讯
//
//  Created by mis on 16/9/10.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "NormalNewsParse.h"

@implementation NormalNewsParse

-(instancetype)initWithParseNewsContentWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.body = dic[@"body"];
        self.img= dic[@"img"];
        self.title= dic[@"title"];
        self.source= dic[@"source"];
        self.ptime= dic[@"ptime"];
        self.shareLink = dic[@"shareLink"];
    }
    return self;
}

@end
