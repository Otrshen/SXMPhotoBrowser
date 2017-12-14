//
//  SXMPhotoCell.h
//  SXMPhotoBrowser
//
//  Created by syn on 2017/12/12.
//  Copyright © 2017年 sxm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SXMPhoto, SXMPhotoView;

@interface SXMPhotoCell : UICollectionViewCell

@property (nonatomic, strong) SXMPhoto *photo;

@property (nonatomic, strong) SXMPhotoView *photoView;

@end
