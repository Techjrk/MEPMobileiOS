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
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"landscape.jpg"];
    //UIImage *image = [UIImage imageNamed:@"splashImage"];

    self.imageView.image = image;
    
    CGRect frame = CGRectZero;
    
    if (image.size.width>image.size.height) {
        CGFloat height = (1-((image.size.width-image.size.height)/image.size.width)) * kDeviceWidth;
        frame = CGRectMake(0, (kDeviceHeight - height)/2.0, kDeviceWidth, height);
    } else {
        CGFloat width = (1-((image.size.height-image.size.width)/image.size.height)) * kDeviceHeight;
        
        CGFloat yPos = 0;
        if (image.size.height<kDeviceHeight) {
            yPos = (kDeviceHeight-image.size.height)/2;
        }
        
        frame = CGRectMake(0, yPos, width, kDeviceHeight - (yPos*2));
    }
    
    self.imageView.frame = frame;
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.zoomScale = 1.0;
    self.scrollView.contentSize = self.imageView.frame.size;
    
    self.buttonBack.hidden = YES;
    self.textView.hidden = YES;
    self.textView.backgroundColor = [self.textView.backgroundColor colorWithAlphaComponent:0.5];
    [self enableTapGesture:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - IBAction

- (IBAction)tappedBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - TapGesture

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {

    UIView *view = sender.view;
    CGPoint point = [sender locationInView:view];
    UIView* subview = [view hitTest:point withEvent:nil];
    
    if ([subview isEqual:self.scrollView]) {
        self.buttonBack.alpha = self.buttonBack.hidden?0:1;
        self.buttonBack.hidden = !self.buttonBack.hidden;
        
        self.textView.alpha = self.buttonBack.alpha;
        self.textView.hidden = self.buttonBack.hidden;
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.buttonBack.alpha = self.buttonBack.hidden?0:1;
            self.textView.alpha = self.buttonBack.alpha;
            
        } completion:^(BOOL finished) {
            if (finished) {
                
            }
        }];
    }
}

@end
