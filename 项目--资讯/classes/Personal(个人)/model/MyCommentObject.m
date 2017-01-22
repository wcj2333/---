//
//  MyCommentObject.m
//  项目--资讯
//
//  Created by 王陈洁 on 17/1/19.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import "MyCommentObject.h"

@implementation MyCommentObject

-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.createdAt = dic[@"createdAt"];
        self.source = dic[@"source"];
        NSDictionary *userDic = dic[@"data"];
        self.headPath = userDic[@"headPath"];
        self.nick = userDic[@"nick"];
        self.content = userDic[@"content"];
    }
    return self;
}

@end
