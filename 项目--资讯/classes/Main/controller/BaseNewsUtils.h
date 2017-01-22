//
//  BaseNewsUtils.h
//  项目--资讯
//
//  Created by mis on 16/9/16.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+Toast.h"

typedef void(^myBlock) (id obj);

@interface BaseNewsUtils : NSObject

+(void)GET:(NSString *)path andParams:(NSDictionary *)dic andCallBack:(myBlock)callBack;
+(void)toastview:(NSString *)title;
//时间转换成时间戳
+(long)getSystemCurrentTime;
//时间戳转换
+(NSString *)transFormCurrentTimeWithIn_time:(long)time;
//转成RGB形式
+(UIColor *)colorRGB:(NSString *)color;
+(BOOL)isMobile:(NSString *)mobileNumbel;

@end
