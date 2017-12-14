//
//  SXMPhotoCollectionViewController.m
//  SXMPhotoBrowser
//
//  Created by syn on 2017/12/13.
//  Copyright © 2017年 sxm. All rights reserved.
//

#import "SXMPhotoCollectionViewController.h"
#import "SXMCollectionViewCell.h"
#import "SXMPhoto.h"
#import "SXMPhotoBrowser.h"


@interface SXMPhotoCollectionViewController ()
@property (nonatomic, copy) NSArray *arr;
@end

@implementation SXMPhotoCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.collectionView registerClass:[SXMCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    SXMPhoto *p = [[SXMPhoto alloc] init];
    p.image = [UIImage imageNamed:@"test"];
    
    SXMPhoto *p1 = [[SXMPhoto alloc] init];
    p1.image = [UIImage imageNamed:@"testcompress"];
    
    SXMPhoto *p2 = [[SXMPhoto alloc] init];
    p2.image = [UIImage imageNamed:@"test1"];
    
    self.arr = @[p, p1, p2, p, p1, p2];
    
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SXMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    SXMPhoto *p = (SXMPhoto *)self.arr[indexPath.row];
    cell.imageView.image = p.image;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SXMPhotoBrowser *pb = [[SXMPhotoBrowser alloc] init];
    pb.photos = self.arr;
    pb.currentPhotoIndex = indexPath.row;
    
    [pb show];
}

@end
