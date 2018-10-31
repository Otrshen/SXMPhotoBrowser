//
//  SXMPhotoCell.m
//  SXMPhotoBrowser
//
//  Created by syn on 2017/12/12.
//  Copyright © 2017年 sxm. All rights reserved.
//

#import "SXMPhotoCell.h"

@interface SXMPhotoCell ()

@end

@implementation SXMPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self pm_setupUI];
    }
    return self;
}

- (void)pm_setupUI
{
    self.photoView.photoViewDelegate = self;
}

- (void)photoViewSingleTap:(SXMPhotoView *)photoView
{
    
}

- (void)photoViewTouchMoveChangeAlpha:(CGFloat)alpha
{
    self.superview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];
}

- (void)setPhoto:(SXMPhoto *)photo
{
    _photo = photo;
    
    [self.photoView setPhoto:photo];
}

- (SXMPhotoView *)photoView
{
    if (!_photoView) {
        _photoView = [[SXMPhotoView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_photoView];
    }
    return _photoView;
}

@end
