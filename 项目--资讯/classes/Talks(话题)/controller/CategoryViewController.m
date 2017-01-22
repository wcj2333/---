//
//  CategoryViewController.m
//  项目--资讯
//
//  Created by mis on 16/9/21.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "CategoryViewController.h"

@interface CategoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSArray *categorys;
@property (nonatomic) UILabel *categoryLB;

@end

@implementation CategoryViewController

#pragma mark life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
    //创建collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 30, MainScreenW, MainScreenH-30) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    self.collectionView.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
    
    
    //注册
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //注册头视图
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
}

#pragma mark UICollectionView delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.categorys.count;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView" forIndexPath:indexPath];
    UILabel *lb = [[UILabel alloc]initWithFrame:headerView.frame];
    lb.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    lb.textColor = [UIColor grayColor];
    lb.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:lb];
    lb.text = @"选择分类";
    
    return headerView;
}

//如果要设置头视图大小 一定要执行该方法
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.collectionView.bounds.size.width-10, 30);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    self.categoryLB = [[UILabel alloc]initWithFrame:cell.bounds];
    self.categoryLB.textAlignment = NSTextAlignmentCenter;
    self.categoryLB.font = [UIFont systemFontOfSize:13];
    [cell addSubview:self.categoryLB];
    
    cell.backgroundColor = [UIColor lightGrayColor];
    self.categoryLB.text = self.categorys[indexPath.row];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //将分类传回去
    NSString *text = self.categorys[indexPath.row];
    _categoryCallBack(text);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UICollectionFlowLayout delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //每个项的大小
    return CGSizeMake(75, 43);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //边距
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    //最小行边距
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    //最小列边距
    return 10;
}


#pragma mark lazyLoad
-(NSArray *)categorys{
    if (_categorys == nil) {
        _categorys = @[@"头条",@"娱乐",@"体育",@"科技",@"轻松一刻",@"军事",@"财经",@"手机",@"游戏",@"历史",@"社会",@"电影",@"电视",@"NBA",@"足球",@"旅游",@"汽车",@"房产",@"iphone限免"];
    }
    return _categorys;
}


@end
