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
@property (nonatomic, strong) UIImageView *zoomingImageView;
@property (nonatomic, assign) BOOL zoomByDoubleTap;
@end

@implementation SXMPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95];
        
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
    [self setZoomScale:1 animated:YES];
}

#pragma mark - 手势事件

//单击隐藏
- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    // 通知代理
    if ([_photoViewDelegate respondsToSelector:@selector(photoViewSingleTap:)]) {
        [_photoViewDelegate photoViewSingleTap:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SXMPhotoViewSingleTapNotification object:self];
}

//双击放大
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    if (self.zoomScale == self.maximumZoomScale) {
        [self setZoomScale:1 animated:YES];
    } else {
        CGPoint zoomPoint = [tap locationInView:self.zoomingImageView];
        CGRect zoomRect = CGRectMake(zoomPoint.x, zoomPoint.y, 0, 0);
        [self zoomToRect:zoomRect animated:YES];
    }
}

#pragma mark - 私有方法

- (void)pm_setupUI
{
    self.delegate = self;
    self.minimumZoomScale = 0.8f;
    self.maximumZoomScale = 3;
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
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
    self.contentSize = self.bounds.size;
    
    self.zoomingImageView.image = self.p.image;
    CGSize imageSize = self.zoomingImageView.image.size;
    CGFloat imageViewH = self.bounds.size.height;
    if (imageSize.width > 0) {
        imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);
    }
    self.zoomingImageView.bounds = CGRectMake(0, 0, self.bounds.size.width, imageViewH);
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
    CGRect frame = self.zoomingImageView.frame;
    
    frame.origin.y = (self.frame.size.height - self.zoomingImageView.frame.size.height) > 0 ? (self.frame.size.height - self.zoomingImageView.frame.size.height) * 0.5 : 0;
    frame.origin.x = (self.frame.size.width - self.zoomingImageView.frame.size.width) > 0 ? (self.frame.size.width - self.zoomingImageView.frame.size.width) * 0.5 : 0;
    self.zoomingImageView.frame = frame;
    
    self.contentSize = CGSizeMake(self.zoomingImageView.frame.size.width, self.zoomingImageView.frame.size.height);
}

#pragma mark - lazy

- (UIImageView *)zoomingImageView
{
    if (!_zoomingImageView) {
        _zoomingImageView = [[UIImageView alloc] init];
        _zoomingImageView.center = self.center;
        _zoomingImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_zoomingImageView];
    }
    return _zoomingImageView;
}

@end
