//
//  HeadLineNews.m
//  项目--资讯
//
//  Created by mis on 16/9/6.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "HeadLineNews.h"

@implementation HeadLineNews

-(instancetype)initWithResult:(FMResultSet *)result{
    if (self = [super init]) {
        self.title = [result stringForColumn:@"title"];
        self.source = [result stringForColumn:@"source"];
        self.imgsrc = [result stringForColumn:@"imgsrc"];
        self.docid = [result stringForColumn:@"docid"];
        self.TAG = [result stringForColumn:@"TAG"];
        self.pid = @([result intForColumn:@"pid"]);
    }
    return self;
}



@end
