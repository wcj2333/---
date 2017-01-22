//
//  BaseNewsUtils.m
//  项目--资讯
//
//  Created by mis on 16/9/16.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "BaseNewsUtils.h"
#import <AFNetworking/AFNetworking.h>

@implementation BaseNewsUtils

+(void)GET:(NSString *)path andParams:(NSDictionary *)dic andCallBack:(myBlock)callBack{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功");
        callBack(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
        callBack(nil);
    }];
    
}
+(void)toastview:(NSString *)title{
    
    [[UIApplication sharedApplication].keyWindow makeToast:title duration:1.0 position:CSToastPositionCenter];
    
}
+(long)getSystemCurrentTime{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];//转为字符型
    return [timeString longLongValue];
}


+(NSString *)transFormCurrentTimeWithIn_time:(long)time{
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString *timeString=[formatter stringFromDate:d];
    
    return timeString;
}

+(UIColor *)colorRGB:(NSString *)color{
    // 转换成标准16进制数
    NSString *newColor = [color stringByReplacingCharactersInRange:[color rangeOfString:@"#"] withString:@"0x"];
    // 十六进制字符串转成整形。
    long colorLong = strtoul([newColor cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
    int R = (colorLong & 0xFF0000 )>>16;
    int G = (colorLong & 0x00FF00 )>>8;
    int B =  colorLong & 0x0000FF;
    UIColor *rgbColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
    return rgbColor;
}

+(BOOL)isMobile:(NSString *)mobileNumbel{
    /**
          * 手机号码
          * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
          * 联通：130,131,132,152,155,156,185,186
          * 电信：133,1349,153,180,189,181(增加)
          */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
          10         * 中国移动：China Mobile
          11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
          12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
          15         * 中国联通：China Unicom
          16         * 130,131,132,152,155,156,185,186
          17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
          20         * 中国电信：China Telecom
          21         * 133,1349,153,180,189,181(增加)
          22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    return NO;
}



@end
