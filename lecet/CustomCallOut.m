//
//  CustomCallOut.m
//  lecet
//
//  Created by Harry Herrys Camigla on 6/8/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "CustomCallOut.h"

#import "TriangleView.h"
#import "customCallOutConstants.h"

@interface CustomCallOut(){
    CGFloat cornerRadius;
}
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

@implementation CustomCallOut

- (void)awakeFromNib {
    
    _containerView.layer.cornerRadius = kDeviceWidth * 0.016;
    _containerView.layer.masksToBounds = YES;
    
    _container.layer.shadowColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5].CGColor;
    _container.layer.shadowRadius = 2;
    _container.layer.shadowOpacity = 1.0;
    _container.layer.shadowOffset = CGSizeMake(2, 2);
    _container.layer.masksToBounds = NO;

}

@end
