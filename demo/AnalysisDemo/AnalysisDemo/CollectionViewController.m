//
//  CollectionViewController.m
//  AnalysisDemo
//
//  Created by 杨上尉 on 2018/9/30.
//  Copyright © 2018年 David. All rights reserved.
//

#import "CollectionViewController.h"

static NSString *const Identify = @"CollectionCell";

@interface CollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Identify forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - getter
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(100, 100);
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:Identify];
    }
    return _collectionView;
}

@end
