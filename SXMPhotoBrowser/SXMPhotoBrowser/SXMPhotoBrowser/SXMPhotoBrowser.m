//
//  SXMPhotoBrowser.m
//  SXMPhotoBrowser
//
//  Created by syn on 2017/12/11.
//  Copyright © 2017年 sxm. All rights reserved.
//

#import "SXMPhotoBrowser.h"
#import "SXMPhotoCell.h"
#import "SXMPhotoView.h"
#import "SXMPhotoBrowserConst.h"

static NSString *const cellId = @"SXMPhotoCell";

@interface SXMPhotoBrowser () <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@end

@implementation SXMPhotoBrowser

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(kSXMScreenWidth, kSXMScreenHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionViewLayout = layout;
    
    [self pm_setupUI];
    
    return [super initWithFrame:CGRectMake(0, 0, kSXMScreenWidth, kSXMScreenHeight) collectionViewLayout:layout];
}

- (void)show
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentPhotoIndex inSection:0];
    [self scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)pm_setupUI
{
    NSLog(@"myself:%@", self);
    self.delegate = self;
    self.dataSource = self;
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    [self registerClass:[SXMPhotoCell class] forCellWithReuseIdentifier:cellId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoViewST) name:SXMPhotoViewSingleTapNotification object:nil];
}

- (void)photoViewST
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SXMPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.photo = self.photos[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + self.bounds.size.width * 0.5) / self.bounds.size.width;
    
    // 有过缩放的图片在拖动一定距离后清除缩放
    CGFloat margin = 150;
    CGFloat x = scrollView.contentOffset.x;
    if ((x - index * self.bounds.size.width) > margin || (x - index * self.bounds.size.width) < - margin) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
        SXMPhotoCell *cell = (SXMPhotoCell *)[self cellForItemAtIndexPath:path];
        [cell.photoView eliminateScale];
    }
    
//    if (!_willDisappear) {
//        _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
//    }
}

- (void)dealloc
{
    NSLog(@"SXMPhotoBrowser_dealloc");
}

@end
