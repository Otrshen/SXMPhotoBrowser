//
//  SXMPhotoView.m
//  SXMPhotoBrowser
//
//  Created by syn on 2017/12/11.
//  Copyright © 2017年 sxm. All rights reserved.
//

#import "SXMPhotoView.h"
#import "SXMPhoto.h"
#import "SXMPhotoBrowserConst.h"

@interface SXMPhotoView () <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) SXMPhoto *p;
@property (nonatomic, strong) UIScrollView *subScrollView;
@property (nonatomic, strong) UIImageView *zoomingImageView;
@property (nonatomic, assign) BOOL zoomByDoubleTap;
@property (nonatomic, assign) NSInteger touchFingerNumber;
@end

@implementation SXMPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self pm_setupUI];
    }
    return self;
}

- (void)setPhoto:(SXMPhoto *)photo
{
    self.p = photo;
    
    [self pm_setImageView];
}

// 清除缩放
- (void)eliminateScale
{
    [self.subScrollView setZoomScale:1 animated:YES];
}

#pragma mark - 手势事件

// 单击
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    [self pm_singleTap];
}

// 双击放大
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    if (self.subScrollView.zoomScale == self.subScrollView.maximumZoomScale) {
        [self.subScrollView setZoomScale:1 animated:YES];
    } else {
        CGPoint zoomPoint = [tap locationInView:self.zoomingImageView];
        CGRect zoomRect = CGRectMake(zoomPoint.x, zoomPoint.y, 0, 0);
        [self.subScrollView zoomToRect:zoomRect animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.zoomingImageView;
}

//开始缩放
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    
}
//结束缩放
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.zoomingImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    if ((contentOffsetY < 0 && _touchFingerNumber == 1) && (velocity.y < 0 && fabs(velocity.y) > fabs(velocity.x))) {
        //如果是向下滑动才触发消失的操作。
        [self pm_singleTap];
    } else {
        [self changeSizeCenterY:0.0];
        CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
        CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
        self.zoomingImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    }
    _touchFingerNumber = 0;
    self.subScrollView.clipsToBounds = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    UIPanGestureRecognizer *subScrollViewPan = [scrollView panGestureRecognizer];
    _touchFingerNumber = subScrollViewPan.numberOfTouches;
    _subScrollView.clipsToBounds = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    NSLog(@"%d", (int)contentOffsetY);
    
    //只有是一根手指事件才做出响应。
    if (contentOffsetY < 0 && _touchFingerNumber == 1) {
        [self changeSizeCenterY:contentOffsetY];
    }
}

- (void)changeSizeCenterY:(CGFloat)contentOffsetY {
    //contentOffsetY 为负值
    CGFloat multiple = (kSXMScreenHeight + contentOffsetY * 1.75) / kSXMScreenHeight;
    
    if ([self.photoViewDelegate respondsToSelector:@selector(photoViewTouchMoveChangeAlpha:)]) {
        [self.photoViewDelegate photoViewTouchMoveChangeAlpha:multiple];
    }
    
    multiple = multiple > 0.4 ? multiple : 0.4;
    self.subScrollView.transform = CGAffineTransformMakeScale(multiple, multiple);
    self.subScrollView.center = CGPointMake(kSXMScreenWidth / 2, kSXMScreenHeight / 2 - contentOffsetY * 0.5);
    
//    if ([self.deleagte respondsToSelector:@selector(imageBrowserSubViewTouchMoveChangeMainViewAlpha:)]) {
//        [self.deleagte imageBrowserSubViewTouchMoveChangeMainViewAlpha:multiple];
//    }
//    multiple = multiple>0.4?multiple:0.4;
//    self.subScrollView.transform = CGAffineTransformMakeScale(multiple, multiple);
//    self.subScrollView.center = CGPointMake(Screen_Width/2, Screen_Height/2 - contentOffsetY*0.5);
}

#pragma mark - 私有方法

- (void)pm_setupUI
{
    self.backgroundColor = [UIColor clearColor];
    
    // 监听点击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    [self addGestureRecognizer:singleTap];
    [self addGestureRecognizer:doubleTap];
}

- (void)pm_setImageView
{
//    self.contentSize = self.bounds.size;
    
    self.zoomingImageView.image = self.p.image;
    CGSize imageSize = self.zoomingImageView.image.size;
    CGFloat imageViewH = self.bounds.size.height;
    if (imageSize.width > 0) {
        imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);
    }
    
    self.zoomingImageView.bounds = CGRectMake(0, 0, self.bounds.size.width, imageViewH);
}

// 单击
- (void)pm_singleTap
{
    // 通知代理
    if ([_photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
        [_photoViewDelegate photoViewSingleTap:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SXMPhotoViewSingleTapNotification object:self];
}

#pragma mark - lazy

- (UIScrollView *)subScrollView
{
    if (!_subScrollView) {
        _subScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _subScrollView.backgroundColor = [UIColor clearColor];
        _subScrollView.delegate = self;
        _subScrollView.minimumZoomScale = 0.8f;
        _subScrollView.maximumZoomScale = 3;
        _subScrollView.alwaysBounceVertical = YES;//设置上下回弹
        _subScrollView.showsVerticalScrollIndicator = NO;
        _subScrollView.showsHorizontalScrollIndicator = NO;
        _subScrollView.contentSize = self.bounds.size;
        [self addSubview:_subScrollView];
    }
    return _subScrollView;
}

- (UIImageView *)zoomingImageView
{
    if (!_zoomingImageView) {
        _zoomingImageView = [[UIImageView alloc] init];
        _zoomingImageView.center = self.center;
        _zoomingImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.subScrollView addSubview:_zoomingImageView];
    }
    return _zoomingImageView;
}

@end
