
//
//  ChooseLocationViewController.m
//  项目--资讯
//
//  Created by mis on 16/9/16.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ChooseLocationViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

@interface ChooseLocationViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *myMapView;


@end

@implementation ChooseLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"选择位置";
    //设置完成按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendLocation)];
}

-(void)sendLocation{
    //已经同步保存过了位置 不需要再传了
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)tapMapView:(id)sender {
    //每次点击都要先删除之前的大头针
    [self.myMapView removeAnnotations:self.myMapView.annotations];
    
    //获取点击的位置
    CGPoint point = [sender locationInView:self.view];
    //转换成经纬度
    CLLocationCoordinate2D coord = [self.myMapView convertPoint:point toCoordinateFromView:self.myMapView];
    //记住点击的经纬度
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setFloat:coord.longitude forKey:@"lon"];
    [ud setFloat:coord.latitude forKey:@"lat"];
    [ud synchronize];
    
    //在点击的位置上添加大头针
    MyAnnotation *ann = [[MyAnnotation alloc]init];
    ann.coordinate = coord;
    [self.myMapView addAnnotation:ann];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
