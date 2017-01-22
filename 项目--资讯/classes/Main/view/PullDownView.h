//
//  PullDownView.h
//  项目--资讯
//
//  Created by mis on 16/9/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsTabBarViewController.h"

@interface PullDownView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *selectedTitles;
@property (nonatomic) NSMutableArray *unSelectedTitles;
@property (nonatomic) float firstCellY;
@property (nonatomic,weak) NewsTabBarViewController *delegate;

@end
