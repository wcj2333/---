//
//  PullDownView.m
//  项目--资讯
//
//  Created by mis on 16/9/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "PullDownView.h"
#import "TitleCell.h"

@implementation PullDownView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
        //初始化
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self addSubview:self.collectionView];
        self.collectionView.dk_backgroundColorPicker = DKColorPickerWithKey(BAR);
        
        //注册
        [self.collectionView registerNib:[UINib nibWithNibName:@"TitleCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"Cell"];
        //注册头视图
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
    }
    return self;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView" forIndexPath:indexPath];
    UILabel *lb = [[UILabel alloc]initWithFrame:headerView.frame];
    lb.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    lb.textColor = [UIColor grayColor];
    lb.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:lb];
    if (indexPath.section == 0) {
        lb.text = @"切换栏目";
    }else{
        CGRect frame = lb.frame;
        frame.origin.y = self.firstCellY;
        lb.frame = frame;
        lb.text = @"添加更多栏目";
    }
    return headerView;
}

//如果要设置头视图大小 一定要执行该方法
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.collectionView.bounds.size.width-10, 30);
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.selectedTitles.count;
    }
    return self.unSelectedTitles.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        NSString *title = self.selectedTitles[indexPath.row];
        cell.titleLB.text = title;
        //给第一分区的cell添加长按操作
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        cell.tag = indexPath.row;
        [cell addGestureRecognizer:longPress];
#warning 设置第二个分区视图 在选中的最后一个title下
        if (indexPath.row == self.selectedTitles.count) {
            self.firstCellY = cell.frame.origin.y;
        }
    }else{
        NSString *title = self.unSelectedTitles[indexPath.row];
        cell.titleLB.text = title;
    }
    
    return cell;
}

//选中
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {//点中未选中的 就放到选中列表中
        [self.selectedTitles addObject:self.unSelectedTitles[indexPath.row]];
        [self.unSelectedTitles removeObjectAtIndex:indexPath.row];
        //[self.collectionView reloadData];
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:self.selectedTitles.count-1 inSection:0]];
    }else{//点中后返回页面
        [self.delegate addTitle];
        self.delegate.selectIndex = indexPath.row;

    }
    
}

-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return YES;
    }else{
        return NO;
    }
}
-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    //sourceIndexPath.row-》移动的是哪一行
    id obj = self.selectedTitles[sourceIndexPath.row];
    //先删除原先位置
    [self.selectedTitles removeObjectAtIndex:sourceIndexPath.row];
    //移动到新的位置上
    [self.selectedTitles insertObject:obj atIndex:destinationIndexPath.row];
}

#pragma mark - UICollectionViewDelegateFlowLayout Delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //每个项的大小
    return CGSizeMake(90, 45);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //边距
    return UIEdgeInsetsMake(5, 5, 0, 5);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    //最小行边距
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    //最小列边距
    return 0;
}

#pragma mark method
-(void)longPressAction:(UILongPressGestureRecognizer *)gesture{
    
    
    switch ((int)gesture.state) {
        case UIGestureRecognizerStateBegan: {
            //在lb上出现删除键
            TitleCell *cell = (TitleCell *)gesture.view;
            [self createDeleteBtnWithCell:cell];
            
//            NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[gesture locationInView:self.collectionView]];
//            [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            //[self.collectionView updateInteractiveMovementTargetPosition:[gesture locationInView:gesture.view]];

            break;
        }
        case UIGestureRecognizerStateEnded: {
            //[self.collectionView endInteractiveMovement];
            break;
        }
    }
}

-(void)createDeleteBtnWithCell:(TitleCell *)cell{
//    
//    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(73, 5, 10, 10)];
//    [deleteBtn setTitle:@"x" forState:UIControlStateNormal];
//    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    deleteBtn.layer.cornerRadius = 5;
//    deleteBtn.layer.borderWidth = 1;
//    deleteBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    deleteBtn.backgroundColor = [UIColor grayColor];
//    [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
//    deleteBtn.tag = cell.tag;
//    [cell addSubview:deleteBtn];
    [self.unSelectedTitles addObject:self.selectedTitles[cell.tag]];
    [self.selectedTitles removeObjectAtIndex:cell.tag];
    //[sender removeFromSuperview];
    [self.collectionView reloadData];


}

#pragma mark 懒加载
//懒加载
-(NSMutableArray *)selectedTitles{
    if (!_selectedTitles) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if (![ud objectForKey:@"selectedTitles"]) {
            _selectedTitles = [NSMutableArray arrayWithObjects:@"头条",@"娱乐",@"体育",@"科技",@"轻松一刻",@"军事",@"财经", nil];
        }else{
            _selectedTitles = [[ud objectForKey:@"selectedTitles"] mutableCopy];
        }
    }
    return _selectedTitles;
}

-(NSMutableArray *)unSelectedTitles{
    if (!_unSelectedTitles) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if (![ud objectForKey:@"unSelectedTitles"]) {
            _unSelectedTitles = [NSMutableArray arrayWithObjects:@"手机",@"游戏",@"历史",@"社会",@"电影",@"电视",@"NBA",@"足球",@"旅游",@"汽车",@"房产",@"iphone限免", nil];
        }else{
            _unSelectedTitles = [[ud objectForKey:@"unSelectedTitles"] mutableCopy];
        }

    }
    return _unSelectedTitles;
}
@end
