//
//  MyAnnotation.h
//  侧边栏
//
//  Created by tarena on 16/8/25.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyAnnotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

@end
