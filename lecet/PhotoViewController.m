//
//  PhotoViewController.m
//  lecet
//
//  Created by Harry Herrys Camigla on 3/15/17.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "PhotoViewController.h"


#define TITLE_FONT              fontNameWithSize(FONT_NAME_LATO_BOLD, 12)
#define TITLE_COLOR_BLUE        RGB(5, 31, 73)
#define TITLE_COLOR_WHITE       RGB(255, 255, 7255)

#define DETAIL_FONT             fontNameWithSize(FONT_NAME_LATO_REGULAR, 12)
#define DETAIL_COLOR_BLUE        RGB(5, 31, 73)
#define DETAIL_COLOR_WHITE       RGB(255, 255, 7255)

@interface PhotoViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation PhotoViewController
@synthesize image;
@synthesize photoTitle;
@synthesize text;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = self.image;
    
    CGRect frame = CGRectZero;
    
    if (self.image.size.width>self.image.size.height) {
        CGFloat height = (1-((self.image.size.width-self.image.size.height)/self.image.size.width)) * kDeviceWidth;
        frame = CGRectMake(0, (kDeviceHeight - height)/2.0, kDeviceWidth, height);
    } else {
        CGFloat width = (1-((self.image.size.height-self.image.size.width)/self.image.size.height)) * kDeviceHeight;
        
        CGFloat yPos = 0;
        if (self.image.size.height<kDeviceHeight) {
            yPos = (kDeviceHeight-self.image.size.height)/2;
        }
        
        frame = CGRectMake(0, yPos, width, kDeviceHeight - (yPos*2));
    }
    
    self.imageView.frame = frame;
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale=1.0;
    self.scrollView.maximumZoomScale = 6.0;
    self.scrollView.zoomScale = 1.0;
    self.scrollView.contentSize = self.imageView.frame.size;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:TITLE_FONT.pointSize * 0.6];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n",self.photoTitle]  attributes:@{NSFontAttributeName: TITLE_FONT, NSForegroundColorAttributeName: TITLE_COLOR_BLUE, NSParagraphStyleAttributeName: paragraphStyle}];
  
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName: DETAIL_FONT, NSForegroundColorAttributeName: DETAIL_COLOR_BLUE, NSParagraphStyleAttributeName: paragraphStyle}]];

    self.textView.attributedText = attributedString;
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
