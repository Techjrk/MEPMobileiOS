//
//  CustomActivityIndicatorView.m
//  lecet
//
//  Created by Michael San Minay on 09/05/2017.
//  Copyright © 2017 Dom and TOm. All rights reserved.
//

#import "CustomActivityIndicatorView.h"

#pragma mark - FONT
#define FONT_TITLE          fontNameWithSize(FONT_NAME_LATO_BOLD, 9)

#pragma mark - COLOR
#define COLOR_FONT_TITLE    RGB(252,157,31)

@interface CustomActivityIndicatorView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *loadingImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CustomActivityIndicatorView
-
(instancetype)init {
    self = [super init];
    if (self) {
        [self setNeedsDisplay];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.hidden = YES;
    
    self.titleLabel.text = NSLocalizedLanguage(@"CAIV_TITLE");
    self.titleLabel.font = FONT_TITLE;
    self.titleLabel.textColor = COLOR_FONT_TITLE;
    
}

- (void)startAnimating {
    [self startRotateAnimation:self.loadingImageView];
}

- (void)stopAnimating {
    [self stopRotateAnimate:self.loadingImageView];
    [self animateDisplay:self.loadingImageView];
    [self animateDisplay:self.imageView];
}

#pragma mark - Image Rotation

- (void) startRotateAnimation: (UIView *) view {
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
    rotation.duration = 1.1; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
    [view.layer addAnimation:rotation forKey:@"Spin"];
    
    self.hidden = NO;
}

- (void) stopRotateAnimate: (UIView *) view {
    [view.layer removeAnimationForKey:@"Spin"];
    //[self animateDisplay:self.loadingImageView];
    
}

- (void) animateDisplay: (UIView *) view {
    view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    view.alpha = 0.0;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        view.alpha = 1;
        view.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        if (finished) {
            self.hidden = YES;
        }
    }];
}



@end
