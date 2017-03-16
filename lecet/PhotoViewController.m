//
//  PhotoViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 3/15/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"splashImage"];
    self.imageView.image = image;
    self.imageView.frame = self.scrollView.frame;
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.zoomScale = 1.0;
    self.scrollView.contentSize = self.imageView.frame.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction

- (IBAction)tappedBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
