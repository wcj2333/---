//
//  FilterView.h
//  项目--资讯
//
//  Created by 王陈洁 on 17/1/23.
//  Copyright © 2017年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterViewDelegate <NSObject>

-(void)searchArticlesWithCategory:(NSString *)category;

@end

@interface FilterView : UIView<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>

@property (nonatomic) UIButton *filterButton;
@property (nonatomic) NSArray *categorys;
@property (nonatomic) id<FilterViewDelegate> filterViewDelegate;
@property (nonatomic) UIViewController *vc;

@end
