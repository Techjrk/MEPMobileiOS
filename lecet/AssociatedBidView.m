//
//  AssociatedBidView.m
//  lecet
//
//  Created by Harry Herrys Camigla on 5/17/16.
//  Copyright © 2016 Dom and TOm. All rights reserved.
//

#import "AssociatedBidView.h"

#import <MapKit/MapKit.h>

#import "associatedBidConstants.h"

@interface AssociatedBidView()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *labelProject;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;
@property (weak, nonatomic) IBOutlet UILabel *labelTag;
@end

@implementation AssociatedBidView

- (void)awakeFromNib {
    
    _labelProject.text = @"";
    _labelProject.font = ASSOCIATED_BID_LABEL_PROJECT_FONT;
    _labelProject.textColor = ASSOCIATED_BID_LABEL_PROJECT_COLOR;
    
    _labelLocation.text = @"";
    _labelLocation.font = ASSOCIATED_BID_LABEL_LOCATION_FONT;
    _labelLocation.textColor = ASSOCIATED_BID_LABEL_LOCATION_COLOR;
    
    _labelTag.font = ASSOCIATED_BID_LABEL_TAG_FONT;
    _labelTag.textColor = ASSOCIATED_BID_LABEL_TAG_COLOR;
    _labelTag.backgroundColor = ASSOCIATED_BID_LABEL_TAG_BG_COLOR;
    _labelTag.layer.cornerRadius = 4.0;
    _labelTag.layer.masksToBounds = YES;
    
    self.layer.shadowColor = [ASSOCIATED_BID_SHADOW_COLOR colorWithAlphaComponent:0.5].CGColor;
    self.layer.shadowRadius = 2;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.25;
    self.layer.masksToBounds = NO;
    self.view.layer.masksToBounds = YES;
    self.view.layer.cornerRadius = 4.0;

}

- (void)setInfo:(id)info {
    NSDictionary *infoDict = info;
    
    _labelProject.text = infoDict[ASSOCIATED_BID_NAME];
    _labelLocation.text = infoDict[ASSOCIATED_BID_LOCATION];
    
    NSString *designation = infoDict[ASSOCIATED_BID_DESIGNATION];
    _labelTag.hidden = YES;
    if (designation != nil & designation.length>0) {
        _labelTag.text = designation;
        _labelTag.hidden = NO;
    }
}

@end
