//
//  ProjectFilterBiddingView.m
//  lecet
//
//  Created by Michael San Minay on 23/06/2016.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "ProjectFilterBiddingView.h"

@interface ProjectFilterBiddingView ()

@property (weak, nonatomic) IBOutlet UIButton *checkButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation ProjectFilterBiddingView

- (void)awakeFromNib {
    
    UIImage *unselectedImage = [UIImage imageNamed:@"unSelected_icon"];
    

    //[UIImage imageNamed:@"selected_icon"]
    UIImage *selectedImage = [self createRoundedImage:[UIImage imageNamed:@"selected_icon"]];
    [_checkButton setImage:selectedImage forState:UIControlStateNormal];
    
}

- (UIImage *)createRoundedImage:(UIImage *)image {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.layer.cornerRadius = image.size.width / 2;
    imageView.layer.masksToBounds = YES;
    
    return imageView.image;
}


@end
