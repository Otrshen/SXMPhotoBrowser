//
//  SXMPhotoBrowser.h
//  SXMPhotoBrowser
//
//  Created by syn on 2017/12/11.
//  Copyright © 2017年 sxm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXMPhoto.h"

@interface SXMPhotoBrowser : UICollectionView

@property (nonatomic, copy) NSArray *photos;
//@property (nonatomic, strong) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentPhotoIndex;

- (void)show;

@end
