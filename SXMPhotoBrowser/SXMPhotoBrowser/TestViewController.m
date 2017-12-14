//
//  TestViewController.m
//  SXMPhotoBrowser
//
//  Created by syn on 2017/12/13.
//  Copyright © 2017年 sxm. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController () <UIScrollViewDelegate>

@end

@implementation TestViewController

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0, 44,320, 480)];
    
    _scrollview.backgroundColor = [UIColor grayColor];
    
    _scrollview.delegate = self;
    
    [self.view addSubview:_scrollview];
    
    
    CGSize newSize = CGSizeMake(320, 960);
    
    [_scrollview setContentSize:newSize];//_scrollview可以拖动的范围
    
    
    
    float x=0;
    
    float y=0;
    
    float width =320;
    
    float height = 1024;
    
    
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test"]];
    
    [_imageView setFrame:CGRectMake(x, y, width, height)];
    
    [_scrollview addSubview:_imageView];
    
    
    
    UITapGestureRecognizer* tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction:)];//给imageview添加tap手势
    
    tap.numberOfTapsRequired = 2;//双击图片执行tapGesAction
    
    _imageView.userInteractionEnabled=YES;
    
    [_imageView addGestureRecognizer:tap];
    
    
    
    [_scrollview setMinimumZoomScale:0.5];//设置最小的缩放大小
    
    _scrollview.maximumZoomScale = 2.0;//设置最大的缩放大小
    
    
    
    _zoomOut_In = YES;//控制点击图片放大或缩小
    
    
}

-(void)tapGesAction:(UIGestureRecognizer*)gestureRecognizer//手势执行事件

{
    
    float newscale=0.0;
    
    if (_zoomOut_In) {
        
        newscale = 2*1.5;
        
        _zoomOut_In = NO;
        
    }else
        
    {
        
        newscale = 1.0;
        
        _zoomOut_In = YES;
        
    }
    
    
    
    CGRect zoomRect = [self zoomRectForScale:newscale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
    
    NSLog(@"zoomRect:%@",NSStringFromCGRect(zoomRect));
    
    [ _scrollview zoomToRect:zoomRect animated:YES];//重新定义其cgrect的x和y值
    
    
    
}

//当UIScrollView尝试进行缩放的时候调用

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView

{
    
    return _imageView;
    
}

//当缩放完毕的时候调用

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale

{
    
    NSLog(@"结束缩放 - %f", scale);
    
}

//当正在缩放的时候调用

- (void)scrollViewDidZoom:(UIScrollView *)scrollView

{
    
    NSLog(@"正在缩放.....");
    
}


- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    
    zoomRect.size.height = [_scrollview frame].size.height / scale;
    
    zoomRect.size.width  = [_scrollview frame].size.width  / scale;
    
    
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    
    
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    
    
    return zoomRect;
    
}

@end
