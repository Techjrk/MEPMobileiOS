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
@property (weak, nonatomic) IBOutlet UIView *containerBidStatus;
@property (weak, nonatomic) IBOutlet UIView *containerCompany;
@end

@implementation CustomCallOut

- (void)awakeFromNib {
    
    _containerBidStatus.backgroundColor = CALLOUT_BID_STATUS_CLOSE_COLOR;
    _containerCompany.backgroundColor = CALLOUT_COMPANY_COLOR;
    
}

@end
