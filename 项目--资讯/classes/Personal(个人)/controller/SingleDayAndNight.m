//
//  SingleDayAndNight.m
//  项目--资讯
//
//  Created by tarena on 16/9/1.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "SingleDayAndNight.h"

static SingleDayAndNight *_shareSingle = nil;
@implementation SingleDayAndNight

//单例
+(SingleDayAndNight *)shareSingle{
    if (!_shareSingle) {
        _shareSingle = [[SingleDayAndNight alloc]init];
    }
    return _shareSingle;
}

@end
