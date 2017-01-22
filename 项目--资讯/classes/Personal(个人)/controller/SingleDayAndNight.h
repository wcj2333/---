//
//  SingleDayAndNight.h
//  项目--资讯
//
//  Created by tarena on 16/9/1.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleDayAndNight : NSObject

@property (nonatomic,getter=isNight) BOOL night;
+(SingleDayAndNight *)shareSingle;

@end
