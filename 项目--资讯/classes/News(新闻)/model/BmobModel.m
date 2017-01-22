//
//  BmobModel.m
//  项目--资讯
//
//  Created by mis on 16/9/17.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "BmobModel.h"
#import "UIView+Extend.h"

@implementation BmobModel

-(instancetype)initWithObj:(BmobObject *)obj{
    if (self = [super init]) {
        self.obj = obj;
        self.source = [obj objectForKey:@"source"];
        self.imagePath = [obj objectForKey:@"imagePath"];
        self.createAt = obj.createdAt;
        self.user = [obj objectForKey:@"user"];
        self.commentCount = [[obj objectForKey:@"commentCount"] intValue];
        self.location = [obj objectForKey:@"location"];
        self.text = [obj objectForKey:@"content"];
        self.albumPath = [obj objectForKey:@"albumPath"];
    }
    return self;
}

-(float)cellHeight{
    if (_cellHeight == 0) {
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MainScreenW-2*8, 0)];
        if (self.text.length>0) {
            lb.text = self.text;
            
        }else{
            lb.text = @"[发送了一张图片]";
        }
        lb.numberOfLines = 0;
        [lb sizeToFit];
        NSLog(@"label:%@~%@",lb.text,NSStringFromCGRect(lb.frame));
        
        if ([self.obj objectForKey:@"imagePath"]) {//有图片
            _cellHeight = 40 + lb.height + 100+19;
        }else{
            _cellHeight = 40 + lb.height + 16;
        }

    }
    
    return _cellHeight;
}


@end

