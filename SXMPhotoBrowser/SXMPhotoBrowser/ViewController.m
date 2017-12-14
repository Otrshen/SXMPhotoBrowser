//
//  ViewController.m
//  SXMPhotoBrowser
//
//  Created by syn on 2017/12/11.
//  Copyright © 2017年 sxm. All rights reserved.
//

#import "ViewController.h"
#import "SXMPhotoBrowser.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.iconImage.userInteractionEnabled = YES;
    self.iconImage.backgroundColor = [UIColor yellowColor];
    
    // 单击图片
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
    [self.iconImage addGestureRecognizer:singleTap];
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    SXMPhotoBrowser *photo = [[SXMPhotoBrowser alloc] init];
    
    SXMPhoto *p = [[SXMPhoto alloc] init];
    p.image = [UIImage imageNamed:@"test"];
    
    SXMPhoto *p1 = [[SXMPhoto alloc] init];
    p1.image = [UIImage imageNamed:@"testcompress"];
    
    SXMPhoto *p2 = [[SXMPhoto alloc] init];
    p2.image = [UIImage imageNamed:@"test1"];
    
    photo.photos = @[p, p1, p2, p, p1, p2, p, p1, p2, p, p1, p2, p, p1, p2, p, p1, p2, p, p1, p2, p, p1, p2];
    [photo show];
    
    
//    CGRect targetTemp = [self.view convertRect:self.iconImage.frame toView:self.view];
//    NSLog(@"aa:%@", NSStringFromCGRect(targetTemp));
//
//    UIImageView *temp = [[UIImageView alloc] init];
//    temp.backgroundColor = [UIColor redColor];
//    temp.frame = self.iconImage.frame;
//    [self.view addSubview:temp];
//    temp.userInteractionEnabled = YES;
//
//    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick1:)];
//    [temp addGestureRecognizer:singleTap1];
//
//
//    [UIView animateWithDuration:0.3f animations:^{
//        temp.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    }];
}

- (void)photoClick1:(UITapGestureRecognizer *)recognizer
{
    UIImageView *view = (UIImageView *)recognizer.view;
    
    [UIView animateWithDuration:0.3f animations:^{
        view.frame = self.iconImage.frame;
    }];
}



@end
