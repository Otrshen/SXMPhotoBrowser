//
//  SXMPhotoView.h
//  SXMPhotoBrowser
//
//  Created by syn on 2017/12/11.
//  Copyright © 2017年 sxm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SXMPhoto, SXMPhotoView;

@protocol SXMPhotoViewDelegate <NSObject>

- (void)photoViewSingleTap:(SXMPhotoView *)photoView;

- (void)photoViewTouchMoveChangeAlpha:(CGFloat)alpha;

@end


@interface SXMPhotoView : UIView

@property (nonatomic, weak) id<SXMPhotoViewDelegate> photoViewDelegate;

- (void)setPhoto:(SXMPhoto *)photo;

- (void)eliminateScale;

@end
